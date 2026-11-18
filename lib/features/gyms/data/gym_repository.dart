import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/enums.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/utils/ids.dart';

part 'gym_repository.g.dart';

/// Academias e aparelhos.
class GymRepository {
  GymRepository(this._db);
  final AppDatabase _db;

  Stream<List<Gym>> watchGyms() =>
      (_db.select(_db.gyms)
            ..where((g) => g.archivedAt.isNull())
            ..orderBy([(g) => OrderingTerm.asc(g.name)]))
          .watch();

  Future<Gym> createGym(String name) => _db
      .into(_db.gyms)
      .insertReturning(GymsCompanion.insert(name: name.trim()));

  Future<void> renameGym(String id, String name) =>
      (_db.update(_db.gyms)..where((g) => g.id.equals(id))).write(
        GymsCompanion(name: Value(name.trim()), updatedAt: Value(nowUtc())),
      );

  Stream<List<EquipmentItem>> watchEquipment(String gymId) =>
      (_db.select(_db.equipment)
            ..where((e) => e.gymId.equals(gymId) & e.archivedAt.isNull())
            ..orderBy([(e) => OrderingTerm.asc(e.name)]))
          .watch();

  Stream<EquipmentItem?> watchEquipmentItem(String id) => (_db.select(
    _db.equipment,
  )..where((e) => e.id.equals(id))).watchSingleOrNull();

  Future<EquipmentItem?> getEquipment(String id) => (_db.select(
    _db.equipment,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<EquipmentItem> createEquipment({
    required String gymId,
    required String name,
    required EquipmentType type,
    required LoadUnit loadUnit,
    required LoadBasis loadBasis,
    required int incrementMilli,
    int? baseLoadMilli,
    String? gymLabel,
    String? replacesEquipmentId,
  }) => _db
      .into(_db.equipment)
      .insertReturning(
        EquipmentCompanion.insert(
          gymId: gymId,
          name: name.trim(),
          type: type,
          loadUnit: loadUnit,
          loadBasis: loadBasis,
          incrementMilli: Value(incrementMilli),
          baseLoadMilli: Value(baseLoadMilli),
          gymLabel: Value(_blankToNull(gymLabel)),
          replacesEquipmentId: Value(replacesEquipmentId),
        ),
      );

  Future<void> updateEquipment(
    String id, {
    required String name,
    required EquipmentType type,
    required LoadUnit loadUnit,
    required LoadBasis loadBasis,
    required int incrementMilli,
    int? baseLoadMilli,
    String? gymLabel,
  }) => _db.transaction(() async {
    await (_db.update(_db.equipment)..where((e) => e.id.equals(id))).write(
      EquipmentCompanion(
        name: Value(name.trim()),
        type: Value(type),
        loadUnit: Value(loadUnit),
        loadBasis: Value(loadBasis),
        incrementMilli: Value(incrementMilli),
        baseLoadMilli: Value(baseLoadMilli),
        gymLabel: Value(_blankToNull(gymLabel)),
        updatedAt: Value(nowUtc()),
      ),
    );
    // Corrigiu o passo/unidade com o treino aberto? Vale já no treino em
    // andamento. Treinos finalizados mantêm a cópia do dia.
    final stationsOfEquipment = _db.selectOnly(_db.stations)
      ..addColumns([_db.stations.id])
      ..where(_db.stations.equipmentId.equals(id));
    final activeSessions = _db.selectOnly(_db.workoutSessions)
      ..addColumns([_db.workoutSessions.id])
      ..where(_db.workoutSessions.endedAt.isNull());
    await (_db.update(_db.sessionExercises)..where(
          (se) =>
              se.stationId.isInQuery(stationsOfEquipment) &
              se.sessionId.isInQuery(activeSessions),
        ))
        .write(
          SessionExercisesCompanion(
            loadUnit: Value(loadUnit),
            loadBasis: Value(loadBasis),
            incrementMilli: Value(incrementMilli),
            updatedAt: Value(nowUtc()),
          ),
        );
  });

  /// Some das listas, mas o histórico continua.
  Future<void> archiveEquipment(String id) =>
      (_db.update(_db.equipment)..where((e) => e.id.equals(id))).write(
        EquipmentCompanion(
          archivedAt: Value(nowUtc()),
          updatedAt: Value(nowUtc()),
        ),
      );

  /// "A academia trocou a máquina": arquiva a antiga (com histórico) e cria
  /// a nova, que começa limpa — "20" na nova pode não ser "20" na velha.
  Future<EquipmentItem> replaceEquipment(EquipmentItem old) =>
      _db.transaction(() async {
        await archiveEquipment(old.id);
        return createEquipment(
          gymId: old.gymId,
          name: old.name,
          type: old.type,
          loadUnit: old.loadUnit,
          loadBasis: old.loadBasis,
          incrementMilli: old.incrementMilli,
          baseLoadMilli: old.baseLoadMilli,
          gymLabel: old.gymLabel,
          replacesEquipmentId: old.id,
        );
      });
}

String? _blankToNull(String? s) =>
    (s == null || s.trim().isEmpty) ? null : s.trim();

@Riverpod(keepAlive: true)
GymRepository gymRepository(Ref ref) =>
    GymRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<Gym>> gyms(Ref ref) => ref.watch(gymRepositoryProvider).watchGyms();

/// Academia atual: a escolhida nas preferências ou, se não houver, a
/// primeira da lista. Null quando ainda não existe nenhuma academia.
@riverpod
Stream<Gym?> currentGym(Ref ref) async* {
  final prefs = ref.watch(prefsRepositoryProvider);
  final gymsList = await ref.watch(gymsProvider.future);
  await for (final chosenId in prefs.watch(PrefKeys.currentGymId)) {
    yield gymsList.where((g) => g.id == chosenId).firstOrNull ??
        gymsList.firstOrNull;
  }
}

@riverpod
Stream<List<EquipmentItem>> gymEquipment(Ref ref, String gymId) =>
    ref.watch(gymRepositoryProvider).watchEquipment(gymId);

@riverpod
Stream<EquipmentItem?> equipmentItem(Ref ref, String id) =>
    ref.watch(gymRepositoryProvider).watchEquipmentItem(id);
