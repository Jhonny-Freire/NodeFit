import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/body.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/domain/one_rep_max.dart';
import '../../../core/domain/progression.dart';
import '../../../core/domain/records.dart';
import '../../../core/domain/superset.dart';
import '../../../core/domain/warmup.dart';
import '../../../core/utils/ids.dart';
import '../../gyms/data/station_repository.dart';
import '../../routines/data/routine_repository.dart';

part 'workout_repository.g.dart';

/// Exercício da sessão com tudo o que a tela precisa.
class SessionExerciseView {
  const SessionExerciseView({
    required this.item,
    required this.exercise,
    required this.station,
    this.equipment,
    this.routineItem,
  });
  final SessionExercise item;
  final Exercise exercise;
  final Station station;
  final EquipmentItem? equipment;

  /// Item da ficha de onde veio (notas e cadência do professor).
  final RoutineExercise? routineItem;

  String get equipmentName => equipmentDisplayName(equipment);
}

/// O que você fez da última vez (coluna "Anterior" e nota "como foi").
class PreviousPerformance {
  const PreviousPerformance({
    required this.startedAt,
    required this.sets,
    required this.unit,
    this.howItWent,
    this.effortTag,
    this.pain = false,
    this.otherEquipmentName,
  });
  final DateTime startedAt;

  /// Séries concluídas, na ordem.
  final List<WorkoutSet> sets;
  final LoadUnit unit;
  final String? howItWent;
  final EffortTag? effortTag;
  final bool pain;

  /// Preenchido quando a referência veio de OUTRO aparelho (só referência,
  /// nunca pré-preenche as séries).
  final String? otherEquipmentName;

  bool get fromOtherEquipment => otherEquipmentName != null;
}

/// Uma vez em que a estação foi usada.
class StationHistoryEntry {
  const StationHistoryEntry({
    required this.startedAt,
    required this.sessionId,
    required this.item,
    required this.sets,
  });
  final DateTime startedAt;
  final String sessionId;
  final SessionExercise item;
  final List<WorkoutSet> sets;
}

/// Um ponto do gráfico de evolução: o melhor do dia numa estação.
class ProgressPoint {
  const ProgressPoint({
    required this.day,
    required this.maxLoadMilli,
    required this.bestE1rm,
    required this.unit,
  });
  final DateTime day;
  final int maxLoadMilli;

  /// Epley, só séries de 1–10 reps; null se nenhuma série serviu.
  final double? bestE1rm;
  final LoadUnit unit;
}

/// Do mais antigo para o mais novo, só séries de trabalho com carga e só na
/// unidade do treino mais recente (kg e "placa" não cabem no mesmo eixo).
List<ProgressPoint> progressPointsOf(List<StationHistoryEntry> entries) {
  if (entries.isEmpty) return const [];
  final newest = entries.reduce(
    (a, b) => b.startedAt.isAfter(a.startedAt) ? b : a,
  );
  final unit = newest.item.loadUnit;
  final points = <ProgressPoint>[];
  for (final e in entries) {
    if (e.item.loadUnit != unit) continue;
    int? maxLoad;
    double? best;
    for (final s in e.sets) {
      if (s.setType == SetType.warmup || s.loadMilli == null) continue;
      if (maxLoad == null || s.loadMilli! > maxLoad) maxLoad = s.loadMilli;
      final e1 = s.reps == null ? null : epley(s.loadMilli! / 1000, s.reps!);
      if (e1 != null && (best == null || e1 > best)) best = e1;
    }
    if (maxLoad == null) continue;
    points.add(
      ProgressPoint(
        day: e.startedAt,
        maxLoadMilli: maxLoad,
        bestE1rm: best,
        unit: unit,
      ),
    );
  }
  points.sort((a, b) => a.day.compareTo(b.day));
  return points;
}

/// Um recorde batido no treino (por estação: mesmo exercício e aparelho).
class PrRecord {
  const PrRecord({
    required this.exerciseName,
    required this.equipmentName,
    required this.kind,
    required this.value,
  });
  final String exerciseName;
  final String equipmentName;

  /// "Carga" ou "1RM estimado".
  final String kind;
  final String value;
}

/// Resumo de um treino: duração, séries, volume e recordes.
class SessionSummary {
  const SessionSummary({
    required this.duration,
    required this.completedSets,
    required this.volumeKg,
    required this.records,
  });
  final Duration? duration;
  final int completedSets;

  /// Soma de carga total × reps (sem aquecimento; aparelhos em "placa"
  /// ficam de fora porque o app não sabe quanto pesa a placa).
  final double volumeKg;
  final List<PrRecord> records;
}

/// Linha do histórico.
class HistoryEntry {
  const HistoryEntry({
    required this.session,
    required this.gymName,
    required this.exerciseCount,
    required this.setCount,
  });
  final WorkoutSession session;
  final String gymName;
  final int exerciseCount;
  final int setCount;
}

class WorkoutRepository {
  WorkoutRepository(this._db, this._stations);
  final AppDatabase _db;
  final StationRepository _stations;

  // ───────────────────────── Sessão ─────────────────────────

  /// O treino em andamento (no máximo um).
  Stream<WorkoutSession?> watchActiveSession() =>
      (_db.select(_db.workoutSessions)
            ..where((s) => s.endedAt.isNull())
            ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
            ..limit(1))
          .watchSingleOrNull();

  /// O treino em andamento agora (consulta única).
  Future<WorkoutSession?> openSession() =>
      (_db.select(_db.workoutSessions)
            ..where((s) => s.endedAt.isNull())
            ..limit(1))
          .getSingleOrNull();

  Stream<WorkoutSession?> watchSession(String id) => (_db.select(
    _db.workoutSessions,
  )..where((s) => s.id.equals(id))).watchSingleOrNull();

  /// Começa um treino livre (sem ficha). Se já existe um em andamento,
  /// devolve o existente em vez de abrir outro.
  Future<String> startFreeSession({required String gymId}) =>
      _db.transaction(() async {
        final active = await openSession();

        if (active != null) return active.id;
        final now = nowUtc();
        final session = await _db
            .into(_db.workoutSessions)
            .insertReturning(
              WorkoutSessionsCompanion.insert(
                gymId: gymId,
                title: 'Treino livre',
                startedAt: Value(now),
                localDate: localDateOf(now),
              ),
            );
        return session.id;
      });

  /// Começa o treino de uma ficha: cada exercício já vem com o aparelho
  /// (o preferido da ficha, ou o último usado nesta academia), os ajustes,
  /// os aquecimentos e as séries com a sugestão da dupla progressão.
  Future<String> startFromRoutine({
    required String routineId,
    required String gymId,
    required int defaultRestSec,
  }) => _db.transaction(() async {
    final active = await openSession();

    if (active != null) return active.id;
    final routine = await (_db.select(
      _db.routines,
    )..where((r) => r.id.equals(routineId))).getSingle();
    final items =
        await (_db.select(_db.routineExercises)
              ..where((e) => e.routineId.equals(routineId))
              ..orderBy([(e) => OrderingTerm.asc(e.position)]))
            .get();
    final now = nowUtc();
    final session = await _db
        .into(_db.workoutSessions)
        .insertReturning(
          WorkoutSessionsCompanion.insert(
            gymId: gymId,
            routineId: Value(routineId),
            title: routineTitle(routine),
            startedAt: Value(now),
            localDate: localDateOf(now),
          ),
        );
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final preferred = await _getEquipment(item.preferredEquipmentId);
      final equipmentId =
          (preferred != null &&
              preferred.gymId == gymId &&
              preferred.archivedAt == null)
          ? preferred.id
          : await _stations.lastEquipmentIdFor(
              exerciseId: item.exerciseId,
              gymId: gymId,
            );
      final station = await _stations.getOrCreate(
        exerciseId: item.exerciseId,
        gymId: gymId,
        equipmentId: equipmentId,
      );
      final equipment = await _getEquipment(equipmentId);
      final se = await _db
          .into(_db.sessionExercises)
          .insertReturning(
            SessionExercisesCompanion.insert(
              sessionId: session.id,
              stationId: station.id,
              exerciseId: item.exerciseId,
              routineExerciseId: Value(item.id),
              position: i + 1,
              loadUnit: equipment?.loadUnit ?? LoadUnit.kg,
              loadBasis: equipment?.loadBasis ?? LoadBasis.total,
              incrementMilli: equipment?.incrementMilli ?? 1000,
              targetSets: Value(item.targetSets),
              repMin: Value(item.repMin),
              repMax: Value(item.repMax),
              restSec:
                  item.restSec ??
                  _defaultRest(
                    await _trackingOf(item.exerciseId),
                    defaultRestSec,
                  ),
              supersetGroup: Value(item.supersetGroup),
            ),
          );
      await _planSets(
        se,
        stationId: station.id,
        minCount: item.targetSets,
        warmupSets: item.warmupSets,
      );
    }
    return session.id;
  });

  /// Finaliza: apaga séries não feitas e exercícios vazios, grava o fim.
  /// Num treino já finalizado não faz nada.
  Future<void> finishSession(String sessionId) => _db.transaction(() async {
    final session = await (_db.select(
      _db.workoutSessions,
    )..where((s) => s.id.equals(sessionId))).getSingleOrNull();
    if (session == null || session.endedAt != null) return;
    final seIds = _db.selectOnly(_db.sessionExercises)
      ..addColumns([_db.sessionExercises.id])
      ..where(_db.sessionExercises.sessionId.equals(sessionId));
    await (_db.delete(_db.workoutSets)..where(
          (s) => s.completedAt.isNull() & s.sessionExerciseId.isInQuery(seIds),
        ))
        .go();
    final withSets = _db.selectOnly(_db.workoutSets)
      ..addColumns([_db.workoutSets.sessionExerciseId]);
    await (_db.delete(_db.sessionExercises)..where(
          (e) => e.sessionId.equals(sessionId) & e.id.isNotInQuery(withSets),
        ))
        .go();
    await (_db.update(
      _db.workoutSessions,
    )..where((s) => s.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(
        endedAt: Value(nowUtc()),
        restEndsAt: const Value(null),
        updatedAt: Value(nowUtc()),
      ),
    );
  });

  /// Joga fora o treino inteiro (exercícios e séries vão junto).
  Future<void> discardSession(String sessionId) => (_db.delete(
    _db.workoutSessions,
  )..where((s) => s.id.equals(sessionId))).go();

  /// Quantas séries estão concluídas e quantas só planejadas.
  Future<({int done, int pending})> setCounts(String sessionId) async {
    final rows =
        await (_db.select(_db.workoutSets).join([
              innerJoin(
                _db.sessionExercises,
                _db.sessionExercises.id.equalsExp(
                  _db.workoutSets.sessionExerciseId,
                ),
              ),
            ])..where(_db.sessionExercises.sessionId.equals(sessionId)))
            .map((r) => r.readTable(_db.workoutSets))
            .get();
    final done = rows.where((s) => s.completedAt != null).length;
    return (done: done, pending: rows.length - done);
  }

  /// Descanso: grava o instante absoluto do fim (ou null para pular).
  Future<void> setRestEndsAt(String sessionId, DateTime? endsAt) =>
      (_db.update(
        _db.workoutSessions,
      )..where((s) => s.id.equals(sessionId))).write(
        WorkoutSessionsCompanion(
          restEndsAt: Value(endsAt?.toUtc()),
          updatedAt: Value(nowUtc()),
        ),
      );

  // ───────────────────────── Exercícios ─────────────────────────

  Stream<List<SessionExerciseView>> watchSessionExercises(String sessionId) {
    final q =
        _db.select(_db.sessionExercises).join([
            innerJoin(
              _db.exercises,
              _db.exercises.id.equalsExp(_db.sessionExercises.exerciseId),
            ),
            innerJoin(
              _db.stations,
              _db.stations.id.equalsExp(_db.sessionExercises.stationId),
            ),
            leftOuterJoin(
              _db.equipment,
              _db.equipment.id.equalsExp(_db.stations.equipmentId),
            ),
            leftOuterJoin(
              _db.routineExercises,
              _db.routineExercises.id.equalsExp(
                _db.sessionExercises.routineExerciseId,
              ),
            ),
          ])
          ..where(_db.sessionExercises.sessionId.equals(sessionId))
          ..orderBy([OrderingTerm.asc(_db.sessionExercises.position)]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          SessionExerciseView(
            item: r.readTable(_db.sessionExercises),
            exercise: r.readTable(_db.exercises),
            station: r.readTable(_db.stations),
            equipment: r.readTableOrNull(_db.equipment),
            routineItem: r.readTableOrNull(_db.routineExercises),
          ),
      ],
    );
  }

  /// Adiciona um exercício ao treino, na estação (exercício × aparelho)
  /// desta academia, e já cria as séries planejadas a partir do
  /// "Anterior" da MESMA estação (ou 3 séries vazias).
  Future<String> addExercise({
    required String sessionId,
    required String exerciseId,
    String? equipmentId,
    required int restSec,
  }) => _db.transaction(() async {
    final session = await _getSession(sessionId);
    final station = await _stations.getOrCreate(
      exerciseId: exerciseId,
      gymId: session.gymId,
      equipmentId: equipmentId,
    );
    final equipment = await _getEquipment(equipmentId);
    final tracking = await _trackingOf(exerciseId);

    final maxPos = _db.sessionExercises.position.max();
    final lastPos =
        await (_db.selectOnly(_db.sessionExercises)
              ..addColumns([maxPos])
              ..where(_db.sessionExercises.sessionId.equals(sessionId)))
            .map((r) => r.read(maxPos))
            .getSingle();

    final se = await _db
        .into(_db.sessionExercises)
        .insertReturning(
          SessionExercisesCompanion.insert(
            sessionId: sessionId,
            stationId: station.id,
            exerciseId: exerciseId,
            position: (lastPos ?? 0) + 1,
            loadUnit: equipment?.loadUnit ?? LoadUnit.kg,
            loadBasis: equipment?.loadBasis ?? LoadBasis.total,
            incrementMilli: equipment?.incrementMilli ?? 1000,
            restSec: _defaultRest(tracking, restSec),
          ),
        );
    // Cardio costuma ser um bloco só (20 min de esteira).
    await _planSets(
      se,
      stationId: station.id,
      minCount: tracking == TrackingType.cardio ? 1 : 3,
    );
    return se.id;
  });

  Future<void> removeExercise(String sessionExerciseId) =>
      _db.transaction(() async {
        final se = await (_db.select(
          _db.sessionExercises,
        )..where((e) => e.id.equals(sessionExerciseId))).getSingleOrNull();
        if (se == null) return;
        await (_db.delete(
          _db.sessionExercises,
        )..where((e) => e.id.equals(sessionExerciseId))).go();
        // O par de um bi-set que perdeu o outro volta a ser exercício solo.
        await _regroupSession(se.sessionId, (groups, _) {
          return normalizeSupersets(groups);
        });
      });

  // ───────────────────────── Bi-set ─────────────────────────

  /// Faz este exercício junto com o seguinte (bi-set; tri-set se o
  /// seguinte já estiver num bi-set).
  Future<void> linkSupersetWithNext(String sessionExerciseId) =>
      _regroupAround(sessionExerciseId, linkWithNext);

  /// Volta a fazer este exercício sozinho.
  Future<void> unlinkSuperset(String sessionExerciseId) =>
      _regroupAround(sessionExerciseId, unlinkAt);

  Future<void> _regroupAround(
    String sessionExerciseId,
    List<int?> Function(List<int?> groups, int index) change,
  ) => _db.transaction(() async {
    final se = await (_db.select(
      _db.sessionExercises,
    )..where((e) => e.id.equals(sessionExerciseId))).getSingleOrNull();
    if (se == null) return;
    await _regroupSession(
      se.sessionId,
      (groups, items) => change(groups, items.indexWhere((e) => e.id == se.id)),
    );
  });

  /// Reescreve os grupos de bi-set do treino (na ordem da tela).
  Future<void> _regroupSession(
    String sessionId,
    List<int?> Function(List<int?> groups, List<SessionExercise> items) change,
  ) async {
    final items =
        await (_db.select(_db.sessionExercises)
              ..where((e) => e.sessionId.equals(sessionId))
              ..orderBy([(e) => OrderingTerm.asc(e.position)]))
            .get();
    final next = change([for (final e in items) e.supersetGroup], items);
    for (var i = 0; i < items.length; i++) {
      if (items[i].supersetGroup == next[i]) continue;
      await (_db.update(
        _db.sessionExercises,
      )..where((e) => e.id.equals(items[i].id))).write(
        SessionExercisesCompanion(
          supersetGroup: Value(next[i]),
          updatedAt: Value(nowUtc()),
        ),
      );
    }
  }

  /// Aparelho ocupado: passa a usar outro aparelho. Devolve o id do
  /// exercício da sessão que fica ativo (pode ser um novo — ver [_swap]).
  Future<String> swapEquipment(String sessionExerciseId, String? equipmentId) =>
      _swap(sessionExerciseId, equipmentId: equipmentId);

  /// Troca o exercício (ex.: a máquina não existe nesta academia).
  Future<String> swapExercise(
    String sessionExerciseId, {
    required String exerciseId,
    String? equipmentId,
  }) => _swap(
    sessionExerciseId,
    exerciseId: exerciseId,
    equipmentId: equipmentId,
  );

  /// Troca a estação de um exercício da sessão.
  /// - Sem séries feitas: troca no lugar e refaz as planejadas a partir do
  ///   "Anterior" da NOVA estação.
  /// - Com séries feitas: elas FICAM na estação antiga (com a unidade
  ///   antiga — "20" numa máquina não é "20" na outra), e a nova estação
  ///   entra como um item novo logo abaixo, com as séries que faltavam.
  Future<String> _swap(
    String sessionExerciseId, {
    String? exerciseId,
    String? equipmentId,
  }) => _db.transaction(() async {
    final se = await (_db.select(
      _db.sessionExercises,
    )..where((e) => e.id.equals(sessionExerciseId))).getSingle();
    final session = await _getSession(se.sessionId);
    final targetExerciseId = exerciseId ?? se.exerciseId;
    final station = await _stations.getOrCreate(
      exerciseId: targetExerciseId,
      gymId: session.gymId,
      equipmentId: equipmentId,
    );
    if (station.id == se.stationId) return se.id;
    final equipment = await _getEquipment(equipmentId);

    final sets = await _setsOf(se.id);
    final doneCount = sets.where((s) => s.completedAt != null).length;
    final pendingCount = sets.length - doneCount;
    await (_db.delete(_db.workoutSets)..where(
          (s) => s.sessionExerciseId.equals(se.id) & s.completedAt.isNull(),
        ))
        .go();

    final copies = SessionExercisesCompanion(
      stationId: Value(station.id),
      exerciseId: Value(targetExerciseId),
      loadUnit: Value(equipment?.loadUnit ?? LoadUnit.kg),
      loadBasis: Value(equipment?.loadBasis ?? LoadBasis.total),
      incrementMilli: Value(equipment?.incrementMilli ?? 1000),
      updatedAt: Value(nowUtc()),
    );

    if (doneCount == 0) {
      await (_db.update(
        _db.sessionExercises,
      )..where((e) => e.id.equals(se.id))).write(copies);
      final updated = await (_db.select(
        _db.sessionExercises,
      )..where((e) => e.id.equals(se.id))).getSingle();
      await _planSets(updated, stationId: station.id, minCount: pendingCount);
      return se.id;
    }

    // Abre espaço logo abaixo do item antigo.
    await _db.customUpdate(
      'UPDATE session_exercises SET position = position + 1 '
      'WHERE session_id = ? AND position > ?',
      variables: [
        Variable.withString(se.sessionId),
        Variable.withInt(se.position),
      ],
      updates: {_db.sessionExercises},
    );
    final created = await _db
        .into(_db.sessionExercises)
        .insertReturning(
          SessionExercisesCompanion.insert(
            sessionId: se.sessionId,
            stationId: station.id,
            exerciseId: targetExerciseId,
            routineExerciseId: Value(se.routineExerciseId),
            position: se.position + 1,
            loadUnit: equipment?.loadUnit ?? LoadUnit.kg,
            loadBasis: equipment?.loadBasis ?? LoadBasis.total,
            incrementMilli: equipment?.incrementMilli ?? 1000,
            targetSets: Value(se.targetSets),
            repMin: Value(se.repMin),
            repMax: Value(se.repMax),
            restSec: se.restSec,
            supersetGroup: Value(se.supersetGroup),
          ),
        );
    await _planSets(
      created,
      stationId: station.id,
      minCount: pendingCount == 0 ? 1 : pendingCount,
    );
    return created.id;
  });
  Future<void> updateHowItWent(
    String sessionExerciseId, {
    String? text,
    EffortTag? tag,
    bool pain = false,
  }) =>
      (_db.update(
        _db.sessionExercises,
      )..where((e) => e.id.equals(sessionExerciseId))).write(
        SessionExercisesCompanion(
          howItWent: Value(
            (text == null || text.trim().isEmpty) ? null : text.trim(),
          ),
          effortTag: Value(tag),
          pain: Value(pain),
          updatedAt: Value(nowUtc()),
        ),
      );

  Future<void> updateRestSec(String sessionExerciseId, int restSec) =>
      (_db.update(
        _db.sessionExercises,
      )..where((e) => e.id.equals(sessionExerciseId))).write(
        SessionExercisesCompanion(
          restSec: Value(restSec),
          updatedAt: Value(nowUtc()),
        ),
      );

  // ───────────────────────── Séries ─────────────────────────

  Stream<List<WorkoutSet>> watchSets(String sessionExerciseId) =>
      (_db.select(_db.workoutSets)
            ..where((s) => s.sessionExerciseId.equals(sessionExerciseId))
            ..orderBy([(s) => OrderingTerm.asc(s.position)]))
          .watch();

  /// Todas as séries do treino, agrupadas por exercício da sessão (a tela
  /// precisa disso para saber qual é a próxima série).
  Stream<Map<String, List<WorkoutSet>>> watchSessionSets(String sessionId) {
    final q =
        _db.select(_db.workoutSets).join([
            innerJoin(
              _db.sessionExercises,
              _db.sessionExercises.id.equalsExp(
                _db.workoutSets.sessionExerciseId,
              ),
            ),
          ])
          ..where(_db.sessionExercises.sessionId.equals(sessionId))
          ..orderBy([OrderingTerm.asc(_db.workoutSets.position)]);
    return q.watch().map((rows) {
      final map = <String, List<WorkoutSet>>{};
      for (final r in rows) {
        final set = r.readTable(_db.workoutSets);
        (map[set.sessionExerciseId] ??= []).add(set);
      }
      return map;
    });
  }

  /// Últimas vezes nesta estação (para a tela da estação).
  Stream<List<StationHistoryEntry>> watchStationHistory(
    String stationId, {
    int limit = 10,
  }) {
    final q =
        _db.select(_db.sessionExercises).join([
            innerJoin(
              _db.workoutSessions,
              _db.workoutSessions.id.equalsExp(_db.sessionExercises.sessionId),
            ),
          ])
          ..where(
            _db.sessionExercises.stationId.equals(stationId) &
                _db.workoutSessions.endedAt.isNotNull(),
          )
          ..orderBy([OrderingTerm.desc(_db.workoutSessions.startedAt)])
          ..limit(limit);
    return q.watch().asyncMap((rows) async {
      final result = <StationHistoryEntry>[];
      for (final r in rows) {
        final se = r.readTable(_db.sessionExercises);
        final sets = (await _setsOf(se.id))
            .where((s) => s.completedAt != null)
            .toList();
        if (sets.isEmpty) continue;
        result.add(
          StationHistoryEntry(
            startedAt: r.readTable(_db.workoutSessions).startedAt,
            sessionId: se.sessionId,
            item: se,
            sets: sets,
          ),
        );
      }
      return result;
    });
  }

  /// Concluir em 1 toque: marca a hora e inicia o descanso, numa transação.
  /// Lê a série no banco (não o que a tela tinha), para nunca desfazer a
  /// última edição; ignora toque duplo. Retorna false se faltam as reps.
  Future<bool> completeSet(
    String setId, {
    required String sessionId,
    required int restSec,
  }) => _db.transaction(() async {
    final current = await (_db.select(
      _db.workoutSets,
    )..where((s) => s.id.equals(setId))).getSingleOrNull();
    if (current == null || current.completedAt != null) return true;
    // Carga × reps precisa das reps; prancha e cardio, do tempo.
    if (current.reps == null && current.durationSec == null) return false;
    final now = nowUtc();
    await (_db.update(
      _db.workoutSets,
    )..where((s) => s.id.equals(setId) & s.completedAt.isNull())).write(
      WorkoutSetsCompanion(completedAt: Value(now), updatedAt: Value(now)),
    );
    await setRestEndsAt(
      sessionId,
      restSec > 0 ? now.add(Duration(seconds: restSec)) : null,
    );
    // Como no caderno: a próxima série ainda vazia repete esta (carga e
    // reps). Nunca sobrescreve o que já estiver preenchido.
    final next =
        await (_db.select(_db.workoutSets)
              ..where(
                (s) =>
                    s.sessionExerciseId.equals(current.sessionExerciseId) &
                    s.position.isBiggerThanValue(current.position) &
                    s.completedAt.isNull() &
                    s.loadMilli.isNull() &
                    s.reps.isNull() &
                    s.durationSec.isNull() &
                    s.distanceM.isNull(),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.position)])
              ..limit(1))
            .getSingleOrNull();
    if (next != null && current.setType != SetType.warmup) {
      await (_db.update(
        _db.workoutSets,
      )..where((s) => s.id.equals(next.id))).write(
        WorkoutSetsCompanion(
          loadMilli: Value(current.loadMilli),
          reps: Value(current.reps),
          durationSec: Value(current.durationSec),
          distanceM: Value(current.distanceM),
          updatedAt: Value(now),
        ),
      );
    }
    return true;
  });
  Future<void> uncompleteSet(String setId) =>
      (_db.update(_db.workoutSets)..where((s) => s.id.equals(setId))).write(
        WorkoutSetsCompanion(
          completedAt: const Value(null),
          updatedAt: Value(nowUtc()),
        ),
      );

  Future<void> updateSet(
    String setId, {
    Value<int?> loadMilli = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<double?> rir = const Value.absent(),
    Value<SetType> setType = const Value.absent(),
    Value<int?> durationSec = const Value.absent(),
    Value<int?> distanceM = const Value.absent(),
  }) => (_db.update(_db.workoutSets)..where((s) => s.id.equals(setId))).write(
    WorkoutSetsCompanion(
      loadMilli: loadMilli,
      reps: reps,
      rir: rir,
      setType: setType,
      durationSec: durationSec,
      distanceM: distanceM,
      updatedAt: Value(nowUtc()),
    ),
  );

  /// Série extra: copia os valores da última.
  Future<void> addSet(String sessionExerciseId) => _db.transaction(() async {
    final sets = await _setsOf(sessionExerciseId);
    final last = sets.isEmpty ? null : sets.last;
    await _insertPlannedSet(
      sessionExerciseId,
      position: (last?.position ?? 0) + 1,
      from: last,
    );
  });

  /// Apaga e devolve a linha, para o "Desfazer" poder recolocá-la.
  Future<WorkoutSet?> deleteSet(String setId) => _db.transaction(() async {
    final row = await (_db.select(
      _db.workoutSets,
    )..where((s) => s.id.equals(setId))).getSingleOrNull();
    if (row != null) {
      await (_db.delete(
        _db.workoutSets,
      )..where((s) => s.id.equals(setId))).go();
    }
    return row;
  });

  Future<void> restoreSet(WorkoutSet row) =>
      _db.into(_db.workoutSets).insert(row, mode: InsertMode.insertOrReplace);

  // ───────────────────────── Anterior ─────────────────────────

  /// Última vez NESTA estação (mesmo exercício, mesmo aparelho, mesma
  /// academia), sem contar o treino [excludeSessionId].
  Future<PreviousPerformance?> previousForStation(
    String stationId, {
    required String excludeSessionId,
  }) async {
    final hasDoneSet = existsQuery(
      _db.select(_db.workoutSets)..where(
        (s) =>
            s.sessionExerciseId.equalsExp(_db.sessionExercises.id) &
            s.completedAt.isNotNull(),
      ),
    );
    final row =
        await (_db.select(_db.sessionExercises).join([
                innerJoin(
                  _db.workoutSessions,
                  _db.workoutSessions.id.equalsExp(
                    _db.sessionExercises.sessionId,
                  ),
                ),
              ])
              ..where(
                _db.sessionExercises.stationId.equals(stationId) &
                    _db.sessionExercises.sessionId
                        .equals(excludeSessionId)
                        .not() &
                    hasDoneSet,
              )
              ..orderBy([
                OrderingTerm.desc(_db.workoutSessions.startedAt),
                OrderingTerm.desc(_db.sessionExercises.position),
              ])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    final se = row.readTable(_db.sessionExercises);
    final sets = (await _setsOf(se.id))
        .where((s) => s.completedAt != null)
        .toList();
    return PreviousPerformance(
      startedAt: row.readTable(_db.workoutSessions).startedAt,
      sets: sets,
      unit: se.loadUnit,
      howItWent: se.howItWent,
      effortTag: se.effortTag,
      pain: se.pain,
    );
  }

  /// Só referência: o mesmo exercício nesta academia em OUTRO aparelho.
  Future<PreviousPerformance?> previousOnOtherEquipment({
    required String exerciseId,
    required String gymId,
    required String excludeStationId,
    required String excludeSessionId,
  }) async {
    final hasDoneSet = existsQuery(
      _db.select(_db.workoutSets)..where(
        (s) =>
            s.sessionExerciseId.equalsExp(_db.sessionExercises.id) &
            s.completedAt.isNotNull(),
      ),
    );
    final row =
        await (_db.select(_db.sessionExercises).join([
                innerJoin(
                  _db.workoutSessions,
                  _db.workoutSessions.id.equalsExp(
                    _db.sessionExercises.sessionId,
                  ),
                ),
                innerJoin(
                  _db.stations,
                  _db.stations.id.equalsExp(_db.sessionExercises.stationId),
                ),
                leftOuterJoin(
                  _db.equipment,
                  _db.equipment.id.equalsExp(_db.stations.equipmentId),
                ),
              ])
              ..where(
                _db.sessionExercises.exerciseId.equals(exerciseId) &
                    _db.workoutSessions.gymId.equals(gymId) &
                    _db.sessionExercises.stationId
                        .equals(excludeStationId)
                        .not() &
                    _db.sessionExercises.sessionId
                        .equals(excludeSessionId)
                        .not() &
                    hasDoneSet,
              )
              ..orderBy([OrderingTerm.desc(_db.workoutSessions.startedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    final se = row.readTable(_db.sessionExercises);
    final sets = (await _setsOf(se.id))
        .where((s) => s.completedAt != null)
        .toList();
    return PreviousPerformance(
      startedAt: row.readTable(_db.workoutSessions).startedAt,
      sets: sets,
      unit: se.loadUnit,
      otherEquipmentName:
          row.readTableOrNull(_db.equipment)?.name ?? 'sem aparelho',
    );
  }

  // ───────────────────────── Resumo e recordes ─────────────────────────

  Future<SessionSummary> sessionSummary(String sessionId) async {
    final session = await _getSession(sessionId);
    final views = await watchSessionExercises(sessionId).first;
    final setsMap = await watchSessionSets(sessionId).first;
    var completed = 0;
    var volume = 0.0;
    final records = <PrRecord>[];
    for (final v in views) {
      final work = [
        for (final s in setsMap[v.item.id] ?? const <WorkoutSet>[])
          if (s.completedAt != null &&
              s.setType != SetType.warmup &&
              s.reps != null &&
              s.reps! > 0)
            s,
      ];
      completed += (setsMap[v.item.id] ?? const <WorkoutSet>[])
          .where((s) => s.completedAt != null)
          .length;
      for (final s in work) {
        if (s.loadMilli == null) continue;
        final kg = totalKg(
          loadMilli: s.loadMilli!,
          unit: v.item.loadUnit,
          basis: v.item.loadBasis,
          baseLoadMilli: v.equipment?.baseLoadMilli,
        );
        if (kg != null) volume += kg * s.reps!;
      }
      final loaded = work.where((s) => s.loadMilli != null).toList();
      if (loaded.isEmpty) continue;
      final before = await _priorWorkingSets(
        stationId: v.station.id,
        unit: v.item.loadUnit,
        before: session.startedAt,
      );
      if (before.isEmpty) continue; // primeira vez não é recorde
      int maxLoad(Iterable<({int loadMilli, int reps})> xs) =>
          xs.map((x) => x.loadMilli).reduce((a, b) => a > b ? a : b);
      double maxE1rm(Iterable<({int loadMilli, int reps})> xs) => xs
          .map((x) => epley(x.loadMilli / 1000, x.reps) ?? 0)
          .fold(0.0, (a, b) => a > b ? a : b);
      final today = [
        for (final s in loaded) (loadMilli: s.loadMilli!, reps: s.reps!),
      ];
      final bestToday = today.reduce(
        (a, b) =>
            b.loadMilli > a.loadMilli ||
                (b.loadMilli == a.loadMilli && b.reps > a.reps)
            ? b
            : a,
      );
      if (bestToday.loadMilli > maxLoad(before)) {
        records.add(
          PrRecord(
            exerciseName: v.exercise.name,
            equipmentName: v.equipmentName,
            kind: 'Carga',
            value:
                '${formatLoad(bestToday.loadMilli, v.item.loadUnit)} × ${bestToday.reps}',
          ),
        );
        continue;
      }
      final e1 = maxE1rm(today);
      if (e1 > maxE1rm(before) + 0.01 && v.item.loadUnit != LoadUnit.plate) {
        records.add(
          PrRecord(
            exerciseName: v.exercise.name,
            equipmentName: v.equipmentName,
            kind: '1RM estimado',
            value:
                '${formatNumber(double.parse(e1.toStringAsFixed(1)))} ${v.item.loadUnit.label}',
          ),
        );
      }
    }
    return SessionSummary(
      duration: session.endedAt?.difference(session.startedAt),
      completedSets: completed,
      volumeKg: volume,
      records: records,
    );
  }

  /// Logo depois de concluir: esta série bateu um recorde da estação?
  /// Conta os treinos anteriores e as séries de hoje que vieram antes, para
  /// não comemorar duas vezes a mesma marca.
  Future<({RecordKind kind, String value})?> liveRecord(String setId) async {
    final row = await (_db.select(_db.workoutSets).join([
      innerJoin(
        _db.sessionExercises,
        _db.sessionExercises.id.equalsExp(_db.workoutSets.sessionExerciseId),
      ),
      innerJoin(
        _db.workoutSessions,
        _db.workoutSessions.id.equalsExp(_db.sessionExercises.sessionId),
      ),
    ])..where(_db.workoutSets.id.equals(setId))).getSingleOrNull();
    if (row == null) return null;
    final set = row.readTable(_db.workoutSets);
    final se = row.readTable(_db.sessionExercises);
    if (set.completedAt == null ||
        set.setType == SetType.warmup ||
        set.loadMilli == null ||
        (set.reps ?? 0) <= 0) {
      return null;
    }
    final history = await _priorWorkingSets(
      stationId: se.stationId,
      unit: se.loadUnit,
      before: row.readTable(_db.workoutSessions).startedAt,
    );
    // Hoje, na mesma estação, antes desta série.
    final today =
        await (_db.select(_db.workoutSets).join([
              innerJoin(
                _db.sessionExercises,
                _db.sessionExercises.id.equalsExp(
                  _db.workoutSets.sessionExerciseId,
                ),
              ),
            ])..where(
              _db.sessionExercises.sessionId.equals(se.sessionId) &
                  _db.sessionExercises.stationId.equals(se.stationId) &
                  _db.sessionExercises.loadUnit.equalsValue(se.loadUnit) &
                  _db.workoutSets.id.equals(setId).not() &
                  _db.workoutSets.completedAt.isSmallerOrEqualValue(
                    set.completedAt!,
                  ) &
                  _db.workoutSets.setType.equalsValue(SetType.warmup).not() &
                  _db.workoutSets.loadMilli.isNotNull() &
                  _db.workoutSets.reps.isBiggerThanValue(0),
            ))
            .map((r) => r.readTable(_db.workoutSets))
            .get();
    final kind = recordOf(
      history: [
        ...history,
        for (final s in today) (loadMilli: s.loadMilli!, reps: s.reps!),
      ],
      set: (loadMilli: set.loadMilli!, reps: set.reps!),
      allowE1rm: se.loadUnit != LoadUnit.plate,
    );
    if (kind == null) return null;
    return (
      kind: kind,
      value: '${formatLoad(set.loadMilli, se.loadUnit)} × ${set.reps}',
    );
  }

  /// Séries de trabalho concluídas na estação, em treinos finalizados antes
  /// de [before], na mesma unidade.
  Future<List<({int loadMilli, int reps})>> _priorWorkingSets({
    required String stationId,
    required LoadUnit unit,
    required DateTime before,
  }) async {
    final rows =
        await (_db.select(_db.workoutSets).join([
              innerJoin(
                _db.sessionExercises,
                _db.sessionExercises.id.equalsExp(
                  _db.workoutSets.sessionExerciseId,
                ),
              ),
              innerJoin(
                _db.workoutSessions,
                _db.workoutSessions.id.equalsExp(
                  _db.sessionExercises.sessionId,
                ),
              ),
            ])..where(
              _db.sessionExercises.stationId.equals(stationId) &
                  _db.sessionExercises.loadUnit.equalsValue(unit) &
                  _db.workoutSessions.endedAt.isNotNull() &
                  _db.workoutSessions.startedAt.isSmallerThanValue(before) &
                  _db.workoutSets.completedAt.isNotNull() &
                  _db.workoutSets.setType.equalsValue(SetType.warmup).not() &
                  _db.workoutSets.loadMilli.isNotNull() &
                  _db.workoutSets.reps.isBiggerThanValue(0),
            ))
            .map((r) => r.readTable(_db.workoutSets))
            .get();
    return [for (final s in rows) (loadMilli: s.loadMilli!, reps: s.reps!)];
  }

  // ───────────────────────── Histórico ─────────────────────────

  Stream<List<HistoryEntry>> watchHistory() {
    final exerciseCount = _db.sessionExercises.id.count(distinct: true);
    final setCount = _db.workoutSets.id.count(distinct: true);
    final q =
        _db.select(_db.workoutSessions).join([
            innerJoin(
              _db.gyms,
              _db.gyms.id.equalsExp(_db.workoutSessions.gymId),
            ),
            leftOuterJoin(
              _db.sessionExercises,
              _db.sessionExercises.sessionId.equalsExp(_db.workoutSessions.id),
            ),
            leftOuterJoin(
              _db.workoutSets,
              _db.workoutSets.sessionExerciseId.equalsExp(
                    _db.sessionExercises.id,
                  ) &
                  _db.workoutSets.completedAt.isNotNull(),
            ),
          ])
          ..addColumns([exerciseCount, setCount])
          ..where(_db.workoutSessions.endedAt.isNotNull())
          ..groupBy([_db.workoutSessions.id])
          ..orderBy([OrderingTerm.desc(_db.workoutSessions.startedAt)])
          ..limit(500);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          HistoryEntry(
            session: r.readTable(_db.workoutSessions),
            gymName: r.readTable(_db.gyms).name,
            exerciseCount: r.read(exerciseCount) ?? 0,
            setCount: r.read(setCount) ?? 0,
          ),
      ],
    );
  }

  /// Músculos de cada série de trabalho concluída desde [since] (para o
  /// volume semanal por músculo).
  Stream<List<({String primary, String secondary})>> watchWorkingSetMuscles(
    DateTime since,
  ) {
    final q =
        _db.select(_db.workoutSets).join([
          innerJoin(
            _db.sessionExercises,
            _db.sessionExercises.id.equalsExp(
              _db.workoutSets.sessionExerciseId,
            ),
          ),
          innerJoin(
            _db.exercises,
            _db.exercises.id.equalsExp(_db.sessionExercises.exerciseId),
          ),
        ])..where(
          _db.workoutSets.completedAt.isBiggerOrEqualValue(since) &
              _db.workoutSets.setType.equalsValue(SetType.warmup).not() &
              _db.exercises.tracking.equalsValue(TrackingType.weightReps),
        );
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          (
            primary: r.readTable(_db.exercises).primaryMuscles,
            secondary: r.readTable(_db.exercises).secondaryMuscles,
          ),
      ],
    );
  }

  // ───────────────────────── Internos ─────────────────────────

  Future<WorkoutSession> _getSession(String id) => (_db.select(
    _db.workoutSessions,
  )..where((s) => s.id.equals(id))).getSingle();

  Future<List<WorkoutSet>> _setsOf(String sessionExerciseId) =>
      (_db.select(_db.workoutSets)
            ..where((s) => s.sessionExerciseId.equals(sessionExerciseId))
            ..orderBy([(s) => OrderingTerm.asc(s.position)]))
          .get();

  Future<TrackingType> _trackingOf(String exerciseId) async =>
      (await (_db.select(
        _db.exercises,
      )..where((e) => e.id.equals(exerciseId))).getSingleOrNull())?.tracking ??
      TrackingType.weightReps;

  /// Cardio não tem descanso entre "séries" (é um bloco contínuo).
  int _defaultRest(TrackingType tracking, int rest) =>
      tracking == TrackingType.cardio ? 0 : rest;

  Future<EquipmentItem?> _getEquipment(String? id) async => id == null
      ? null
      : (_db.select(_db.equipment)..where((e) => e.id.equals(id))).getSingle();

  /// Cria as séries planejadas de [se] a partir do "Anterior" da estação.
  /// - Sem ficha: espelha a última vez.
  /// - Com ficha (alvo de séries e faixa de reps): [warmupSets] aquecimentos
  ///   e as séries de trabalho com a sugestão da dupla progressão.
  /// A carga só é copiada se a unidade for a mesma (kg ≠ lb ≠ placa).
  Future<void> _planSets(
    SessionExercise se, {
    required String stationId,
    required int minCount,
    int warmupSets = 0,
  }) async {
    final previous = await previousForStation(
      stationId,
      excludeSessionId: se.sessionId,
    );
    final prevAll = previous?.sets ?? const <WorkoutSet>[];
    final sameUnit = previous?.unit == se.loadUnit;
    final existing = await _setsOf(se.id);
    var pos = existing.isEmpty ? 1 : existing.last.position + 1;

    final targets = se.targetSets;
    final tracking = await _trackingOf(se.exerciseId);
    // Sem ficha, ou exercício por tempo/cardio (a dupla progressão é de
    // carga × reps): espelha a última vez.
    if (targets == null || tracking != TrackingType.weightReps) {
      final count =
          targets ??
          (prevAll.isNotEmpty ? prevAll.length : (minCount < 1 ? 3 : minCount));
      for (var i = 0; i < count; i++) {
        await _insertPlannedSet(
          se.id,
          position: pos++,
          from: i < prevAll.length ? prevAll[i] : null,
          copyLoad: sameUnit,
        );
      }
      return;
    }

    final working = planWorkingSets(
      previousWorking: [
        for (final s in prevAll)
          if (s.setType != SetType.warmup)
            (loadMilli: s.loadMilli, reps: s.reps),
      ],
      sameUnit: sameUnit,
      targetSets: targets,
      repMin: se.repMin,
      repMax: se.repMax,
      incrementMilli: se.incrementMilli,
    );
    // Aquecimento: rampa até a carga de trabalho planejada; sem carga
    // planejada, repete o aquecimento da última vez.
    final prevWarm = prevAll.where((s) => s.setType == SetType.warmup).toList();
    final workLoad = working.firstOrNull?.loadMilli;
    final ramp = workLoad == null
        ? const <SetTarget>[]
        : warmupRamp(
            workLoadMilli: workLoad,
            count: warmupSets,
            incrementMilli: se.incrementMilli,
          );
    for (var i = 0; i < warmupSets; i++) {
      final from = i < prevWarm.length ? prevWarm[i] : null;
      await _insertSet(
        se.id,
        position: pos++,
        setType: SetType.warmup,
        loadMilli: i < ramp.length
            ? ramp[i].loadMilli
            : (sameUnit ? from?.loadMilli : null),
        reps: i < ramp.length ? ramp[i].reps : from?.reps,
      );
    }
    for (final t in working) {
      await _insertSet(
        se.id,
        position: pos++,
        setType: SetType.working,
        loadMilli: t.loadMilli,
        reps: t.reps,
      );
    }
  }

  Future<void> _insertSet(
    String sessionExerciseId, {
    required int position,
    required SetType setType,
    int? loadMilli,
    int? reps,
  }) => _db
      .into(_db.workoutSets)
      .insert(
        WorkoutSetsCompanion.insert(
          sessionExerciseId: sessionExerciseId,
          position: position,
          setType: setType,
          loadMilli: Value(loadMilli),
          reps: Value(reps),
        ),
      );
  Future<void> _insertPlannedSet(
    String sessionExerciseId, {
    required int position,
    WorkoutSet? from,
    bool copyLoad = true,
  }) => _db
      .into(_db.workoutSets)
      .insert(
        WorkoutSetsCompanion.insert(
          sessionExerciseId: sessionExerciseId,
          position: position,
          setType: from?.setType ?? SetType.working,
          loadMilli: Value(copyLoad ? from?.loadMilli : null),
          reps: Value(from?.reps),
          durationSec: Value(from?.durationSec),
          distanceM: Value(from?.distanceM),
        ),
      );
}

@Riverpod(keepAlive: true)
WorkoutRepository workoutRepository(Ref ref) => WorkoutRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(stationRepositoryProvider),
);

@riverpod
Stream<WorkoutSession?> activeSession(Ref ref) =>
    ref.watch(workoutRepositoryProvider).watchActiveSession();

@riverpod
Stream<WorkoutSession?> session(Ref ref, String id) =>
    ref.watch(workoutRepositoryProvider).watchSession(id);

@riverpod
Stream<List<SessionExerciseView>> sessionExercises(Ref ref, String sessionId) =>
    ref.watch(workoutRepositoryProvider).watchSessionExercises(sessionId);

@riverpod
Stream<List<WorkoutSet>> exerciseSets(Ref ref, String sessionExerciseId) =>
    ref.watch(workoutRepositoryProvider).watchSets(sessionExerciseId);

/// "Anterior" da estação, sem contar o treino atual. Não muda durante o
/// treino, por isso é um Future.
@riverpod
Future<PreviousPerformance?> previousPerformance(
  Ref ref, {
  required String stationId,
  required String sessionId,
  required String exerciseId,
  required String gymId,
}) async {
  final repo = ref.watch(workoutRepositoryProvider);
  return await repo.previousForStation(
        stationId,
        excludeSessionId: sessionId,
      ) ??
      await repo.previousOnOtherEquipment(
        exerciseId: exerciseId,
        gymId: gymId,
        excludeStationId: stationId,
        excludeSessionId: sessionId,
      );
}

@riverpod
Future<SessionSummary> sessionSummary(Ref ref, String sessionId) {
  // Recalcula se as séries mudarem.
  ref.watch(sessionSetsProvider(sessionId));
  return ref.read(workoutRepositoryProvider).sessionSummary(sessionId);
}

@riverpod
Stream<List<HistoryEntry>> history(Ref ref) =>
    ref.watch(workoutRepositoryProvider).watchHistory();

@riverpod
Stream<Map<String, List<WorkoutSet>>> sessionSets(Ref ref, String sessionId) =>
    ref.watch(workoutRepositoryProvider).watchSessionSets(sessionId);

@riverpod
Stream<List<StationHistoryEntry>> stationHistory(Ref ref, String stationId) =>
    ref.watch(workoutRepositoryProvider).watchStationHistory(stationId);

/// Até 40 treinos na estação, prontos para o gráfico.
@riverpod
Stream<List<ProgressPoint>> stationProgress(Ref ref, String stationId) => ref
    .watch(workoutRepositoryProvider)
    .watchStationHistory(stationId, limit: 40)
    .map(progressPointsOf);

/// Séries por músculo nos últimos 7 dias (1 no primário, 0,5 no
/// secundário). O "agora" é fixado ao abrir a tela.
@riverpod
Stream<Map<String, double>> weeklyMuscleVolume(Ref ref) => ref
    .watch(workoutRepositoryProvider)
    .watchWorkingSetMuscles(nowUtc().subtract(const Duration(days: 7)))
    .map(weeklyMuscleSets);
