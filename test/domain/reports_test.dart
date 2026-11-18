import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/domain/body.dart';
import 'package:nodefit/core/domain/enums.dart';
import 'package:nodefit/core/domain/reports.dart';

void main() {
  final from = DateTime.utc(2026, 10, 21, 12);
  final to = DateTime.utc(2026, 11, 18, 12); // 4 semanas

  ReportSession session(
    int day,
    List<ReportExercise> exercises, {
    int minutes = 60,
  }) {
    final start = DateTime.utc(2026, 10, day, 12);
    return ReportSession(
      startedAt: start,
      endedAt: start.add(Duration(minutes: minutes)),
      title: 'Treino A',
      exercises: exercises,
    );
  }

  ReportExercise supino(int loadKg, int reps, {bool pain = false}) =>
      ReportExercise(
        name: 'Supino reto',
        pain: pain,
        howItWent: pain ? 'ombro direito' : null,
        sets: [
          const ReportSet(type: SetType.warmup, loadMilli: 90000, reps: 1),
          ReportSet(loadMilli: loadKg * 1000, reps: reps),
          ReportSet(loadMilli: (loadKg - 5) * 1000, reps: reps + 2),
        ],
      );

  test('melhor série ignora aquecimento e desempata pelas reps', () {
    final best = bestSet(supino(40, 8))!;
    expect((best.loadMilli, best.reps), (40000, 8));
  });

  test('evolução compara a 1ª e a última vez, só na mesma unidade', () {
    final lines = exerciseProgressLines([
      session(22, [supino(30, 10)]),
      session(29, [supino(35, 8)]),
      session(30, [
        const ReportExercise(
          name: 'Cadeira extensora',
          unit: LoadUnit.plate,
          sets: [ReportSet(loadMilli: 7000, reps: 12)],
        ),
      ]),
    ]);
    expect(
      lines.first,
      '• Supino reto: de 30 kg × 10 para 35 kg × 8 (+5 kg) · 2× no período',
    );
    expect(lines.last, '• Cadeira extensora: placa 7 × 12 (1× no período)');
  });

  test('relatório do professor: constância, ficha vencida, dor, sem peso', () {
    final text = trainerReport(
      ReportData(
        studentName: 'Lucas',
        from: from,
        to: to,
        sessions: [
          session(22, [supino(30, 10)]),
          session(29, [supino(35, 8, pain: true)]),
        ],
        routines: [
          ReportRoutine(
            name: 'Treino A',
            trainer: 'Carla',
            expiresOn: DateTime(2026, 11, 10),
          ),
          ReportRoutine(name: 'Treino B', expiresOn: DateTime(2026, 12, 20)),
        ],
        checkins: [
          ReportCheckin(day: to, values: {BodyMetric.weight: 80}),
        ],
      ),
    );
    expect(text, contains('Aluno(a): Lucas'));
    expect(text, contains('(4 semanas)'));
    expect(text, contains('• 2 treinos (0,5 por semana)'));
    expect(text, contains('Treino A — prof. Carla — VENCIDA em 10/11/2026'));
    expect(text, contains('Treino B — vence 20/12/2026'));
    expect(text, contains('• 29/10 — Supino reto: "ombro direito"'));
    // O professor não recebe dado de saúde.
    expect(text, isNot(contains('Peso')));
    expect(text, isNot(contains('80')));
  });

  test('relatório do médico: minutos/semana, OMS, corpo, IMC, sem cargas', () {
    final text = doctorReport(
      ReportData(
        studentName: 'Lucas',
        from: from,
        to: to,
        sex: Sex.male,
        heightCm: 180,
        birthYear: 2002,
        sessions: [
          for (final d in [22, 24, 26, 29, 31])
            session(d, [supino(30, 10)], minutes: 75),
          session(25, [
            const ReportExercise(
              name: 'Esteira',
              tracking: TrackingType.cardio,
              sets: [ReportSet(durationSec: 1200, distanceM: 2500)],
            ),
          ], minutes: 20),
        ],
        checkins: [
          ReportCheckin(
            day: DateTime.utc(2026, 10, 22, 12),
            values: {BodyMetric.weight: 84, BodyMetric.waist: 92},
          ),
          ReportCheckin(
            day: DateTime.utc(2026, 11, 15, 12),
            values: {BodyMetric.weight: 81, BodyMetric.waist: 89.5},
          ),
        ],
      ),
    );
    expect(text, contains('Paciente: Lucas'));
    expect(text, contains('Dados: 24 anos · Masculino · 180 cm'));
    // (5 × 75 + 20) / 4 semanas ≈ 99 min/semana.
    expect(text, contains('99 min/semana'));
    expect(text, contains('Cardio (esteira, bicicleta...): 5 min/semana'));
    expect(text, contains('Abaixo da referência da OMS de 150 min/semana'));
    expect(
      text,
      contains('• Peso: de 84 kg (22/10) para 81 kg (15/11): −3 kg'),
    );
    expect(
      text,
      contains('Cintura (parte mais fina): de 92 cm (22/10) para 89,5 cm'),
    );
    expect(text, contains('IMC atual: 25 (sobrepeso, classificação da OMS)'));
    expect(text, contains('não substituem exames'));
    // O médico não recebe cargas.
    expect(text, isNot(contains('Supino')));
    expect(text, isNot(contains('kg ×')));
  });

  test('sem dados: mensagens claras em vez de relatório vazio', () {
    final data = ReportData(studentName: 'Lucas', from: from, to: to);
    expect(trainerReport(data), contains('Nenhum treino registrado'));
    expect(doctorReport(data), contains('Nenhuma medida registrada'));
  });

  test('classificação do IMC (OMS)', () {
    expect(bmiClass(17), 'baixo peso');
    expect(bmiClass(22), 'eutrofia');
    expect(bmiClass(27), 'sobrepeso');
    expect(bmiClass(31), 'obesidade');
  });

  test('rota: tipo do relatório pela URL', () {
    expect(ReportAudience.fromSlug('professor'), ReportAudience.trainer);
    expect(ReportAudience.fromSlug('medico'), ReportAudience.doctor);
    expect(ReportAudience.fromSlug('x'), isNull);
  });
}
