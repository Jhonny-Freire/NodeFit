import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/domain/body.dart';
import 'package:nodefit/core/prefs/prefs_repository.dart';
import 'package:nodefit/features/backup/csv_export.dart';
import 'package:nodefit/features/body/data/body_repository.dart';
import 'package:nodefit/features/catalog/data/catalog_repository.dart';
import 'package:nodefit/features/gyms/data/gym_repository.dart';
import 'package:nodefit/features/gyms/data/station_repository.dart';
import 'package:nodefit/features/workout/data/workout_repository.dart';

void main() {
  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  test('planilhas: uma linha por série feita e uma por check-in', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final prefs = PrefsRepository(db);
    await CatalogSeeder(
      db,
      prefs,
    ).run(File('assets/seed/exercicios_pt_br.json').readAsStringSync());
    final gym = await GymRepository(db).createGym('Academia; Centro');
    final workouts = WorkoutRepository(db, StationRepository(db));
    final s = await workouts.startFreeSession(gymId: gym.id);
    final se = await workouts.addExercise(
      sessionId: s,
      exerciseId: 'esteira',
      restSec: 0,
    );
    final set = (await workouts.watchSets(se).first).single;
    await workouts.updateSet(
      set.id,
      durationSec: const Value(1200),
      distanceM: const Value(2500),
    );
    await workouts.completeSet(set.id, sessionId: s, restSec: 0);
    await workouts.finishSession(s);

    final body = BodyRepository(db, prefs);
    await body.saveCheckin(
      takenAt: DateTime.utc(2026, 10, 26, 10),
      values: {BodyMetric.weight: 80400, BodyMetric.bodyFat: 19500},
    );

    final exporter = CsvExporter(db);
    final w = (await exporter.workoutsCsv()).split('\r\n');
    expect(w.first, startsWith('﻿data;hora;treino'));
    expect(w, hasLength(3), reason: 'cabeçalho + 1 série + linha final');
    expect(w[1], contains(';"Academia; Centro";Esteira;sem aparelho;1;'));
    expect(w[1], contains(';1200;2,5;'));

    final b = (await exporter.bodyCsv()).split('\r\n');
    expect(b.first, '﻿data;Peso (kg);Gordura corporal (%);observação');
    expect(b[1], '2026-10-26;80,4;19,5;');
  });
}
