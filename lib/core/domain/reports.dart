import 'body.dart';
import 'cardio.dart';
import 'enums.dart';
import 'load.dart';

// Relatórios em texto para quem acompanha o aluno (docs/PERSONAS.md):
// - professor de educação física: constância, evolução de carga, dor,
//   esforço e fichas em uso;
// - médico: volume de atividade por semana, corpo (peso, IMC, cintura,
//   gordura) e dores. Sem cargas, sem fotos: só o necessário (LGPD).
//
// Tudo aqui é Dart puro: recebe os dados prontos e devolve o texto, por
// isso cada regra tem teste em test/domain/reports_test.dart.

/// Para quem é o relatório.
enum ReportAudience {
  trainer('professor', 'Relatório para o professor', 4),
  doctor('medico', 'Relatório para o médico', 12);

  const ReportAudience(this.slug, this.title, this.defaultWeeks);

  /// Pedaço da rota (`/mais/relatorio/professor`).
  final String slug;
  final String title;

  /// Período padrão: o ciclo de uma ficha (professor) ou o intervalo entre
  /// consultas (médico).
  final int defaultWeeks;

  static ReportAudience? fromSlug(String slug) =>
      values.where((a) => a.slug == slug).firstOrNull;
}

/// Uma série concluída.
class ReportSet {
  const ReportSet({
    this.type = SetType.working,
    this.loadMilli,
    this.reps,
    this.durationSec,
    this.distanceM,
  });

  final SetType type;
  final int? loadMilli;
  final int? reps;
  final int? durationSec;
  final int? distanceM;
}

/// Um exercício feito num treino.
class ReportExercise {
  const ReportExercise({
    required this.name,
    required this.sets,
    this.tracking = TrackingType.weightReps,
    this.unit = LoadUnit.kg,
    this.pain = false,
    this.effort,
    this.howItWent,
  });

  final String name;
  final TrackingType tracking;
  final LoadUnit unit;
  final List<ReportSet> sets;
  final bool pain;
  final EffortTag? effort;
  final String? howItWent;
}

/// Um treino finalizado.
class ReportSession {
  const ReportSession({
    required this.startedAt,
    required this.endedAt,
    required this.title,
    required this.exercises,
  });

  final DateTime startedAt;
  final DateTime endedAt;
  final String title;
  final List<ReportExercise> exercises;

  Duration get duration => endedAt.difference(startedAt);
}

/// Ficha de treino em uso.
class ReportRoutine {
  const ReportRoutine({required this.name, this.trainer, this.expiresOn});
  final String name;
  final String? trainer;
  final DateTime? expiresOn;
}

/// Um check-in do corpo (só as medidas preenchidas).
class ReportCheckin {
  const ReportCheckin({required this.day, required this.values});
  final DateTime day;
  final Map<BodyMetric, double> values;
}

/// Tudo o que um relatório precisa, já filtrado pelo período.
class ReportData {
  const ReportData({
    required this.studentName,
    required this.from,
    required this.to,
    this.sessions = const [],
    this.routines = const [],
    this.checkins = const [],
    this.sex,
    this.heightCm,
    this.birthYear,
  });

  final String studentName;
  final DateTime from;
  final DateTime to;

  /// Em ordem cronológica.
  final List<ReportSession> sessions;
  final List<ReportRoutine> routines;

  /// Em ordem cronológica.
  final List<ReportCheckin> checkins;
  final Sex? sex;
  final double? heightCm;
  final int? birthYear;

  /// Semanas do período (no mínimo 1), para as médias.
  double get weeks {
    final days = to.difference(from).inHours / 24;
    return days < 7 ? 1 : days / 7;
  }
}

// ───────────────────────── Formatação ─────────────────────────

String _two(int v) => v.toString().padLeft(2, '0');

/// 18/11/2026 (sem depender do locale carregado).
String reportDate(DateTime d) {
  final l = d.toLocal();
  return '${_two(l.day)}/${_two(l.month)}/${l.year}';
}

String _shortDate(DateTime d) {
  final l = d.toLocal();
  return '${_two(l.day)}/${_two(l.month)}';
}

String _signed(double v, String unit) {
  final sign = v > 0 ? '+' : (v < 0 ? '−' : '');
  return '$sign${formatNumber(v.abs())}${unit.isEmpty ? '' : ' $unit'}';
}

String _header(ReportData d, ReportAudience audience) {
  final weeks = d.weeks.round();
  return [
    'NodeFit — ${audience.title}',
    '${audience == ReportAudience.doctor ? 'Paciente' : 'Aluno(a)'}: '
        '${d.studentName}',
    'Período: ${reportDate(d.from)} a ${reportDate(d.to)} '
        '($weeks semana${weeks == 1 ? '' : 's'})',
  ].join('\n');
}

/// Bloco de constância (comum aos dois relatórios).
List<String> _consistency(ReportData d, {required bool withMinutes}) {
  final n = d.sessions.length;
  if (n == 0) return ['• Nenhum treino registrado no período.'];
  final perWeek = n / d.weeks;
  final totalMin = d.sessions.fold<int>(
    0,
    (sum, s) => sum + s.duration.inMinutes,
  );
  return [
    '• $n treino${n == 1 ? '' : 's'} '
        '(${formatNumber(double.parse(perWeek.toStringAsFixed(1)))} por semana)',
    '• Duração média: ${(totalMin / n).round()} min',
    if (withMinutes)
      '• Tempo de treino: ${(totalMin / d.weeks).round()} min/semana em média',
  ];
}

/// Treinos com dor marcada: "12/11 — Cadeira extensora: joelho".
List<String> _painLines(ReportData d) => [
  for (final s in d.sessions)
    for (final e in s.exercises)
      if (e.pain)
        '• ${_shortDate(s.startedAt)} — ${e.name}'
            '${(e.howItWent ?? '').trim().isEmpty ? '' : ': "${e.howItWent!.trim()}"'}',
];

// ───────────────────────── Professor ─────────────────────────

/// Melhor série de um exercício num treino (aquecimento não conta).
/// Carga × reps: maior carga, desempate pelas reps. Tempo/cardio: maior
/// tempo, desempate pela distância.
ReportSet? bestSet(ReportExercise e) {
  final sets = e.sets.where((s) => s.type != SetType.warmup).toList();
  if (sets.isEmpty) return null;
  int score(ReportSet s) => switch (e.tracking) {
    TrackingType.weightReps => (s.loadMilli ?? 0) * 1000 + (s.reps ?? 0),
    TrackingType.duration => s.durationSec ?? 0,
    TrackingType.cardio => (s.distanceM ?? 0) * 100000 + (s.durationSec ?? 0),
  };
  return sets.reduce((a, b) => score(b) > score(a) ? b : a);
}

String _describeSet(ReportExercise e, ReportSet s) => switch (e.tracking) {
  TrackingType.weightReps =>
    s.loadMilli == null
        ? '${s.reps ?? '—'} reps'
        : '${formatLoad(s.loadMilli, e.unit)} × ${s.reps ?? '—'}',
  TrackingType.duration => formatSeconds(s.durationSec),
  TrackingType.cardio =>
    s.distanceM == null
        ? formatSeconds(s.durationSec)
        : '${formatSeconds(s.durationSec)} · ${formatKmValue(s.distanceM)} km',
};

/// Uma linha de evolução por exercício: primeira × última vez no período.
/// Agrupa por nome + unidade, porque "placa 7" e "40 kg" não se comparam.
List<String> exerciseProgressLines(List<ReportSession> sessions) {
  final groups = <String, List<(ReportExercise, ReportSet)>>{};
  for (final s in sessions) {
    for (final e in s.exercises) {
      final best = bestSet(e);
      if (best == null) continue;
      final key = '${e.name}|${e.tracking.name}|${e.unit.name}';
      (groups[key] ??= []).add((e, best));
    }
  }
  final ordered = groups.values.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  return [
    for (final g in ordered)
      () {
        final (e, first) = g.first;
        final (_, last) = g.last;
        final times = '${g.length}× no período';
        if (g.length == 1) {
          return '• ${e.name}: ${_describeSet(e, last)} ($times)';
        }
        var delta = '';
        if (e.tracking == TrackingType.weightReps &&
            first.loadMilli != null &&
            last.loadMilli != null) {
          final diff = (last.loadMilli! - first.loadMilli!) / 1000;
          delta = diff == 0
              ? ' (mesma carga)'
              : ' (${_signed(diff, e.unit == LoadUnit.plate ? 'placa' : e.unit.label)})';
        }
        return '• ${e.name}: de ${_describeSet(e, first)} para '
            '${_describeSet(e, last)}$delta · $times';
      }(),
  ];
}

/// Texto para o professor de educação física.
String trainerReport(ReportData d, {DateTime? today}) {
  final now = today ?? d.to;
  final lines = <String>[_header(d, ReportAudience.trainer), ''];

  lines
    ..add('CONSTÂNCIA')
    ..addAll(_consistency(d, withMinutes: false))
    ..add('');

  if (d.routines.isNotEmpty) {
    lines.add('FICHAS EM USO');
    for (final r in d.routines) {
      final parts = [r.name];
      if ((r.trainer ?? '').trim().isNotEmpty) {
        parts.add(_trainerName(r.trainer!.trim()));
      }
      final exp = r.expiresOn;
      if (exp != null) {
        final expired = DateTime(
          exp.year,
          exp.month,
          exp.day,
        ).isBefore(DateTime(now.year, now.month, now.day));
        parts.add(
          expired
              ? 'VENCIDA em ${reportDate(exp)}'
              : 'vence ${reportDate(exp)}',
        );
      }
      lines.add('• ${parts.join(' — ')}');
    }
    lines.add('');
  }

  final progress = exerciseProgressLines(d.sessions);
  if (progress.isNotEmpty) {
    lines
      ..add('EVOLUÇÃO (melhor série: 1ª e última vez no período)')
      ..addAll(progress)
      ..add('');
  }

  final pain = _painLines(d);
  lines
    ..add('DOR RELATADA')
    ..addAll(pain.isEmpty ? ['• Nenhuma.'] : pain)
    ..add('');

  // Comentários de esforço, do mais recente para o mais antigo (até 8).
  final notes = <String>[
    for (final s in d.sessions.reversed)
      for (final e in s.exercises)
        if (!e.pain &&
            (e.effort != null || (e.howItWent ?? '').trim().isNotEmpty))
          '• ${_shortDate(s.startedAt)} — ${e.name}: '
              '${[if (e.effort != null) e.effort!.label, if ((e.howItWent ?? '').trim().isNotEmpty) '"${e.howItWent!.trim()}"'].join(' · ')}',
  ].take(8).toList();
  if (notes.isNotEmpty) {
    lines
      ..add('COMO FOI (mais recentes)')
      ..addAll(notes)
      ..add('');
  }

  lines.add('Gerado pelo app NodeFit em ${reportDate(now)}.');
  return lines.join('\n');
}

// ───────────────────────── Médico ─────────────────────────

/// Classificação do IMC para adultos (OMS).
String bmiClass(double v) => v < 18.5
    ? 'baixo peso'
    : v < 25
    ? 'eutrofia'
    : v < 30
    ? 'sobrepeso'
    : 'obesidade';

/// Referência da OMS (2020) para adultos: 150–300 min/semana de atividade
/// moderada (ou 75–150 min de vigorosa) + fortalecimento muscular ≥ 2 dias.
const whoWeeklyMinutes = 150;

/// Métricas que interessam ao médico, na ordem do relatório.
const doctorMetrics = [
  BodyMetric.weight,
  BodyMetric.waist,
  BodyMetric.abdomen,
  BodyMetric.hip,
  BodyMetric.bodyFat,
  BodyMetric.visceralFat,
  BodyMetric.muscleMass,
];

/// "Peso: de 82 kg (05/09) para 79,4 kg (15/11): −2,6 kg".
String? metricLine(BodyMetric m, List<ReportCheckin> checkins) {
  final points = [
    for (final c in checkins)
      if (c.values[m] != null) (day: c.day, value: c.values[m]!),
  ];
  if (points.isEmpty) return null;
  String v(double x) => '${formatNumber(x)} ${m.unit}';
  final label = switch (m) {
    BodyMetric.bodyFat || BodyMetric.visceralFat || BodyMetric.muscleMass =>
      '${m.label} (balança de bioimpedância, estimativa)',
    _ => m.label,
  };
  final first = points.first;
  final last = points.last;
  if (points.length == 1) {
    return '• $label: ${v(last.value)} (${_shortDate(last.day)})';
  }
  final diff = double.parse((last.value - first.value).toStringAsFixed(2));
  return '• $label: de ${v(first.value)} (${_shortDate(first.day)}) para '
      '${v(last.value)} (${_shortDate(last.day)}): ${_signed(diff, m.unit)}';
}

/// Texto para o médico.
String doctorReport(ReportData d) {
  final lines = <String>[_header(d, ReportAudience.doctor)];

  final about = [
    if (d.birthYear != null) '${d.to.year - d.birthYear!} anos',
    if (d.sex != null) d.sex!.label,
    if (d.heightCm != null) '${formatNumber(d.heightCm!)} cm',
  ];
  if (about.isNotEmpty) lines.add('Dados: ${about.join(' · ')}');
  lines
    ..add('Dados registrados pelo próprio paciente no app.')
    ..add('');

  // Atividade física.
  lines
    ..add('ATIVIDADE FÍSICA')
    ..addAll(_consistency(d, withMinutes: true));
  final cardioSec = d.sessions.fold<int>(
    0,
    (sum, s) =>
        sum +
        s.exercises
            .where((e) => e.tracking == TrackingType.cardio)
            .fold<int>(
              0,
              (a, e) =>
                  a + e.sets.fold<int>(0, (b, x) => b + (x.durationSec ?? 0)),
            ),
  );
  if (cardioSec > 0) {
    lines.add(
      '• Cardio (esteira, bicicleta...): '
      '${(cardioSec / 60 / d.weeks).round()} min/semana em média',
    );
  }
  if (d.sessions.isNotEmpty) {
    final perWeekMin =
        d.sessions.fold<int>(0, (s, x) => s + x.duration.inMinutes) / d.weeks;
    lines.add(
      perWeekMin >= whoWeeklyMinutes
          ? '• Atinge a referência da OMS de $whoWeeklyMinutes min/semana '
                '(tempo total de treino, inclui descanso entre séries).'
          : '• Abaixo da referência da OMS de $whoWeeklyMinutes min/semana '
                '(tempo total de treino, inclui descanso entre séries).',
    );
  }
  lines.add('');

  // Corpo.
  lines.add('CORPO (1ª e última medida no período)');
  final bodyLines = [for (final m in doctorMetrics) ?metricLine(m, d.checkins)];
  if (bodyLines.isEmpty) {
    lines.add('• Nenhuma medida registrada no período.');
  } else {
    lines.addAll(bodyLines);
    final lastWeight = d.checkins.reversed
        .map((c) => c.values[BodyMetric.weight])
        .whereType<double>()
        .firstOrNull;
    final imc = bmi(weightKg: lastWeight, heightCm: d.heightCm);
    if (imc != null) {
      lines.add(
        '• IMC atual: ${formatNumber(double.parse(imc.toStringAsFixed(1)))} '
        '(${bmiClass(imc)}, classificação da OMS)',
      );
    }
  }
  lines.add('');

  final pain = _painLines(d);
  lines
    ..add('DORES RELATADAS DURANTE O TREINO')
    ..addAll(pain.isEmpty ? ['• Nenhuma.'] : pain)
    ..add('')
    ..add(
      'Aviso: valores informados pelo paciente; % de gordura e composição '
      'corporal são estimativas da balança/fita e não substituem exames.',
    )
    ..add('Gerado pelo app NodeFit em ${reportDate(d.to)}.');
  return lines.join('\n');
}

/// "Carla" → "prof. Carla"; "Prof. Carla" fica como está.
String _trainerName(String name) =>
    name.toLowerCase().startsWith('prof') ? name : 'prof. $name';
