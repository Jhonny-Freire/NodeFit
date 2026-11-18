import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/enums.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/utils/text_normalize.dart';

part 'catalog_repository.g.dart';

/// Exercício feito recentemente na academia, com o aparelho da última vez.
class RecentExercise {
  const RecentExercise({
    required this.exercise,
    required this.lastAt,
    this.equipment,
  });
  final Exercise exercise;
  final DateTime lastAt;
  final EquipmentItem? equipment;
}

class CatalogRepository {
  CatalogRepository(this._db);
  final AppDatabase _db;

  /// Os exercícios feitos por último nesta academia (mais recente primeiro).
  Stream<List<RecentExercise>> watchRecentAt(String gymId, {int limit = 8}) {
    final q =
        _db.select(_db.sessionExercises).join([
            innerJoin(
              _db.workoutSessions,
              _db.workoutSessions.id.equalsExp(_db.sessionExercises.sessionId),
            ),
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
          ])
          ..where(
            _db.workoutSessions.gymId.equals(gymId) &
                _db.exercises.archivedAt.isNull(),
          )
          ..orderBy([OrderingTerm.desc(_db.sessionExercises.createdAt)])
          ..limit(200);
    return q.watch().map((rows) {
      final seen = <String>{};
      final result = <RecentExercise>[];
      for (final r in rows) {
        final ex = r.readTable(_db.exercises);
        if (!seen.add(ex.id)) continue;
        final eq = r.readTableOrNull(_db.equipment);
        result.add(
          RecentExercise(
            exercise: ex,
            lastAt: r.readTable(_db.sessionExercises).createdAt,
            equipment: (eq == null || eq.archivedAt != null) ? null : eq,
          ),
        );
        if (result.length >= limit) break;
      }
      return result;
    });
  }

  /// Ids dos exercícios que você já fez nesta academia.
  Stream<Set<String>> watchDoneIdsAt(String gymId) {
    final q =
        _db.selectOnly(_db.sessionExercises, distinct: true).join([
            innerJoin(
              _db.workoutSessions,
              _db.workoutSessions.id.equalsExp(_db.sessionExercises.sessionId),
              useColumns: false,
            ),
          ])
          ..addColumns([_db.sessionExercises.exerciseId])
          ..where(_db.workoutSessions.gymId.equals(gymId));
    return q.watch().map(
      (rows) => {
        for (final r in rows) r.read(_db.sessionExercises.exerciseId)!,
      },
    );
  }

  /// Exercícios ativos. A busca ignora acento e maiúsculas e exige que
  /// todas as palavras digitadas apareçam no nome ou nos apelidos.
  Stream<List<Exercise>> watchExercises({String query = ''}) {
    final tokens = normalizeForSearch(query)
        .split(' ')
        .where((t) => t.isNotEmpty)
        .toList();
    final q = _db.select(_db.exercises)
      ..where((e) {
        Expression<bool> cond = e.archivedAt.isNull();
        for (final t in tokens) {
          cond = cond & e.searchText.like('%$t%');
        }
        return cond;
      })
      ..orderBy([(e) => OrderingTerm.asc(e.name)])
      ..limit(300);
    return q.watch();
  }

  Future<Exercise?> getExercise(String id) => (_db.select(
    _db.exercises,
  )..where((e) => e.id.equals(id))).getSingleOrNull();

  Stream<Exercise?> watchExercise(String id) => (_db.select(
    _db.exercises,
  )..where((e) => e.id.equals(id))).watchSingleOrNull();

  /// Cria um exercício seu (o texto da busca vira o nome).
  Future<Exercise> createExercise({
    required String name,
    required EquipmentType equipmentType,
    TrackingType tracking = TrackingType.weightReps,
  }) {
    final clean = name.trim();
    return _db
        .into(_db.exercises)
        .insertReturning(
          ExercisesCompanion.insert(
            name: clean,
            searchText: normalizeForSearch(clean),
            equipmentType: equipmentType,
            tracking: Value(tracking),
            isCustom: const Value(true),
          ),
        );
  }
}

/// Carrega o catálogo embarcado (assets/seed/exercicios_pt_br.json).
/// Roda a cada abertura do app, mas só grava quando a versão do arquivo
/// for maior que a já aplicada. Nunca toca nos exercícios criados por você.
class CatalogSeeder {
  CatalogSeeder(this._db, this._prefs);
  final AppDatabase _db;
  final PrefsRepository _prefs;

  Future<int> run(String jsonText) async {
    final data = jsonDecode(jsonText) as Map<String, dynamic>;
    final version = data['version'] as int;
    final applied = int.tryParse(
      await _prefs.get(PrefKeys.seedExercisesVersion) ?? '',
    );
    if (applied != null && applied >= version) return 0;

    final items = (data['exercises'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    await _db.transaction(() async {
      for (final raw in items) {
        final name = raw['name'] as String;
        final aliases = (raw['aliases'] as List<dynamic>).cast<String>();
        await _db
            .into(_db.exercises)
            .insertOnConflictUpdate(
              ExercisesCompanion.insert(
                id: Value(raw['id'] as String),
                name: name,
                searchText: normalizeForSearch([name, ...aliases].join(' ')),
                aliases: Value(aliases.join(' | ')),
                equipmentType: EquipmentType.values.byName(
                  raw['equipment'] as String,
                ),
                primaryMuscles: Value(
                  (raw['primary'] as List<dynamic>).cast<String>().join(','),
                ),
                secondaryMuscles: Value(
                  (raw['secondary'] as List<dynamic>).cast<String>().join(','),
                ),
                tracking: Value(
                  TrackingType.values.byName(
                    raw['tracking'] as String? ?? TrackingType.weightReps.name,
                  ),
                ),
                seedVersion: Value(version),
              ),
            );
      }
      await _prefs.set(PrefKeys.seedExercisesVersion, '$version');
    });
    return items.length;
  }
}

@Riverpod(keepAlive: true)
CatalogRepository catalogRepository(Ref ref) =>
    CatalogRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<Exercise>> exerciseSearch(Ref ref, String query) =>
    ref.watch(catalogRepositoryProvider).watchExercises(query: query);

@riverpod
Stream<List<RecentExercise>> recentExercises(Ref ref, String gymId) =>
    ref.watch(catalogRepositoryProvider).watchRecentAt(gymId);

@riverpod
Stream<Set<String>> doneExerciseIds(Ref ref, String gymId) =>
    ref.watch(catalogRepositoryProvider).watchDoneIdsAt(gymId);

@riverpod
Stream<Exercise?> exercise(Ref ref, String id) =>
    ref.watch(catalogRepositoryProvider).watchExercise(id);
