import 'dart:math' as math;

// Evolução física (v0.2): peso, medidas com fita, valores da balança de
// bioimpedância e fotos. Valores guardados como inteiros × 1000 na unidade
// da medida (72,4 kg = 72400; 85,5 cm = 85500), como as cargas.

enum BodyMetricGroup {
  weight('Peso'),
  tape('Medidas (fita)'),
  scale('Balança de bioimpedância');

  const BodyMetricGroup(this.label);
  final String label;
}

/// O que dá para medir. O nome do enum vai para o banco: não renomeie.
enum BodyMetric {
  weight('Peso', 'kg', BodyMetricGroup.weight, 100),

  // Fita métrica (cm).
  neck('Pescoço', 'cm', BodyMetricGroup.tape, 500),
  chest('Peito', 'cm', BodyMetricGroup.tape, 500),
  waist('Cintura (parte mais fina)', 'cm', BodyMetricGroup.tape, 500),
  abdomen('Abdômen (no umbigo)', 'cm', BodyMetricGroup.tape, 500),
  hip('Quadril', 'cm', BodyMetricGroup.tape, 500),
  arm('Braço', 'cm', BodyMetricGroup.tape, 500),
  thigh('Coxa', 'cm', BodyMetricGroup.tape, 500),
  calf('Panturrilha', 'cm', BodyMetricGroup.tape, 500),

  // O que balanças de bioimpedância (ex.: OKOK) mostram.
  bodyFat('Gordura corporal', '%', BodyMetricGroup.scale, 100),
  muscleMass('Massa muscular', 'kg', BodyMetricGroup.scale, 100),
  skeletalMuscle('Músculo esquelético', '%', BodyMetricGroup.scale, 100),
  bodyWater('Água corporal', '%', BodyMetricGroup.scale, 100),
  protein('Proteína', '%', BodyMetricGroup.scale, 100),
  subcutaneousFat('Gordura subcutânea', '%', BodyMetricGroup.scale, 100),
  visceralFat('Gordura visceral', 'nível', BodyMetricGroup.scale, 1000),
  boneMass('Massa óssea', 'kg', BodyMetricGroup.scale, 100),
  bmr('Metabolismo basal', 'kcal', BodyMetricGroup.scale, 10000),
  metabolicAge('Idade metabólica', 'anos', BodyMetricGroup.scale, 1000),

  /// Leitura bruta da balança (Ω): guardada para recalcular a composição
  /// se a fórmula mudar. Não aparece para digitar.
  impedance('Impedância', 'Ω', BodyMetricGroup.scale, 1000);

  const BodyMetric(this.label, this.unit, this.group, this.stepMilli);
  final String label;
  final String unit;
  final BodyMetricGroup group;

  /// Passo do [−]/[+] (× 1000): 0,1 kg; 0,5 cm; 1 nível; 10 kcal.
  final int stepMilli;

  /// Aparece no formulário de check-in.
  bool get typed => this != impedance;

  /// Para estas, subir é bom (músculo, água); para as outras, descer.
  bool get higherIsBetter => switch (this) {
    muscleMass || skeletalMuscle || bodyWater || protein || boneMass => true,
    _ => false,
  };

  /// Medidas de "tamanho" (braço, coxa, peito): nem subir nem descer é
  /// bom por si (depende do objetivo).
  bool get neutral => switch (this) {
    chest || arm || thigh || calf || bmr || weight || impedance => true,
    _ => false,
  };
}

/// De onde veio o valor.
enum BodySource { manual, scale, healthConnect }

/// Pose da foto de progresso.
enum PhotoPose {
  front('Frente'),
  side('Lado'),
  back('Costas');

  const PhotoPose(this.label);
  final String label;
}

enum Sex {
  male('Masculino'),
  female('Feminino');

  const Sex(this.label);
  final String label;
}

double _log10(double x) => math.log(x) / math.ln10;

/// % de gordura pela fórmula da Marinha dos EUA (PLANO 7.4), medidas em cm.
/// Homens: altura, pescoço e abdômen (no umbigo). Mulheres: altura,
/// pescoço, cintura (mais fina) e quadril. Null se faltar medida ou se a
/// conta não fizer sentido (ex.: abdômen ≤ pescoço). É uma ESTIMATIVA
/// (±3,5 a 4 pontos).
double? navyBodyFat({
  required Sex sex,
  required double heightCm,
  required double? neckCm,
  double? abdomenCm,
  double? waistCm,
  double? hipCm,
}) {
  if (neckCm == null || heightCm <= 0) return null;
  final double result;
  if (sex == Sex.male) {
    if (abdomenCm == null || abdomenCm <= neckCm) return null;
    result =
        495 /
            (1.0324 -
                0.19077 * _log10(abdomenCm - neckCm) +
                0.15456 * _log10(heightCm)) -
        450;
  } else {
    if (waistCm == null || hipCm == null || waistCm + hipCm <= neckCm) {
      return null;
    }
    result =
        495 /
            (1.29579 -
                0.35004 * _log10(waistCm + hipCm - neckCm) +
                0.22100 * _log10(heightCm)) -
        450;
  }
  if (result.isNaN || result < 2 || result > 70) return null;
  return result;
}

/// IMC = peso / altura². Null sem os dois.
double? bmi({required double? weightKg, required double? heightCm}) {
  if (weightKg == null || heightCm == null || heightCm <= 0) return null;
  final m = heightCm / 100;
  return weightKg / (m * m);
}

/// Linha de tendência do peso (média móvel exponencial que respeita o
/// intervalo entre as pesagens): água e sal fazem o peso pular 1–2 kg de um
/// dia para o outro; a tendência mostra para onde ele está indo de verdade.
/// [alphaPerDay] = quanto um dia "puxa" a tendência (0,1 = 10%).
/// Entrada e saída na ordem cronológica.
List<double> weightTrend(
  List<({DateTime day, double kg})> points, {
  double alphaPerDay = 0.1,
}) {
  if (points.isEmpty) return const [];
  final result = <double>[points.first.kg];
  for (var i = 1; i < points.length; i++) {
    final days = math.max(
      1,
      points[i].day.difference(points[i - 1].day).inHours / 24,
    );
    final pull = 1 - math.pow(1 - alphaPerDay, days);
    final prev = result.last;
    result.add(prev + pull * (points[i].kg - prev));
  }
  return result;
}

/// Séries por músculo na semana (PLANO 7.6): cada série conta 1 para o
/// músculo primário e 0,5 para cada secundário. [sets] = os músculos
/// (chaves separadas por vírgula) de cada série de trabalho feita.
Map<String, double> weeklyMuscleSets(
  Iterable<({String primary, String secondary})> sets,
) {
  final result = <String, double>{};
  List<String> keys(String csv) => [
    for (final k in csv.split(','))
      if (k.trim().isNotEmpty) k.trim(),
  ];
  for (final s in sets) {
    for (final k in keys(s.primary)) {
      result[k] = (result[k] ?? 0) + 1;
    }
    for (final k in keys(s.secondary)) {
      result[k] = (result[k] ?? 0) + 0.5;
    }
  }
  return result;
}
