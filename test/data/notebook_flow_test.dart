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
import 'package:nodefit/features/workout/data/workout_repository.dart';

void main() {
  late AppDatabase db;
  late PrefsRepository prefs;
  late GymRepository gyms;
  late StationRepository stations;
  late WorkoutRepository workouts;
  late CatalogRepository catalog;

  setUpAll(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    prefs = PrefsRepository(db);
    gyms = GymRepository(db);
    stations = StationRepository(db);
    workouts = WorkoutRepository(db, stations);
    catalog = CatalogRepository(db);
    await CatalogSeeder(
      db,
      prefs,
    ).run(File('assets/seed/exercicios_pt_br.json').readAsStringSync());
  });

  tearDown(() => db.close());

  test('catálogo embarcado: carrega uma vez e a busca ignora acento', () async {
    final all = await catalog.watchExercises().first;
    expect(all.length, greaterThanOrEqualTo(60));
    // Rodar de novo com a mesma versão não regrava nada.
    final again = await CatalogSeeder(
      db,
      prefs,
    ).run(File('assets/seed/exercicios_pt_br.json').readAsStringSync());
    expect(again, 0);
    final found = await catalog.watchExercises(query: 'extensora').first;
    expect(found.map((e) => e.name), contains('Cadeira extensora'));
    final accent = await catalog.watchExercises(query: 'ELEVACAO').first;
    expect(accent, isNotEmpty);
  });

  test(
    'estação é única por (exercício, academia, aparelho), também sem aparelho',
    () async {
      final gym = await gyms.createGym('Academia do bairro');
      final ex = (await catalog.watchExercises(query: 'flexão').first).first;
      final a = await stations.getOrCreate(exerciseId: ex.id, gymId: gym.id);
      final b = await stations.getOrCreate(exerciseId: ex.id, gymId: gym.id);
      expect(a.id, b.id);
    },
  );

  test('ajustes: histórico "7 → 8" e nada quando o valor não muda', () async {
    final gym = await gyms.createGym('Academia');
    final machine = await gyms.createEquipment(
      gymId: gym.id,
      name: 'Extensora 1',
      type: EquipmentType.machine,
      loadUnit: LoadUnit.kg,
      loadBasis: LoadBasis.total,
      incrementMilli: 5000,
    );
    final ex =
        (await catalog.watchExercises(query: 'cadeira extensora').first).first;
    final st = await stations.getOrCreate(
      exerciseId: ex.id,
      gymId: gym.id,
      equipmentId: machine.id,
    );
    final banco = await stations.addSetting(
      stationId: st.id,
      label: 'Banco',
      kind: SettingKind.number,
      valueNum: 7,
    );
    await stations.updateSettingValue(banco, valueNum: 8);
    final current = (await stations.watchSettings(st.id).first).single;
    await stations.updateSettingValue(current, valueNum: 8); // sem mudança
    final changes = await stations.watchChanges(st.id).first;
    expect(changes.length, 2);
    expect(changes.first.change.oldValue, '7');
    expect(changes.first.change.newValue, '8');
    expect(changes.first.label, 'Banco');
  });

  test(
    'fluxo do caderno: treino → Anterior pré-preenche o próximo treino',
    () async {
      final gym = await gyms.createGym('Academia');
      final legPress = await gyms.createEquipment(
        gymId: gym.id,
        name: 'Leg press 45° preto',
        type: EquipmentType.plateLoaded,
        loadUnit: LoadUnit.kg,
        loadBasis: LoadBasis.perSide,
        incrementMilli: 5000,
      );
      final ex =
          (await catalog.watchExercises(query: 'leg press 45').first).first;

      // Treino 1
      final s1 = await workouts.startFreeSession(gymId: gym.id);
      expect(
        await workouts.startFreeSession(gymId: gym.id),
        s1,
        reason: 'não abre um segundo treino em andamento',
      );
      final se1 = await workouts.addExercise(
        sessionId: s1,
        exerciseId: ex.id,
        equipmentId: legPress.id,
        restSec: 90,
      );
      var sets = await workouts.watchSets(se1).first;
      expect(sets.length, 3, reason: '3 séries vazias na primeira vez');
      expect(
        sets.every((s) => s.loadMilli == null && s.completedAt == null),
        isTrue,
      );

      for (final s in sets.take(2)) {
        await workouts.updateSet(
          s.id,
          loadMilli: const Value(40000),
          reps: const Value(12),
        );
      }
      sets = await workouts.watchSets(se1).first;
      await workouts.completeSet(sets[0].id, sessionId: s1, restSec: 90);
      await workouts.completeSet(sets[1].id, sessionId: s1, restSec: 90);
      final active = await workouts.watchActiveSession().first;
      expect(
        active!.restEndsAt,
        isNotNull,
        reason: 'descanso gravado no banco',
      );
      await workouts.updateHowItWent(
        se1,
        text: 'joelho ok',
        tag: EffortTag.hard,
      );

      final counts = await workouts.setCounts(s1);
      expect(counts, (done: 2, pending: 1));
      await workouts.finishSession(s1);
      expect(await workouts.watchActiveSession().first, isNull);
      expect(
        (await workouts.watchSets(se1).first).length,
        2,
        reason: 'série não feita é descartada ao finalizar',
      );

      // Treino 2: mesma estação → séries vêm do "Anterior"
      final s2 = await workouts.startFreeSession(gymId: gym.id);
      final se2 = await workouts.addExercise(
        sessionId: s2,
        exerciseId: ex.id,
        equipmentId: legPress.id,
        restSec: 90,
      );
      final planned = await workouts.watchSets(se2).first;
      expect(planned.map((s) => (s.loadMilli, s.reps)), [
        (40000, 12),
        (40000, 12),
      ]);
      final se2View = (await workouts.watchSessionExercises(s2).first).single;
      final prev = await workouts.previousForStation(
        se2View.station.id,
        excludeSessionId: s2,
      );
      expect(prev!.howItWent, 'joelho ok');
      expect(prev.effortTag, EffortTag.hard);
      expect(prev.fromOtherEquipment, isFalse);

      // Aparelho ocupado: troca → as séries pendentes NÃO herdam os números
      final other = await gyms.createEquipment(
        gymId: gym.id,
        name: 'Leg press 45° azul',
        type: EquipmentType.plateLoaded,
        loadUnit: LoadUnit.kg,
        loadBasis: LoadBasis.perSide,
        incrementMilli: 5000,
      );
      await workouts.swapEquipment(se2, other.id);
      final swapped = await workouts.watchSets(se2).first;
      expect(swapped.length, 2);
      expect(swapped.every((s) => s.loadMilli == null), isTrue);
      final ref = await workouts.previousOnOtherEquipment(
        exerciseId: ex.id,
        gymId: gym.id,
        excludeStationId:
            (await workouts.watchSessionExercises(s2).first).single.station.id,
        excludeSessionId: s2,
      );
      expect(ref!.otherEquipmentName, 'Leg press 45° preto');

      // Histórico agrega exercícios e séries
      final history = await workouts.watchHistory().first;
      expect(history.single.setCount, 2);
      expect(history.single.exerciseCount, 1);
    },
  );

  test('desfazer: série apagada volta igual', () async {
    final gym = await gyms.createGym('Academia');
    final ex = (await catalog.watchExercises(query: 'flexão').first).first;
    final s = await workouts.startFreeSession(gymId: gym.id);
    final se = await workouts.addExercise(
      sessionId: s,
      exerciseId: ex.id,
      restSec: 60,
    );
    final first = (await workouts.watchSets(se).first).first;
    final removed = await workouts.deleteSet(first.id);
    expect((await workouts.watchSets(se).first).length, 2);
    await workouts.restoreSet(removed!);
    final back = await workouts.watchSets(se).first;
    expect(back.length, 3);
    expect(back.first.id, first.id);
  });

  test(
    'backup: VACUUM INTO gera uma cópia que abre com os mesmos dados',
    () async {
      final gym = await gyms.createGym('Academia');
      final ex = (await catalog.watchExercises(query: 'supino').first).first;
      final s = await workouts.startFreeSession(gymId: gym.id);
      await workouts.addExercise(sessionId: s, exerciseId: ex.id, restSec: 60);

      final dir = await Directory.systemTemp.createTemp('nodefit_backup_test');
      addTearDown(() => dir.delete(recursive: true));
      final copy = File('${dir.path}/db.sqlite');
      await db.customStatement('VACUUM INTO ?', [copy.path]);

      final restored = AppDatabase(NativeDatabase(copy));
      addTearDown(restored.close);
      final gymsCopy = await restored.select(restored.gyms).get();
      final setsCopy = await restored.select(restored.workoutSets).get();
      expect(gymsCopy.single.name, 'Academia');
      expect(setsCopy.length, 3);
    },
  );

  Future<({String gymId, String exId, String a, String b})> twoMachines({
    LoadUnit unitB = LoadUnit.kg,
  }) async {
    final gym = await gyms.createGym('Academia');
    final a = await gyms.createEquipment(
      gymId: gym.id,
      name: 'Puxador A',
      type: EquipmentType.cable,
      loadUnit: LoadUnit.plate,
      loadBasis: LoadBasis.total,
      incrementMilli: 1000,
    );
    final b = await gyms.createEquipment(
      gymId: gym.id,
      name: 'Puxador B',
      type: EquipmentType.cable,
      loadUnit: unitB,
      loadBasis: LoadBasis.total,
      incrementMilli: 2500,
    );
    final ex = (await catalog.watchExercises(query: 'puxada').first).first;
    return (gymId: gym.id, exId: ex.id, a: a.id, b: b.id);
  }

  test(
    'trocar aparelho DEPOIS de séries feitas: elas ficam no aparelho antigo',
    () async {
      final m = await twoMachines();
      final s = await workouts.startFreeSession(gymId: m.gymId);
      final seA = await workouts.addExercise(
        sessionId: s,
        exerciseId: m.exId,
        equipmentId: m.a,
        restSec: 60,
      );
      var sets = await workouts.watchSets(seA).first;
      for (final x in sets.take(2)) {
        await workouts.updateSet(
          x.id,
          loadMilli: const Value(8000),
          reps: const Value(12),
        );
      }
      sets = await workouts.watchSets(seA).first;
      await workouts.completeSet(sets[0].id, sessionId: s, restSec: 60);
      await workouts.completeSet(sets[1].id, sessionId: s, restSec: 60);

      final active = await workouts.swapEquipment(seA, m.b);
      expect(
        active,
        isNot(seA),
        reason: 'o aparelho novo entra como item novo',
      );

      final views = await workouts.watchSessionExercises(s).first;
      expect(views.length, 2);
      expect(views[0].item.id, seA);
      expect(
        views[0].item.loadUnit,
        LoadUnit.plate,
        reason: 'unidade antiga preservada',
      );
      expect(views[1].item.id, active);
      expect(views[1].item.loadUnit, LoadUnit.kg);

      final oldSets = await workouts.watchSets(seA).first;
      expect(oldSets.length, 2);
      expect(oldSets.every((x) => x.completedAt != null), isTrue);
      final newSets = await workouts.watchSets(active).first;
      expect(newSets.length, 1, reason: 'a série que faltava foi para o novo');
      expect(
        newSets.single.loadMilli,
        isNull,
        reason: '"placa 8" não vira "8 kg"',
      );

      await workouts.finishSession(s);
      final prevB = await workouts.previousForStation(
        views[1].station.id,
        excludeSessionId: 'x',
      );
      expect(
        prevB,
        isNull,
        reason: 'o histórico do B não recebe as séries do A',
      );
      final prevA = await workouts.previousForStation(
        views[0].station.id,
        excludeSessionId: 'x',
      );
      expect(prevA!.sets.length, 2);
    },
  );

  test(
    'concluir: lê as reps do banco, ignora toque duplo e exige reps',
    () async {
      final m = await twoMachines();
      final s = await workouts.startFreeSession(gymId: m.gymId);
      final se = await workouts.addExercise(
        sessionId: s,
        exerciseId: m.exId,
        equipmentId: m.b,
        restSec: 60,
      );
      final first = (await workouts.watchSets(se).first).first;
      expect(
        await workouts.completeSet(first.id, sessionId: s, restSec: 60),
        isFalse,
        reason: 'sem repetições não conclui',
      );
      await workouts.updateSet(
        first.id,
        loadMilli: const Value(42500),
        reps: const Value(10),
      );
      expect(
        await workouts.completeSet(first.id, sessionId: s, restSec: 60),
        isTrue,
      );
      final once = (await workouts.watchSets(se).first).first;
      expect(
        once.loadMilli,
        42500,
        reason: 'não regrava valores antigos da tela',
      );
      expect(
        await workouts.completeSet(first.id, sessionId: s, restSec: 60),
        isTrue,
      );
      final twice = (await workouts.watchSets(se).first).first;
      expect(
        twice.completedAt,
        once.completedAt,
        reason: 'toque duplo não recarimba',
      );
    },
  );

  test('finalizar duas vezes não muda a duração', () async {
    final m = await twoMachines();
    final s = await workouts.startFreeSession(gymId: m.gymId);
    final se = await workouts.addExercise(
      sessionId: s,
      exerciseId: m.exId,
      equipmentId: m.b,
      restSec: 60,
    );
    final first = (await workouts.watchSets(se).first).first;
    await workouts.updateSet(first.id, reps: const Value(10));
    await workouts.completeSet(first.id, sessionId: s, restSec: 60);
    await workouts.finishSession(s);
    final ended = (await workouts.watchSession(s).first)!.endedAt;
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await workouts.finishSession(s);
    expect((await workouts.watchSession(s).first)!.endedAt, ended);
  });

  test(
    'aparelho escolhido por engano não aparece como "exercício neste aparelho"',
    () async {
      final m = await twoMachines();
      final s = await workouts.startFreeSession(gymId: m.gymId);
      final se = await workouts.addExercise(
        sessionId: s,
        exerciseId: m.exId,
        equipmentId: m.a,
        restSec: 60,
      );
      await workouts.swapEquipment(
        se,
        m.b,
      ); // sem séries feitas: troca no lugar
      expect(await stations.watchStationsForEquipment(m.a).first, isEmpty);
      expect((await stations.watchStationsForEquipment(m.b).first).length, 1);
    },
  );

  test('seletor: última vez, recentes e já feitos nesta academia', () async {
    final m = await twoMachines();
    final exLeg =
        (await catalog.watchExercises(query: 'leg press 45').first).first;
    final exFlex = (await catalog.watchExercises(query: 'flexão').first).first;

    var last = await stations.lastUseFor(exerciseId: m.exId, gymId: m.gymId);
    expect(last.found, isFalse, reason: 'nunca fez: o app pergunta o aparelho');

    final s = await workouts.startFreeSession(gymId: m.gymId);
    await workouts.addExercise(
      sessionId: s,
      exerciseId: m.exId,
      equipmentId: m.b,
      restSec: 60,
    );
    await workouts.addExercise(
      sessionId: s,
      exerciseId: exFlex.id,
      restSec: 60,
    );
    await workouts.addExercise(
      sessionId: s,
      exerciseId: exLeg.id,
      equipmentId: m.a,
      restSec: 60,
    );

    last = await stations.lastUseFor(exerciseId: m.exId, gymId: m.gymId);
    expect(last, (found: true, equipmentId: m.b));
    final flex = await stations.lastUseFor(
      exerciseId: exFlex.id,
      gymId: m.gymId,
    );
    expect(flex, (
      found: true,
      equipmentId: null,
    ), reason: 'última vez foi sem aparelho');

    await gyms.archiveEquipment(m.b);
    last = await stations.lastUseFor(exerciseId: m.exId, gymId: m.gymId);
    expect(last.found, isFalse, reason: 'aparelho arquivado: pergunta de novo');

    final recent = await catalog.watchRecentAt(m.gymId).first;
    expect(recent.map((r) => r.exercise.id), [
      exLeg.id,
      exFlex.id,
      m.exId,
    ], reason: 'mais recente primeiro, sem repetir');
    expect(recent.first.equipment!.id, m.a);
    expect(recent.last.equipment, isNull, reason: 'arquivado não aparece');
    expect(await catalog.watchDoneIdsAt(m.gymId).first, {
      m.exId,
      exFlex.id,
      exLeg.id,
    });
  });

  test(
    'concluir: a próxima série vazia repete esta, sem sobrescrever',
    () async {
      final m = await twoMachines();
      final s = await workouts.startFreeSession(gymId: m.gymId);
      final se = await workouts.addExercise(
        sessionId: s,
        exerciseId: m.exId,
        equipmentId: m.b,
        restSec: 60,
      );
      var sets = await workouts.watchSets(se).first;
      await workouts.updateSet(
        sets[0].id,
        loadMilli: const Value(42500),
        reps: const Value(10),
      );
      await workouts.updateSet(
        sets[2].id,
        loadMilli: const Value(50000),
        reps: const Value(6),
      );
      await workouts.completeSet(sets[0].id, sessionId: s, restSec: 60);
      sets = await workouts.watchSets(se).first;
      expect(
        (sets[1].loadMilli, sets[1].reps),
        (42500, 10),
        reason: 'herdou a anterior',
      );
      expect(
        (sets[2].loadMilli, sets[2].reps),
        (50000, 6),
        reason: 'já preenchida: intacta',
      );
    },
  );
}
