import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/prefs/prefs_repository.dart';
import '../../core/utils/ids.dart';

part 'backup_service.g.dart';

/// Versão do formato do ZIP (não é a versão do schema).
const backupFormatVersion = 1;

/// Backup completo (docs/PLANO.md, 6.6). Sem servidor, o celular é o único
/// lugar onde os dados existem — e a pasta privada some ao desinstalar.
///
/// O ZIP leva:
/// - `db.sqlite`: cópia consistente do banco, feita com `VACUUM INTO`
///   (o próprio Drift migra backups antigos ao abrir);
/// - `photos/`: as fotos privadas (quando existirem);
/// - `manifest.json`: versões e contagens, para conferir a restauração.
class BackupService {
  BackupService(this._db, this._prefs);
  final AppDatabase _db;
  final PrefsRepository _prefs;

  /// Gera o ZIP numa pasta temporária e devolve o arquivo.
  Future<File> createBackupZip() async {
    final tmp = await getTemporaryDirectory();
    final stamp = DateFormat('yyyy-MM-dd_HHmm').format(DateTime.now());
    final work = Directory(p.join(tmp.path, 'backup_$stamp'));
    if (work.existsSync()) work.deleteSync(recursive: true);
    work.createSync(recursive: true);

    final zipPath = p.join(tmp.path, 'nodefit-backup-$stamp.zip');
    try {
      return await _writeZip(work, zipPath);
    } catch (_) {
      final partial = File(zipPath);
      if (partial.existsSync()) partial.deleteSync();
      rethrow;
    } finally {
      if (work.existsSync()) work.deleteSync(recursive: true);
    }
  }

  Future<File> _writeZip(Directory work, String zipPath) async {
    final dbCopy = File(p.join(work.path, 'db.sqlite'));
    await _db.customStatement('VACUUM INTO ?', [dbCopy.path]);

    final manifest = File(p.join(work.path, 'manifest.json'));
    await manifest.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'app': 'NodeFit',
        'format': backupFormatVersion,
        'schemaVersion': _db.schemaVersion,
        'exportedAt': nowUtc().toIso8601String(),
        'counts': await _counts(),
      }),
    );

    final encoder = ZipFileEncoder()..create(zipPath);
    await encoder.addFile(dbCopy, 'db.sqlite');
    await encoder.addFile(manifest, 'manifest.json');
    final photos = Directory(
      p.join((await getApplicationSupportDirectory()).path, 'photos'),
    );
    if (photos.existsSync()) {
      await encoder.addDirectory(photos);
    }
    await encoder.close();
    return File(zipPath);
  }

  /// Gera o ZIP e abre o compartilhamento (Drive, e-mail, PC...).
  /// Retorna true se a pessoa não cancelou.
  Future<bool> exportAndShare() async {
    final zip = await createBackupZip();
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(zip.path, mimeType: 'application/zip')],
          subject: 'Backup NodeFit',
          text: 'Backup do NodeFit (${p.basename(zip.path)}).',
        ),
      );
      final ok = result.status != ShareResultStatus.dismissed;
      if (ok) {
        await _prefs.set(PrefKeys.lastBackupAt, nowUtc().toIso8601String());
      }
      return ok;
    } finally {
      // O compartilhamento já copiou o arquivo; não deixa cópias do banco
      // esquecidas no cache.
      try {
        await zip.delete();
      } catch (_) {}
    }
  }

  Future<Map<String, int>> _counts() async {
    Future<int> count(TableInfo<Table, Object?> table) async {
      final c = countAll();
      final row = await (_db.selectOnly(table)..addColumns([c])).getSingle();
      return row.read(c) ?? 0;
    }

    return {
      'gyms': await count(_db.gyms),
      'equipment': await count(_db.equipment),
      'exercises': await count(_db.exercises),
      'stations': await count(_db.stations),
      'stationSettings': await count(_db.stationSettings),
      'workoutSessions': await count(_db.workoutSessions),
      'workoutSets': await count(_db.workoutSets),
    };
  }
}

@Riverpod(keepAlive: true)
BackupService backupService(Ref ref) => BackupService(
  ref.watch(appDatabaseProvider),
  ref.watch(prefsRepositoryProvider),
);
