import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';

part 'prefs_repository.g.dart';

/// Chaves das preferências guardadas em `app_prefs`.
abstract final class PrefKeys {
  static const currentGymId = 'current_gym_id';
  static const defaultRestSec = 'default_rest_sec';
  static const keepScreenOn = 'keep_screen_on';
  static const lastBackupAt = 'last_backup_at';
  static const seedExercisesVersion = 'seed.exercises.version';

  /// Id do usuário logado (sem a chave = ninguém logado).
  static const sessionUserId = 'auth.session_user_id';
}

const defaultRestSecFallback = 90;

class PrefsRepository {
  PrefsRepository(this._db);
  final AppDatabase _db;

  Future<String?> get(String key) async {
    final row = await (_db.select(
      _db.appPrefs,
    )..where((p) => p.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Stream<String?> watch(String key) =>
      (_db.select(_db.appPrefs)..where((p) => p.key.equals(key)))
          .watchSingleOrNull()
          .map((row) => row?.value);

  /// Descanso padrão em segundos (leitura única, para ações).
  Future<int> defaultRestSec() async =>
      int.tryParse(await get(PrefKeys.defaultRestSec) ?? '') ??
      defaultRestSecFallback;

  /// `null` apaga a preferência.
  Future<void> set(String key, String? value) async {
    if (value == null) {
      await (_db.delete(_db.appPrefs)..where((p) => p.key.equals(key))).go();
    } else {
      await _db
          .into(_db.appPrefs)
          .insertOnConflictUpdate(
            AppPrefsCompanion.insert(key: key, value: value),
          );
    }
  }
}

@Riverpod(keepAlive: true)
PrefsRepository prefsRepository(Ref ref) =>
    PrefsRepository(ref.watch(appDatabaseProvider));

/// Descanso padrão em segundos (90 se nunca foi definido).
@riverpod
Stream<int> defaultRestSec(Ref ref) => ref
    .watch(prefsRepositoryProvider)
    .watch(PrefKeys.defaultRestSec)
    .map((v) => int.tryParse(v ?? '') ?? defaultRestSecFallback);

/// Manter a tela ligada durante o treino (padrão: sim).
@riverpod
Stream<bool> keepScreenOn(Ref ref) => ref
    .watch(prefsRepositoryProvider)
    .watch(PrefKeys.keepScreenOn)
    .map((v) => v != 'false');

/// Quando foi o último backup exportado (null = nunca).
@riverpod
Stream<DateTime?> lastBackupAt(Ref ref) => ref
    .watch(prefsRepositoryProvider)
    .watch(PrefKeys.lastBackupAt)
    .map((v) => v == null ? null : DateTime.tryParse(v));
