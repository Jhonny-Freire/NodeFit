import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/domain/enums.dart';
import 'package:nodefit/core/prefs/prefs_repository.dart';
import 'package:nodefit/features/catalog/data/catalog_repository.dart';
import 'package:nodefit/features/gyms/data/gym_repository.dart';
import 'package:nodefit/features/gyms/data/station_repository.dart';
import 'package:nodefit/features/routines/data/routine_repository.dart';
import 'package:nodefit/features/workout/data/workout_repository.dart';

void main() {
  late AppDatabase db;
  late GymRepository gyms;
  late WorkoutRepository workouts;
  late RoutineRepository routines;
  late CatalogRepository catalog;

  setUpAll(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final prefs = PrefsRepository(db);
    gyms = GymRepository(db);
    workouts = WorkoutRepository(db, StationRepository(db));
    routines = RoutineRepository(db);
    catalog = CatalogRepository(db);
    await CatalogSeeder(
      db,
      prefs,
    ).run(File('assets/seed/exercicios_pt_br.json').readAsStringSync());
  });

  tearDown(() => db.close());

  /// Faz todas as séries pendentes com [load] × [reps] e finaliza.
  Future<void> doAll(String sessionId, int load, int reps) async {
    final sets = await workouts.watchSessionSets(sessionId).first;
    for (final list in sets.values) {
      for (final s in list.where((s) => s.completedAt == null)) {
        await workouts.updateSet(
          s.id,
          loadMilli: Value(s.setType == SetType.warmup ? load ~/ 2 : load),
          reps: Value(reps),
        );
        await workouts.completeSet(s.id, sessionId: sessionId, restSec: 60);
      }
    }
    await workouts.finishSession(sessionId);
  }

  test('ficha: iniciar traz aparelho, alvo, aquecimento e depois a sugestão', () async {
    final gym = await gyms.createGym('Academia');
    final ext = await gyms.createEquipment(
      gymId: gym.id,
      name: 'Extensora 12',
      type: EquipmentType.machine,
      loadUnit: LoadUnit.kg,
      loadBasis: LoadBasis.total,
      incrementMilli: 5000,
    );
    final ex =
        (await catalog.watchExercises(query: 'cadeira extensora').first).first;
    final a = await routines.createRoutine(
      name: 'Pernas',
      label: 'A',
      gymId: gym.id,
    );
    final itemId = await routines.addItem(
      routineId: a.id,
      exerciseId: ex.id,
      preferredEquipmentId: ext.id,
      repMin: 8,
      repMax: 12,
      restSec: 75,
    );
    final item = (await routines.getItems(a.id)).single.item;
    await routines.updateItem(
      item,
      targetSets: 3,
      repMin: 8,
      repMax: 12,
      restSec: 75,
      warmupSets: 1,
      preferredEquipmentId: ext.id,
      notes: 'pausa em cima',
      tempo: '2-1-1-0',
    );
    expect(itemId, item.id);

    // 1º treino: sem histórico → 1 aquecimento + 3 séries com o fundo da faixa.
    final s1 = await workouts.startFromRoutine(
      routineId: a.id,
      gymId: gym.id,
      defaultRestSec: 90,
    );
    final v1 = (await workouts.watchSessionExercises(s1).first).single;
    expect(v1.equipment!.id, ext.id, reason: 'aparelho preferido da ficha');
    expect(v1.item.restSec, 75);
    expect((v1.item.targetSets, v1.item.repMin, v1.item.repMax), (3, 8, 12));
    expect(v1.routineItem!.notes, 'pausa em cima');
    var sets = await workouts.watchSets(v1.item.id).first;
    expect(sets.map((s) => s.setType), [
      SetType.warmup,
      SetType.working,
      SetType.working,
      SetType.working,
    ]);
    expect(sets.skip(1).map((s) => s.reps), [8, 8, 8]);
    expect((await workouts.watchSession(s1).first)!.title, 'Ficha A · Pernas');
    await doAll(s1, 40000, 12); // bateu o topo em todas

    // 2º treino: todas no topo → +5 kg e volta para 8 reps.
    final s2 = await workouts.startFromRoutine(
      routineId: a.id,
      gymId: gym.id,
      defaultRestSec: 90,
    );
    final v2 = (await workouts.watchSessionExercises(s2).first).single;
    sets = await workouts.watchSets(v2.item.id).first;
    final working = sets.where((s) => s.setType == SetType.working).toList();
    expect(working.map((s) => (s.loadMilli, s.reps)), [
      (45000, 8),
      (45000, 8),
      (45000, 8),
    ]);
    expect(sets.first.setType, SetType.warmup);
    expect(
      (sets.first.loadMilli, sets.first.reps),
      (25000, 6),
      reason: 'aquecimento: rampa até os 45 kg (60% → 25 kg no passo de 5)',
    );
    await doAll(s2, 45000, 10);

    // Gráfico de evolução: um ponto por treino, do mais antigo ao mais novo.
    final points = progressPointsOf(
      await workouts.watchStationHistory(v2.station.id).first,
    );
    expect(points.map((p) => p.maxLoadMilli), [40000, 45000]);
    expect(points.last.bestE1rm, closeTo(45 * (1 + 10 / 30), 0.001));

    // Resumo do 2º treino: recorde de carga.
    final summary = await workouts.sessionSummary(s2);
    expect(summary.records.single.kind, 'Carga');
    expect(summary.records.single.value, '45 kg × 10');
    expect(
      summary.volumeKg,
      closeTo(45 * 10 * 3, 0.001),
      reason: 'aquecimento não entra',
    );
  });

  test('rodízio: a próxima ficha é a seguinte à última feita', () async {
    final gym = await gyms.createGym('Academia');
    final ex = (await catalog.watchExercises(query: 'supino').first).first;
    final a = await routines.createRoutine(
      name: 'Peito',
      label: 'A',
      gymId: gym.id,
    );
    final b = await routines.createRoutine(
      name: 'Costas',
      label: 'B',
      gymId: gym.id,
    );
    final vazia = await routines.createRoutine(
      name: 'Vazia',
      label: 'C',
      gymId: gym.id,
    );
    for (final r in [a, b]) {
      await routines.addItem(routineId: r.id, exerciseId: ex.id);
    }
    var list = await routines.watchRoutines(gym.id).first;
    expect(list.map((r) => r.routine.id), [a.id, b.id, vazia.id]);
    expect((await routines.nextRoutine(gym.id, list))!.routine.id, a.id);

    final s = await workouts.startFromRoutine(
      routineId: a.id,
      gymId: gym.id,
      defaultRestSec: 60,
    );
    await doAll(s, 30000, 10);
    list = await routines.watchRoutines(gym.id).first;
    expect(
      (await routines.nextRoutine(gym.id, list))!.routine.id,
      b.id,
      reason: 'fez A → próxima B (ficha vazia não entra no rodízio)',
    );
    expect(list.first.lastDoneAt, isNotNull);
  });

  test('duplicar ficha copia os exercícios', () async {
    final gym = await gyms.createGym('Academia');
    final ex = (await catalog.watchExercises(query: 'supino').first).first;
    final a = await routines.createRoutine(
      name: 'Peito',
      label: 'A',
      gymId: gym.id,
    );
    await routines.addItem(
      routineId: a.id,
      exerciseId: ex.id,
      repMin: 6,
      repMax: 10,
    );
    final copy = await routines.duplicateRoutine(a.id);
    final items = await routines.getItems(copy.id);
    expect(items.single.exercise.id, ex.id);
    expect((items.single.item.repMin, items.single.item.repMax), (6, 10));
    expect(copy.name, 'Peito (cópia)');
  });

  test('recorde aparece na hora, uma vez por marca', () async {
    final gym = await gyms.createGym('Academia');
    final ex = (await catalog.watchExercises(query: 'supino').first).first;
    final s1 = await workouts.startFreeSession(gymId: gym.id);
    await workouts.addExercise(
      sessionId: s1,
      exerciseId: ex.id,
      equipmentId: null,
      restSec: 60,
    );
    await doAll(s1, 40000, 8);

    final s2 = await workouts.startFreeSession(gymId: gym.id);
    final seId = await workouts.addExercise(
      sessionId: s2,
      exerciseId: ex.id,
      equipmentId: null,
      restSec: 60,
    );
    final sets = await workouts.watchSets(seId).first;
    Future<({String value, String kind})?> doSet(
      int i,
      int load,
      int reps,
    ) async {
      await workouts.updateSet(
        sets[i].id,
        loadMilli: Value(load),
        reps: Value(reps),
      );
      await workouts.completeSet(sets[i].id, sessionId: s2, restSec: 0);
      final r = await workouts.liveRecord(sets[i].id);
      return r == null ? null : (value: r.value, kind: r.kind.label);
    }

    expect(await doSet(0, 42500, 8), (value: '42,5 kg × 8', kind: 'Carga'));
    expect(
      await doSet(1, 42500, 8),
      isNull,
      reason: 'igualou a de agora há pouco',
    );
    expect(await doSet(2, 42500, 9), (
      value: '42,5 kg × 9',
      kind: '1RM estimado',
    ));
  });

  test('salvar treino livre como ficha', () async {
    final gym = await gyms.createGym('Academia');
    final ext = await gyms.createEquipment(
      gymId: gym.id,
      name: 'Extensora 12',
      type: EquipmentType.machine,
      loadUnit: LoadUnit.kg,
      loadBasis: LoadBasis.total,
      incrementMilli: 5000,
    );
    final cadeira =
        (await catalog.watchExercises(query: 'cadeira extensora').first).first;
    final supino = (await catalog.watchExercises(query: 'supino').first).first;
    final s = await workouts.startFreeSession(gymId: gym.id);
    final a = await workouts.addExercise(
      sessionId: s,
      exerciseId: cadeira.id,
      equipmentId: ext.id,
      restSec: 75,
    );
    await workouts.addExercise(
      sessionId: s,
      exerciseId: supino.id,
      equipmentId: null,
      restSec: 60,
    );
    // Só a cadeira tem séries feitas: 10, 9 e 8 reps; o supino fica de fora.
    final sets = await workouts.watchSets(a).first;
    for (final (i, reps) in [(0, 10), (1, 9), (2, 8)]) {
      await workouts.updateSet(
        sets[i].id,
        loadMilli: const Value(40000),
        reps: Value(reps),
      );
      await workouts.completeSet(sets[i].id, sessionId: s, restSec: 0);
    }
    await workouts.finishSession(s);

    final routine = await routines.saveSessionAsRoutine(
      sessionId: s,
      name: 'Pernas',
      label: 'D',
    );
    expect(routine.gymId, gym.id);
    final item = (await routines.getItems(routine.id)).single;
    expect(item.exercise.id, cadeira.id);
    expect(item.equipment!.id, ext.id);
    expect(
      (item.item.targetSets, item.item.repMin, item.item.repMax),
      (3, 8, 10),
    );
    expect(item.item.restSec, 75);
  });

  test('bi-set: ficha → treino, separar, remover e reordenar', () async {
    final gym = await gyms.createGym('Academia');
    Future<String> ex(String q) async =>
        (await catalog.watchExercises(query: q).first).first.id;
    final a = await routines.createRoutine(name: 'Braço', gymId: gym.id);
    for (final q in ['rosca direta', 'triceps corda', 'supino']) {
      await routines.addItem(routineId: a.id, exerciseId: await ex(q));
    }
    Future<List<int?>> routineGroups() async => [
      for (final v in await routines.getItems(a.id)) v.item.supersetGroup,
    ];
    var items = await routines.getItems(a.id);
    await routines.linkItemWithNext(items[0].item);
    expect(await routineGroups(), [1, 1, null]);

    // O treino herda o bi-set da ficha.
    final s = await workouts.startFromRoutine(
      routineId: a.id,
      gymId: gym.id,
      defaultRestSec: 60,
    );
    Future<List<int?>> sessionGroups() async => [
      for (final v in await workouts.watchSessionExercises(s).first)
        v.item.supersetGroup,
    ];
    expect(await sessionGroups(), [1, 1, null]);
    final views = await workouts.watchSessionExercises(s).first;
    await workouts.linkSupersetWithNext(views[1].item.id);
    expect(await sessionGroups(), [1, 1, 1], reason: 'virou tri-set');
    await workouts.unlinkSuperset(views[2].item.id);
    expect(await sessionGroups(), [1, 1, null]);
    // Remover um par: o outro volta a ser solo.
    await workouts.removeExercise(views[0].item.id);
    expect(await sessionGroups(), [null, null]);

    // Na ficha, mover o par para longe desfaz o bi-set.
    items = await routines.getItems(a.id);
    await routines.reorder(a.id, [
      items[0].item.id,
      items[2].item.id,
      items[1].item.id,
    ]);
    expect(await routineGroups(), [null, null, null]);
  });

  test(
    'cardio e prancha: tempo e distância no lugar de carga × reps',
    () async {
      final gym = await gyms.createGym('Academia');
      final esteira =
          (await catalog.watchExercises(query: 'esteira').first).first;
      final prancha = (await catalog.watchExercises(query: 'prancha').first)
          .firstWhere((e) => e.name == 'Prancha');
      expect(esteira.tracking, TrackingType.cardio);
      expect(prancha.tracking, TrackingType.duration);

      final s1 = await workouts.startFreeSession(gymId: gym.id);
      final cardioId = await workouts.addExercise(
        sessionId: s1,
        exerciseId: esteira.id,
        restSec: 90,
      );
      final plankId = await workouts.addExercise(
        sessionId: s1,
        exerciseId: prancha.id,
        restSec: 60,
      );
      final views = await workouts.watchSessionExercises(s1).first;
      expect(views.first.item.restSec, 0, reason: 'cardio não tem descanso');
      var cardio = await workouts.watchSets(cardioId).first;
      expect(cardio, hasLength(1), reason: 'cardio é um bloco só');
      expect(
        await workouts.completeSet(cardio.single.id, sessionId: s1, restSec: 0),
        isFalse,
        reason: 'sem tempo não conclui',
      );
      await workouts.updateSet(
        cardio.single.id,
        durationSec: const Value(1200),
        distanceM: const Value(2500),
      );
      expect(
        await workouts.completeSet(cardio.single.id, sessionId: s1, restSec: 0),
        isTrue,
      );

      // Prancha: concluir a 1ª com 60 s faz a 2ª herdar os 60 s.
      var plank = await workouts.watchSets(plankId).first;
      expect(plank, hasLength(3));
      await workouts.updateSet(plank[0].id, durationSec: const Value(60));
      await workouts.completeSet(plank[0].id, sessionId: s1, restSec: 60);
      plank = await workouts.watchSets(plankId).first;
      expect(plank[1].durationSec, 60);
      await workouts.finishSession(s1);

      // Próxima vez: vem o que foi feito, e sem "recorde" de carga.
      final s2 = await workouts.startFreeSession(gymId: gym.id);
      final again = await workouts.addExercise(
        sessionId: s2,
        exerciseId: esteira.id,
        restSec: 90,
      );
      cardio = await workouts.watchSets(again).first;
      expect(
        (cardio.single.durationSec, cardio.single.distanceM),
        (1200, 2500),
      );
      await workouts.completeSet(cardio.single.id, sessionId: s2, restSec: 0);
      expect(await workouts.liveRecord(cardio.single.id), isNull);
    },
  );
}
