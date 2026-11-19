// dart format width=80
// ignore_for_file: unused_local_variable, unused_import, prefer_single_quotes
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/domain/enums.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  // v1 → v2 só acrescenta colunas; este teste garante que um treino
  // gravado na v1 (o caderno de quem já usa o app) chega inteiro na v2.
  test('v1 → v2 preserva treinos e marca tudo como carga × reps', () async {
    final schema = await verifier.schemaAt(1);
    const t = '2026-10-19T14:22:14.320Z';
    for (final sql in [
      "INSERT INTO gyms (id, name, created_at, updated_at) "
          "VALUES ('g', 'Academia', '$t', '$t')",
      "INSERT INTO exercises (id, name, search_text, equipment_type, "
          "created_at, updated_at) VALUES ('e', 'Cadeira extensora', "
          "'cadeira extensora', 'machine', '$t', '$t')",
      "INSERT INTO stations (id, exercise_id, gym_id, created_at, updated_at) "
          "VALUES ('st', 'e', 'g', '$t', '$t')",
      "INSERT INTO workout_sessions (id, gym_id, title, started_at, ended_at, "
          "local_date, created_at, updated_at) VALUES ('s', 'g', "
          "'Treino livre', '$t', '$t', '2026-10-19', '$t', '$t')",
      "INSERT INTO session_exercises (id, session_id, station_id, "
          "exercise_id, position, load_unit, load_basis, increment_milli, "
          "rest_sec, created_at, updated_at) VALUES ('se', 's', 'st', 'e', 1, "
          "'kg', 'total', 5000, 90, '$t', '$t')",
      "INSERT INTO workout_sets (id, session_exercise_id, position, set_type, "
          "load_milli, reps, completed_at, created_at, updated_at) VALUES "
          "('w', 'se', 1, 'working', 42500, 10, '$t', '$t', '$t')",
    ]) {
      schema.rawDatabase.execute(sql);
    }

    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 2);
    final exercise = await db.select(db.exercises).getSingle();
    expect(exercise.tracking, TrackingType.weightReps);
    final set = await db.select(db.workoutSets).getSingle();
    expect((set.loadMilli, set.reps), (42500, 10));
    expect((set.durationSec, set.distanceM), (null, null));
    expect(set.completedAt, isNotNull);
    await db.close();
  });

  // v3 → v4 só cria a tabela de usuários: o caderno de quem já usa o app
  // continua intacto e ninguém fica logado até cadastrar/entrar.
  test('v3 → v4 preserva os dados e cria users vazia', () async {
    final schema = await verifier.schemaAt(3);
    const t = '2026-11-18T10:00:00.000Z';
    schema.rawDatabase.execute(
      "INSERT INTO gyms (id, name, created_at, updated_at) "
      "VALUES ('g', 'Academia', '$t', '$t')",
    );
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 4);
    final gym = await db.select(db.gyms).getSingle();
    expect(gym.name, 'Academia');
    expect(await db.select(db.users).get(), isEmpty);
    await db.close();
  });

  // v4 → v5 acrescenta a data do próximo treino na ficha: as fichas que já
  // existem continuam iguais e ficam sem data.
  test('v4 → v5 preserva as fichas e deixa o próximo treino vazio', () async {
    final schema = await verifier.schemaAt(4);
    const t = '2026-11-18T10:00:00.000Z';
    schema.rawDatabase.execute(
      "INSERT INTO routines (id, name, label, sort_order, created_at, "
      "updated_at) VALUES ('r', 'Peito/Tríceps', 'A', 0, '$t', '$t')",
    );
    final db = AppDatabase(schema.newConnection());
    await verifier.migrateAndValidate(db, 5);
    final routine = await db.select(db.routines).getSingle();
    expect(routine.name, 'Peito/Tríceps');
    expect(routine.label, 'A');
    expect(routine.nextOn, isNull);
    await db.close();
  });
}
