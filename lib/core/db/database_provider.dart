import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';

part 'database_provider.g.dart';

/// O banco é a fonte da verdade. Nos testes, sobrescreva com
/// `appDatabaseProvider.overrideWithValue(AppDatabase(NativeDatabase.memory()))`.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
