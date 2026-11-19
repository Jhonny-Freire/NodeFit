import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/superset.dart';
import '../../../core/utils/ids.dart';

part 'routine_repository.g.dart';

/// Ficha com o resumo que a tela inicial precisa.
class RoutineSummary {
  const RoutineSummary({
    required this.routine,
    required this.exerciseCount,
    this.lastDoneAt,
  });
  final Routine routine;
  final int exerciseCount;
  final DateTime? lastDoneAt;

  /// "Ficha A · Peito/Tríceps" ou só o nome.
  String get title => routineTitle(routine);
}

String routineTitle(Routine r) => (r.label == null || r.label!.trim().isEmpty)
    ? r.name
    : 'Ficha ${r.label} · ${r.name}';

/// Item da ficha com exercício e aparelho preferido carregados.
class RoutineItemView {
  const RoutineItemView({
    required this.item,
    required this.exercise,
    this.equipment,
  });
  final RoutineExercise item;
  final Exercise exercise;
  final EquipmentItem? equipment;

  /// "3 × 8–12 · 90 s · 1 aquec."
  String get prescription {
    final reps = switch ((item.repMin, item.repMax)) {
      (final a?, final b?) when a != b => '$a–$b',
      (final a?, _) => '$a',
      (_, final b?) => '$b',
      _ => '?',
    };
    return [
      '${item.targetSets} × $reps',
      if (item.restSec != null) '${item.restSec} s',
      if (item.warmupSets > 0) '${item.warmupSets} aquec.',
      if (item.tempo != null) 'cadência ${item.tempo}',
    ].join(' · ');
  }
}

/// Fichas (A, B, C...): a do professor ou as suas.
class RoutineRepository {
  RoutineRepository(this._db);
  final AppDatabase _db;

  /// Fichas da academia (e as sem academia), com nº de exercícios e a última
  /// vez que foram feitas.
  Stream<List<RoutineSummary>> watchRoutines(String gymId) {
    final count = _db.routineExercises.id.count(distinct: true);
    final lastDone = _db.workoutSessions.startedAt.max();
    final q =
        _db.select(_db.routines).join([
            leftOuterJoin(
              _db.routineExercises,
              _db.routineExercises.routineId.equalsExp(_db.routines.id),
            ),
            leftOuterJoin(
              _db.workoutSessions,
              _db.workoutSessions.routineId.equalsExp(_db.routines.id) &
                  _db.workoutSessions.endedAt.isNotNull(),
            ),
          ])
          ..addColumns([count, lastDone])
          ..where(
            _db.routines.archivedAt.isNull() &
                (_db.routines.gymId.isNull() |
                    _db.routines.gymId.equals(gymId)),
          )
          ..groupBy([_db.routines.id])
          ..orderBy([
            OrderingTerm.asc(_db.routines.sortOrder),
            OrderingTerm.asc(_db.routines.label),
            OrderingTerm.asc(_db.routines.name),
          ]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          RoutineSummary(
            routine: r.readTable(_db.routines),
            exerciseCount: r.read(count) ?? 0,
            lastDoneAt: r.read(lastDone),
          ),
      ],
    );
  }

  /// Quando esta ficha foi feita pela última vez (só treinos terminados).
  Stream<DateTime?> watchLastDone(String routineId) {
    final last = _db.workoutSessions.startedAt.max();
    return (_db.selectOnly(_db.workoutSessions)
          ..addColumns([last])
          ..where(
            _db.workoutSessions.routineId.equals(routineId) &
                _db.workoutSessions.endedAt.isNotNull(),
          ))
        .map((r) => r.read(last))
        .watchSingle();
  }

  Stream<Routine?> watchRoutine(String id) => (_db.select(
    _db.routines,
  )..where((r) => r.id.equals(id))).watchSingleOrNull();

  Stream<List<RoutineItemView>> watchItems(String routineId) {
    final q =
        _db.select(_db.routineExercises).join([
            innerJoin(
              _db.exercises,
              _db.exercises.id.equalsExp(_db.routineExercises.exerciseId),
            ),
            leftOuterJoin(
              _db.equipment,
              _db.equipment.id.equalsExp(
                _db.routineExercises.preferredEquipmentId,
              ),
            ),
          ])
          ..where(_db.routineExercises.routineId.equals(routineId))
          ..orderBy([OrderingTerm.asc(_db.routineExercises.position)]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          RoutineItemView(
            item: r.readTable(_db.routineExercises),
            exercise: r.readTable(_db.exercises),
            equipment: r.readTableOrNull(_db.equipment),
          ),
      ],
    );
  }

  Future<List<RoutineItemView>> getItems(String routineId) =>
      watchItems(routineId).first;

  Future<Routine> createRoutine({
    required String name,
    String? label,
    String? gymId,
  }) => _db.transaction(() async {
    final maxOrder = _db.routines.sortOrder.max();
    final last = await (_db.selectOnly(
      _db.routines,
    )..addColumns([maxOrder])).map((r) => r.read(maxOrder)).getSingle();
    return _db
        .into(_db.routines)
        .insertReturning(
          RoutinesCompanion.insert(
            name: name.trim(),
            label: Value(_blankToNull(label)),
            gymId: Value(gymId),
            sortOrder: Value((last ?? -1) + 1),
          ),
        );
  });

  Future<void> updateRoutine(
    String id, {
    required String name,
    String? label,
    String? trainer,
    String? expiresOn,
    String? nextOn,
    String? notes,
  }) => (_db.update(_db.routines)..where((r) => r.id.equals(id))).write(
    RoutinesCompanion(
      name: Value(name.trim()),
      label: Value(_blankToNull(label)),
      trainer: Value(_blankToNull(trainer)),
      expiresOn: Value(_blankToNull(expiresOn)),
      nextOn: Value(_blankToNull(nextOn)),
      notes: Value(_blankToNull(notes)),
      updatedAt: Value(nowUtc()),
    ),
  );

  /// Some da lista; os treinos feitos com ela continuam no histórico.
  Future<void> archiveRoutine(String id) =>
      (_db.update(_db.routines)..where((r) => r.id.equals(id))).write(
        RoutinesCompanion(
          archivedAt: Value(nowUtc()),
          updatedAt: Value(nowUtc()),
        ),
      );

  /// Cópia da ficha (ex.: a nova ficha do professor parte da anterior).
  Future<Routine> duplicateRoutine(String id) => _db.transaction(() async {
    final src = await (_db.select(
      _db.routines,
    )..where((r) => r.id.equals(id))).getSingle();
    final copy = await createRoutine(
      name: '${src.name} (cópia)',
      label: src.label,
      gymId: src.gymId,
    );
    await updateRoutine(
      copy.id,
      name: copy.name,
      label: src.label,
      trainer: src.trainer,
      notes: src.notes,
    );
    final items =
        await (_db.select(_db.routineExercises)
              ..where((e) => e.routineId.equals(id))
              ..orderBy([(e) => OrderingTerm.asc(e.position)]))
            .get();
    for (final it in items) {
      await _db
          .into(_db.routineExercises)
          .insert(
            it
                .toCompanion(true)
                .copyWith(
                  id: Value(newId()),
                  routineId: Value(copy.id),
                  createdAt: Value(nowUtc()),
                  updatedAt: Value(nowUtc()),
                ),
          );
    }
    return copy;
  });

  /// "Salvar como ficha": o treino feito vira uma ficha nova, com os
  /// exercícios na ordem, o aparelho usado, as séries de trabalho e a faixa
  /// de reps que você fez (ou a da ficha de origem). Exercícios sem série
  /// concluída ficam de fora.
  Future<Routine> saveSessionAsRoutine({
    required String sessionId,
    required String name,
    String? label,
  }) => _db.transaction(() async {
    final session = await (_db.select(
      _db.workoutSessions,
    )..where((s) => s.id.equals(sessionId))).getSingle();
    final rows =
        await (_db.select(_db.sessionExercises).join([
                innerJoin(
                  _db.stations,
                  _db.stations.id.equalsExp(_db.sessionExercises.stationId),
                ),
              ])
              ..where(_db.sessionExercises.sessionId.equals(sessionId))
              ..orderBy([OrderingTerm.asc(_db.sessionExercises.position)]))
            .get();
    final routine = await createRoutine(
      name: name,
      label: label,
      gymId: session.gymId,
    );
    var position = 1;
    for (final r in rows) {
      final se = r.readTable(_db.sessionExercises);
      final done =
          await (_db.select(_db.workoutSets)..where(
                (s) =>
                    s.sessionExerciseId.equals(se.id) &
                    s.completedAt.isNotNull(),
              ))
              .get();
      final working = done.where((s) => s.setType != SetType.warmup).toList();
      if (working.isEmpty) continue;
      final reps = [
        for (final s in working)
          if (s.reps != null && s.reps! > 0) s.reps!,
      ]..sort();
      await _db
          .into(_db.routineExercises)
          .insert(
            RoutineExercisesCompanion.insert(
              routineId: routine.id,
              exerciseId: se.exerciseId,
              preferredEquipmentId: Value(
                r.readTable(_db.stations).equipmentId,
              ),
              position: position++,
              targetSets: Value(working.length),
              repMin: Value(se.repMin ?? reps.firstOrNull),
              repMax: Value(se.repMax ?? reps.lastOrNull),
              restSec: Value(se.restSec),
              warmupSets: Value(done.length - working.length),
              supersetGroup: Value(se.supersetGroup),
            ),
          );
    }
    // Se um par do bi-set ficou de fora, o outro volta a ser solo.
    await _regroup(routine.id, (groups, _) => normalizeSupersets(groups));
    return routine;
  });

  Future<String> addItem({
    required String routineId,
    required String exerciseId,
    String? preferredEquipmentId,
    int targetSets = 3,
    int? repMin = 8,
    int? repMax = 12,
    int? restSec,
  }) => _db.transaction(() async {
    final maxPos = _db.routineExercises.position.max();
    final last =
        await (_db.selectOnly(_db.routineExercises)
              ..addColumns([maxPos])
              ..where(_db.routineExercises.routineId.equals(routineId)))
            .map((r) => r.read(maxPos))
            .getSingle();
    final row = await _db
        .into(_db.routineExercises)
        .insertReturning(
          RoutineExercisesCompanion.insert(
            routineId: routineId,
            exerciseId: exerciseId,
            preferredEquipmentId: Value(preferredEquipmentId),
            position: (last ?? 0) + 1,
            targetSets: Value(targetSets),
            repMin: Value(repMin),
            repMax: Value(repMax),
            restSec: Value(restSec),
          ),
        );
    await _touch(routineId);
    return row.id;
  });

  Future<void> updateItem(
    RoutineExercise item, {
    required int targetSets,
    required int? repMin,
    required int? repMax,
    required int? restSec,
    required int warmupSets,
    required String? preferredEquipmentId,
    required String? notes,
    required String? tempo,
  }) async {
    await (_db.update(
      _db.routineExercises,
    )..where((e) => e.id.equals(item.id))).write(
      RoutineExercisesCompanion(
        targetSets: Value(targetSets),
        repMin: Value(repMin),
        repMax: Value(repMax),
        restSec: Value(restSec),
        warmupSets: Value(warmupSets),
        preferredEquipmentId: Value(preferredEquipmentId),
        notes: Value(_blankToNull(notes)),
        tempo: Value(_blankToNull(tempo)),
        updatedAt: Value(nowUtc()),
      ),
    );
    await _touch(item.routineId);
  }

  Future<void> removeItem(RoutineExercise item) => _db.transaction(() async {
    await (_db.delete(
      _db.routineExercises,
    )..where((e) => e.id.equals(item.id))).go();
    await _regroup(item.routineId, (groups, _) => normalizeSupersets(groups));
    await _touch(item.routineId);
  });

  /// Reordena: [orderedIds] na ordem nova.
  Future<void> reorder(String routineId, List<String> orderedIds) =>
      _db.transaction(() async {
        for (var i = 0; i < orderedIds.length; i++) {
          await (_db.update(_db.routineExercises)
                ..where((e) => e.id.equals(orderedIds[i])))
              .write(RoutineExercisesCompanion(position: Value(i + 1)));
        }
        // Mover pode separar um bi-set: só vale entre vizinhos.
        await _regroup(routineId, (groups, _) => normalizeSupersets(groups));
        await _touch(routineId);
      });

  /// Na ficha: fazer este exercício junto com o seguinte (bi-set).
  Future<void> linkItemWithNext(RoutineExercise item) =>
      _regroupAround(item, linkWithNext);

  /// Na ficha: voltar a fazer este exercício sozinho.
  Future<void> unlinkItem(RoutineExercise item) =>
      _regroupAround(item, unlinkAt);

  Future<void> _regroupAround(
    RoutineExercise item,
    List<int?> Function(List<int?> groups, int index) change,
  ) => _db.transaction(() async {
    await _regroup(
      item.routineId,
      (groups, items) =>
          change(groups, items.indexWhere((e) => e.id == item.id)),
    );
    await _touch(item.routineId);
  });

  Future<void> _regroup(
    String routineId,
    List<int?> Function(List<int?> groups, List<RoutineExercise> items) change,
  ) async {
    final items =
        await (_db.select(_db.routineExercises)
              ..where((e) => e.routineId.equals(routineId))
              ..orderBy([(e) => OrderingTerm.asc(e.position)]))
            .get();
    final next = change([for (final e in items) e.supersetGroup], items);
    for (var i = 0; i < items.length; i++) {
      if (items[i].supersetGroup == next[i]) continue;
      await (_db.update(_db.routineExercises)
            ..where((e) => e.id.equals(items[i].id)))
          .write(RoutineExercisesCompanion(supersetGroup: Value(next[i])));
    }
  }

  /// A próxima ficha do rodízio: a que vem depois da última feita nesta
  /// academia (ou a primeira).
  Future<RoutineSummary?> nextRoutine(
    String gymId,
    List<RoutineSummary> routines,
  ) async {
    final usable = routines.where((r) => r.exerciseCount > 0).toList();
    if (usable.isEmpty) return null;
    final last =
        await (_db.select(_db.workoutSessions)
              ..where(
                (s) =>
                    s.gymId.equals(gymId) &
                    s.routineId.isNotNull() &
                    s.endedAt.isNotNull(),
              )
              ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    final idx = usable.indexWhere((r) => r.routine.id == last?.routineId);
    return usable[(idx + 1) % usable.length];
  }

  Future<void> _touch(String routineId) =>
      (_db.update(_db.routines)..where((r) => r.id.equals(routineId))).write(
        RoutinesCompanion(updatedAt: Value(nowUtc())),
      );
}

String? _blankToNull(String? s) =>
    (s == null || s.trim().isEmpty) ? null : s.trim();

@Riverpod(keepAlive: true)
RoutineRepository routineRepository(Ref ref) =>
    RoutineRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<RoutineSummary>> gymRoutines(Ref ref, String gymId) =>
    ref.watch(routineRepositoryProvider).watchRoutines(gymId);

@riverpod
Stream<Routine?> routine(Ref ref, String id) =>
    ref.watch(routineRepositoryProvider).watchRoutine(id);

@riverpod
Stream<DateTime?> routineLastDone(Ref ref, String routineId) =>
    ref.watch(routineRepositoryProvider).watchLastDone(routineId);

@riverpod
Stream<List<RoutineItemView>> routineItems(Ref ref, String routineId) =>
    ref.watch(routineRepositoryProvider).watchItems(routineId);

/// Próxima ficha do rodízio (recalcula quando a lista muda).
@riverpod
Future<RoutineSummary?> nextRoutine(Ref ref, String gymId) async {
  final routines = await ref.watch(gymRoutinesProvider(gymId).future);
  // Recalcula quando um treino termina.
  ref.watch(_finishedCountProvider(gymId));
  return ref.read(routineRepositoryProvider).nextRoutine(gymId, routines);
}

@riverpod
Stream<int> _finishedCount(Ref ref, String gymId) {
  final db = ref.watch(appDatabaseProvider);
  final c = db.workoutSessions.id.count();
  return (db.selectOnly(db.workoutSessions)
        ..addColumns([c])
        ..where(
          db.workoutSessions.gymId.equals(gymId) &
              db.workoutSessions.endedAt.isNotNull(),
        ))
      .map((r) => r.read(c) ?? 0)
      .watchSingle();
}
