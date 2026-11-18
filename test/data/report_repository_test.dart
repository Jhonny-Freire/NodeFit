// SQL cru para montar o cenário (como em test/drift/): aspas duplas por fora.
// ignore_for_file: prefer_single_quotes
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/domain/body.dart';
import 'package:nodefit/core/domain/reports.dart';
import 'package:nodefit/features/reports/data/report_repository.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> sql(List<String> statements) async {
    for (final s in statements) {
      await db.customStatement(s);
    }
  }

  test('lê só treinos finalizados e check-ins do período', () async {
    const t = '2026-11-10T12:00:00.000Z';
    const end = '2026-11-10T13:00:00.000Z';
    const old = '2026-01-10T12:00:00.000Z';
    await sql([
      "INSERT INTO gyms (id, name, created_at, updated_at) "
          "VALUES ('g', 'Academia', '$t', '$t')",
      "INSERT INTO exercises (id, name, search_text, equipment_type, "
          "created_at, updated_at) VALUES ('e', 'Supino reto', 'supino reto', "
          "'barbell', '$t', '$t')",
      "INSERT INTO stations (id, exercise_id, gym_id, created_at, updated_at) "
          "VALUES ('st', 'e', 'g', '$t', '$t')",
      // Finalizado, dentro do período.
      "INSERT INTO workout_sessions (id, gym_id, title, started_at, ended_at, "
          "local_date, created_at, updated_at) VALUES ('s1', 'g', 'Treino A', "
          "'$t', '$end', '2026-11-10', '$t', '$t')",
      // Em andamento: não entra.
      "INSERT INTO workout_sessions (id, gym_id, title, started_at, "
          "local_date, created_at, updated_at) VALUES ('s2', 'g', 'Treino B', "
          "'$t', '2026-11-10', '$t', '$t')",
      // Fora do período: não entra.
      "INSERT INTO workout_sessions (id, gym_id, title, started_at, ended_at, "
          "local_date, created_at, updated_at) VALUES ('s3', 'g', 'Antigo', "
          "'$old', '$old', '2026-01-10', '$old', '$old')",
      "INSERT INTO session_exercises (id, session_id, station_id, exercise_id, "
          "position, load_unit, load_basis, increment_milli, rest_sec, pain, "
          "how_it_went, created_at, updated_at) VALUES ('se', 's1', 'st', 'e', "
          "1, 'kg', 'total', 2500, 90, 1, 'ombro', '$t', '$t')",
      "INSERT INTO workout_sets (id, session_exercise_id, position, set_type, "
          "load_milli, reps, completed_at, created_at, updated_at) VALUES "
          "('w1', 'se', 1, 'working', 40000, 8, '$t', '$t', '$t')",
      // Série só planejada (não concluída): não entra.
      "INSERT INTO workout_sets (id, session_exercise_id, position, set_type, "
          "load_milli, reps, created_at, updated_at) VALUES "
          "('w2', 'se', 2, 'working', 99000, 1, '$t', '$t')",
      "INSERT INTO body_checkins (id, taken_at, local_date, created_at, "
          "updated_at) VALUES ('c', '$t', '2026-11-10', '$t', '$t')",
      "INSERT INTO body_values (id, checkin_id, metric, value_milli, "
          "created_at) VALUES ('v', 'c', 'weight', 80500, '$t')",
    ]);

    final data = await ReportRepository(db)
        .load(studentName: 'Lucas', weeks: 4, now: DateTime.utc(2026, 11, 18));

    expect(data.sessions.map((s) => s.title), ['Treino A']);
    final ex = data.sessions.single.exercises.single;
    expect(ex.name, 'Supino reto');
    expect(ex.pain, isTrue);
    expect(ex.sets.map((s) => s.loadMilli), [40000]);
    expect(data.checkins.single.values, {BodyMetric.weight: 80.5});

    final trainer = trainerReport(data);
    expect(trainer, contains('• Supino reto: 40 kg × 8 (1× no período)'));
    expect(trainer, contains('Supino reto: "ombro"'));
    expect(doctorReport(data), contains('• Peso: 80,5 kg (10/11)'));
  });
}
