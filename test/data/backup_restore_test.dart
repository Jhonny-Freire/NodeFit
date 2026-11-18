import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/prefs/prefs_repository.dart';
import 'package:nodefit/features/backup/backup_service.dart';
import 'package:nodefit/features/backup/restore_service.dart';
import 'package:nodefit/features/gyms/data/gym_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends PathProviderPlatform with MockPlatformInterfaceMixin {
  _FakePaths(this.root);
  final String root;

  @override
  Future<String?> getTemporaryPath() async => p.join(root, 'tmp');

  @override
  Future<String?> getApplicationSupportPath() async => p.join(root, 'support');
}

void main() {
  late Directory root;
  late File dbFile;

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  setUp(() async {
    root = await Directory.systemTemp.createTemp('nodefit_restore_');
    for (final d in ['tmp', 'support']) {
      Directory(p.join(root.path, d)).createSync();
    }
    PathProviderPlatform.instance = _FakePaths(root.path);
    dbFile = File(
      p.join(root.path, 'support', '${AppDatabase.fileName}.sqlite'),
    );
  });

  tearDown(() => root.delete(recursive: true));

  test(
    'backup → mexer nos dados → restaurar volta ao estado do backup',
    () async {
      var db = AppDatabase(NativeDatabase(dbFile));
      await GymRepository(db).createGym('Academia do bairro');
      final zip = await BackupService(
        db,
        PrefsRepository(db),
      ).createBackupZip();
      expect(zip.existsSync(), isTrue);

      await GymRepository(db).createGym('Academia nova (depois do backup)');

      final service = RestoreService();
      final preview = await service.inspect(
        zip.path,
        appSchema: db.schemaVersion,
      );
      expect(preview.sessions, 0);
      await service.apply(preview, db);
      await db.close(); // fechar de novo não pode quebrar

      db = AppDatabase(NativeDatabase(dbFile));
      final names = (await db.select(db.gyms).get()).map((g) => g.name);
      expect(names, ['Academia do bairro']);
      await db.close();

      final safety = Directory(p.join(root.path, 'support', 'backups'))
          .listSync();
      expect(
        safety.any((f) => p.basename(f.path).startsWith('antes_de_restaurar_')),
        isTrue,
        reason: 'guarda os dados que foram substituídos',
      );
    },
  );

  test('arquivo que não é backup é recusado sem mexer em nada', () async {
    final fake = File(p.join(root.path, 'qualquer.zip'))
      ..writeAsStringSync('oi');
    await expectLater(
      RestoreService().inspect(fake.path, appSchema: 1),
      throwsA(anything),
    );
  });

  test('cópia diária automática guarda só as 3 últimas', () async {
    final db = AppDatabase(NativeDatabase(dbFile));
    await GymRepository(db).createGym('Academia');
    await db.close();
    final backups = Directory(p.join(root.path, 'support', 'backups'))
      ..createSync(recursive: true);
    for (final d in ['2026-01-01', '2026-01-02', '2026-01-03', '2026-01-04']) {
      File(p.join(backups.path, 'auto_$d.sqlite')).writeAsStringSync('x');
    }
    await RestoreService.dailyAutoCopy();
    final autos = backups
        .listSync()
        .map((f) => p.basename(f.path))
        .where((n) => n.startsWith('auto_'))
        .toList();
    expect(autos.length, 3);
    expect(autos.any((n) => n.contains('2026-01-01')), isFalse);
  });
}
