// Capturas de tela das telas reais, com fontes de verdade e dados de exemplo.
// Não faz parte da suíte normal (fica fora de test/). Para gerar:
//   flutter test test_screens --update-goldens
// As imagens saem em test_screens/goldens/.
import 'dart:io';

import 'package:drift/drift.dart' show Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/app/app.dart';
import 'package:nodefit/app/router.dart';
import 'package:nodefit/app/theme/app_theme.dart';
import 'package:nodefit/features/auth/data/auth_service.dart';
import 'package:nodefit/features/catalog/presentation/exercise_picker_sheet.dart';
import 'package:nodefit/features/gyms/presentation/equipment_picker_sheet.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/db/database_provider.dart';
import 'package:nodefit/core/domain/enums.dart';
import 'package:nodefit/core/prefs/prefs_repository.dart';
import 'package:nodefit/core/domain/body.dart';
import 'package:nodefit/features/body/data/body_repository.dart';
import 'package:nodefit/features/catalog/data/catalog_repository.dart';
import 'package:nodefit/features/gyms/data/gym_repository.dart';
import 'package:nodefit/features/gyms/data/station_repository.dart';
import 'package:nodefit/features/routines/data/routine_repository.dart';
import 'package:nodefit/features/workout/data/workout_repository.dart';

Future<void> _loadFonts() async {
  final root = Platform.environment['FLUTTER_ROOT'] ?? r'C:\develop\flutter';
  final dir = '$root/bin/cache/artifacts/material_fonts';
  Future<ByteData> f(String name) async =>
      ByteData.sublistView(File('$dir/$name').readAsBytesSync());
  await (FontLoader('Roboto')
        ..addFont(f('roboto-regular.ttf'))
        ..addFont(f('roboto-medium.ttf'))
        ..addFont(f('roboto-bold.ttf')))
      .load();
  await (FontLoader(
    'MaterialIcons',
  )..addFont(f('materialicons-regular.otf'))).load();
}

class _Seeded {
  _Seeded(
    this.activeSessionId,
    this.stationId,
    this.routineId,
    this.pastId,
    this.gymId,
    this.newExercise,
    this.checkinId,
  );
  final String checkinId;
  final String activeSessionId;
  final String stationId;
  final String routineId;
  final String pastId;
  final String gymId;
  final Exercise newExercise;
}

Future<_Seeded> _seed(AppDatabase db) async {
  final prefs = PrefsRepository(db);
  // As telas são protegidas: as capturas partem de um usuário logado.
  await AuthService(db)
      .register(name: 'João', email: 'joao@nodefit.app', password: 'senha123');
  await CatalogSeeder(
    db,
    prefs,
  ).run(File('assets/seed/exercicios_pt_br.json').readAsStringSync());
  final gyms = GymRepository(db);
  final stations = StationRepository(db);
  final workouts = WorkoutRepository(db, stations);
  final catalog = CatalogRepository(db);
  final routines = RoutineRepository(db);

  final gym = await gyms.createGym('Academia do bairro');
  await prefs.set(PrefKeys.currentGymId, gym.id);
  final extensora = await gyms.createEquipment(
    gymId: gym.id,
    name: 'Cadeira extensora',
    type: EquipmentType.machine,
    loadUnit: LoadUnit.kg,
    loadBasis: LoadBasis.total,
    incrementMilli: 5000,
    gymLabel: '12',
  );
  final legPress = await gyms.createEquipment(
    gymId: gym.id,
    name: 'Leg press 45° preto',
    type: EquipmentType.plateLoaded,
    loadUnit: LoadUnit.kg,
    loadBasis: LoadBasis.perSide,
    incrementMilli: 5000,
  );
  Future<Exercise> ex(String q) async =>
      (await catalog.watchExercises(query: q).first).first;
  final exExt = await ex('cadeira extensora');
  final exLeg = await ex('leg press 45');
  final exSup = await ex('supino maquina');

  // Fichas A e B (a do professor, com vencimento).
  final a = await routines.createRoutine(
    name: 'Pernas',
    label: 'A',
    gymId: gym.id,
  );
  await routines.addItem(
    routineId: a.id,
    exerciseId: exExt.id,
    preferredEquipmentId: extensora.id,
  );
  await routines.addItem(
    routineId: a.id,
    exerciseId: exLeg.id,
    preferredEquipmentId: legPress.id,
    repMin: 10,
    repMax: 12,
    restSec: 120,
  );
  final itemExt = (await routines.getItems(a.id)).first.item;
  await routines.updateItem(
    itemExt,
    targetSets: 3,
    repMin: 8,
    repMax: 12,
    restSec: 90,
    warmupSets: 1,
    preferredEquipmentId: extensora.id,
    notes: 'Pausa de 1 s em cima',
    tempo: null,
  );
  final venc = DateTime.now().add(const Duration(days: 9));
  await routines.updateRoutine(
    a.id,
    name: 'Pernas',
    label: 'A',
    trainer: 'Prof. Carla',
    expiresOn:
        '${venc.year}-${venc.month.toString().padLeft(2, '0')}-${venc.day.toString().padLeft(2, '0')}',
  );
  // Extensora + leg press em bi-set.
  await routines.linkItemWithNext((await routines.getItems(a.id)).first.item);
  final b = await routines.createRoutine(
    name: 'Peito/Tríceps',
    label: 'B',
    gymId: gym.id,
  );
  await routines.addItem(routineId: b.id, exerciseId: exSup.id);

  Future<void> fill(
    String sessionId,
    Map<String, List<(int, int)>> byExercise,
  ) async {
    final views = await workouts.watchSessionExercises(sessionId).first;
    for (final v in views) {
      final values = byExercise[v.exercise.id] ?? const [];
      final sets = await workouts.watchSets(v.item.id).first;
      for (var i = 0; i < sets.length && i < values.length; i++) {
        await workouts.updateSet(
          sets[i].id,
          loadMilli: Value(values[i].$1),
          reps: Value(values[i].$2),
        );
        await workouts.completeSet(
          sets[i].id,
          sessionId: sessionId,
          restSec: 90,
        );
      }
    }
  }

  Future<void> backdate(String id, int days, int minutes) async {
    final when = DateTime.now().toUtc().subtract(Duration(days: days));
    await (db.update(db.workoutSessions)..where((s) => s.id.equals(id))).write(
      WorkoutSessionsCompanion(
        startedAt: Value(when),
        endedAt: Value(when.add(Duration(minutes: minutes))),
      ),
    );
  }

  // Há 5 dias: treino livre mais leve (base para o recorde).
  final old = await workouts.startFreeSession(gymId: gym.id);
  await workouts.addExercise(
    sessionId: old,
    exerciseId: exExt.id,
    equipmentId: extensora.id,
    restSec: 90,
  );
  await fill(old, {
    exExt.id: [(35000, 12), (35000, 12), (35000, 11)],
  });
  await workouts.finishSession(old);
  await backdate(old, 5, 48);

  // Ontem: Ficha A.
  final past = await workouts.startFromRoutine(
    routineId: a.id,
    gymId: gym.id,
    defaultRestSec: 90,
  );
  await fill(past, {
    exExt.id: [(20000, 12), (40000, 12), (40000, 12), (40000, 11)],
    exLeg.id: [(80000, 12), (80000, 12), (80000, 12)],
  });
  final views = await workouts.watchSessionExercises(past).first;
  await workouts.updateHowItWent(
    views.first.item.id,
    text: '3ª série pesada, joelho ok',
    tag: EffortTag.ok,
  );
  final station = views.first.station;
  final banco = await stations.addSetting(
    stationId: station.id,
    label: 'Banco',
    kind: SettingKind.number,
    valueNum: 7,
  );
  await stations.addSetting(
    stationId: station.id,
    label: 'Encosto',
    kind: SettingKind.number,
    valueNum: 3,
  );
  await stations.addSetting(
    stationId: station.id,
    label: 'Rolo / apoio',
    kind: SettingKind.number,
    valueNum: 4,
  );
  await stations.updateSettingValue(banco, valueNum: 8);
  await stations.updatePinnedNote(
    station.id,
    'Encostar bem a lombar; não travar o joelho no topo',
  );
  await workouts.finishSession(past);
  await backdate(past, 1, 52);

  // Hoje: Ficha A de novo, aquecimento feito.
  final today = await workouts.startFromRoutine(
    routineId: a.id,
    gymId: gym.id,
    defaultRestSec: 90,
  );
  final first = (await workouts.watchSessionExercises(today).first).first;
  final warm = (await workouts.watchSets(first.item.id).first).first;
  await workouts.updateSet(
    warm.id,
    loadMilli: const Value(20000),
    reps: const Value(12),
  );
  await workouts.completeSet(warm.id, sessionId: today, restSec: 90);
  // No fim: prancha (por tempo) e esteira (cardio).
  final plank = await workouts.addExercise(
    sessionId: today,
    exerciseId: 'prancha',
    restSec: 60,
  );
  final plankSets = await workouts.watchSets(plank).first;
  await workouts.updateSet(plankSets.first.id, durationSec: const Value(60));
  await workouts.completeSet(plankSets.first.id, sessionId: today, restSec: 0);
  // Corpo: perfil e 4 check-ins semanais.
  final body = BodyRepository(db, prefs);
  await body.saveProfile(sex: Sex.male, heightCm: 178, birthYear: 1998);
  String? lastCheckin;
  final weights = [82400, 81700, 81900, 81100];
  for (var i = 0; i < weights.length; i++) {
    lastCheckin = await body.saveCheckin(
      takenAt: DateTime.now().toUtc().subtract(Duration(days: 21 - 7 * i)),
      values: {
        BodyMetric.weight: weights[i],
        BodyMetric.neck: 38500,
        BodyMetric.abdomen: 91000 - 1000 * i,
        BodyMetric.arm: 36000 + 250 * i,
        BodyMetric.bodyFat: 21800 - 400 * i,
        BodyMetric.muscleMass: 60100 + 150 * i,
      },
      notes: i == 3 ? 'De manhã, em jejum' : null,
    );
  }
  final run = await workouts.addExercise(
    sessionId: today,
    exerciseId: 'esteira',
    restSec: 90,
  );
  final runSet = (await workouts.watchSets(run).first).single;
  await workouts.updateSet(
    runSet.id,
    durationSec: const Value(1200),
    distanceM: const Value(2500),
  );
  return _Seeded(
    today,
    station.id,
    a.id,
    past,
    gym.id,
    await ex('remada baixa'),
    lastCheckin!,
  );
}

void main() {
  setUpAll(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
    await _loadFonts();
  });

  Future<void> capture(
    WidgetTester tester, {
    required String name,
    required String location,
    double textScale = 1.0,
    String? scrollTo,
    String? tap,
    bool loggedOut = false,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340); // ~Galaxy S26
    tester.view.devicePixelRatio = 2.625;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final overflows = <String>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      final text = details.exceptionAsString();
      if (text.contains('overflowed')) {
        overflows.add(text.split('\n').first);
      } else {
        previous?.call(details);
      }
    };

    final db = AppDatabase(NativeDatabase.memory());
    final seeded = (await tester.runAsync(() => _seed(db)))!;
    if (loggedOut) await tester.runAsync(() => AuthService(db).logout());
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      retry: (_, _) => null,
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const NodeFitApp(),
      ),
    );
    final loc = location
        .replaceAll('{session}', seeded.activeSessionId)
        .replaceAll('{station}', seeded.stationId)
        .replaceAll('{routine}', seeded.routineId)
        .replaceAll('{past}', seeded.pastId)
        .replaceAll('{checkin}', seeded.checkinId);
    container.read(routerProvider).go(loc);
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)),
      );
      await tester.pump(const Duration(milliseconds: 120));
    }
    if (tap != null) {
      await tester.tap(find.text(tap));
      for (var i = 0; i < 4; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 60)),
        );
        await tester.pump(const Duration(milliseconds: 200));
      }
    }
    if (scrollTo != null) {
      await tester.scrollUntilVisible(
        find.text(scrollTo),
        400,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 300));
    }
    await expectLater(
      find.byType(NodeFitApp),
      matchesGoldenFile('goldens/$name.png'),
    );
    FlutterError.onError = previous;
    // ignore: avoid_print
    print(
      'OVERFLOWS[$name]: ${overflows.isEmpty ? 'nenhum' : overflows.toSet().join(' | ')}',
    );

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose(); // antes de avançar o relógio: os streams fecham agora
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  }

  Future<void> captureSheet(
    WidgetTester tester, {
    required String name,
    required void Function(BuildContext context, _Seeded seeded) open,
  }) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    final seeded = (await tester.runAsync(() => _seed(db)))!;
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      retry: (_, _) => null,
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: buildDarkTheme(),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Builder(
              builder: (ctx) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) => open(ctx, seeded),
                );
                return const SizedBox.expand();
              },
            ),
          ),
        ),
      ),
    );
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 60)),
      );
      await tester.pump(const Duration(milliseconds: 150));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  }

  testWidgets(
    '01 treinar',
    (t) => capture(t, name: '01_treinar', location: '/treinar'),
  );
  testWidgets(
    '02 treino',
    (t) => capture(t, name: '02_treino', location: sessionPath('{session}')),
  );
  testWidgets(
    '03 treino fonte 130%',
    (t) => capture(
      t,
      name: '03_treino_fonte130',
      location: sessionPath('{session}'),
      textScale: 1.3,
    ),
  );
  testWidgets(
    '04 estacao',
    (t) =>
        capture(t, name: '04_estacao', location: '/caderno/estacao/{station}'),
  );
  testWidgets(
    '05 caderno',
    (t) => capture(t, name: '05_caderno', location: '/caderno'),
  );
  testWidgets(
    '06 progresso',
    (t) => capture(t, name: '06_progresso', location: '/progresso'),
  );
  testWidgets(
    '07 ficha',
    (t) => capture(t, name: '07_ficha', location: '/treinar/ficha/{routine}'),
  );
  testWidgets(
    '08 resumo',
    (t) => capture(t, name: '08_resumo', location: '/progresso/sessao/{past}'),
  );
  testWidgets('09 mais', (t) => capture(t, name: '09_mais', location: '/mais'));
  testWidgets(
    '22 relatorio professor',
    (t) => capture(
      t,
      name: '22_relatorio_professor',
      location: '/mais/relatorio/professor',
    ),
  );
  testWidgets(
    '23 relatorio medico',
    (t) => capture(
      t,
      name: '23_relatorio_medico',
      location: '/mais/relatorio/medico',
    ),
  );
  testWidgets(
    '20 login',
    (t) => capture(t, name: '20_login', location: '/login', loggedOut: true),
  );
  testWidgets(
    '21 cadastro',
    (t) =>
        capture(t, name: '21_cadastro', location: '/cadastro', loggedOut: true),
  );
  testWidgets(
    '12 treino cardio',
    (t) => capture(
      t,
      name: '12_treino_cardio',
      location: sessionPath('{session}'),
      scrollTo: 'Esteira',
    ),
  );
  testWidgets(
    '13 corpo',
    (t) => capture(t, name: '13_corpo', location: '/progresso', tap: 'Corpo'),
  );
  testWidgets(
    '14 corpo graficos',
    (t) => capture(
      t,
      name: '14_corpo_graficos',
      location: '/progresso',
      tap: 'Corpo',
      scrollTo: 'CHECK-INS',
    ),
  );
  testWidgets(
    '15 checkin',
    (t) => capture(t, name: '15_checkin', location: '/checkin/{checkin}'),
  );
  testWidgets(
    '10 escolher exercicio',
    (t) => captureSheet(
      t,
      name: '10_escolher_exercicio',
      open: (ctx, s) => showExercisePicker(ctx, gymId: s.gymId),
    ),
  );
  testWidgets(
    '11 escolher aparelho',
    (t) => captureSheet(
      t,
      name: '11_escolher_aparelho',
      open: (ctx, s) =>
          showEquipmentPicker(ctx, gymId: s.gymId, exercise: s.newExercise),
    ),
  );
}
