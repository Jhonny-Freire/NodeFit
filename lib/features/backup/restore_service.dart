import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/drift.dart';

import 'probe_executor.dart';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/db/app_database.dart';
import 'backup_service.dart';

/// O que um backup contém, para a pessoa confirmar antes de substituir.
class RestorePreview {
  const RestorePreview({
    required this.workDir,
    required this.exportedAt,
    required this.sessions,
    required this.equipment,
  });
  final Directory workDir;
  final DateTime? exportedAt;
  final int sessions;
  final int equipment;
}

/// Restaura o ZIP gerado por [BackupService]: banco + fotos.
class RestoreService {
  /// Pasta do app onde ficam o banco e as fotos.
  static Future<Directory> _appDir() => getApplicationSupportDirectory();

  static File _dbFile(Directory dir) =>
      File(p.join(dir.path, '${AppDatabase.fileName}.sqlite'));

  /// Abre e confere o backup SEM mexer nos dados atuais.
  Future<RestorePreview> inspect(
    String zipPath, {
    required int appSchema,
  }) async {
    final tmp = await getTemporaryDirectory();
    final work = Directory(
      p.join(tmp.path, 'restore_${DateTime.now().millisecondsSinceEpoch}'),
    );
    work.createSync(recursive: true);
    try {
      await extractFileToDisk(zipPath, work.path);
      final manifestFile = File(p.join(work.path, 'manifest.json'));
      final dbFile = File(p.join(work.path, 'db.sqlite'));
      if (!manifestFile.existsSync() || !dbFile.existsSync()) {
        throw const FormatException('Este arquivo não é um backup do NodeFit.');
      }
      final manifest =
          jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
      if (manifest['app'] != 'NodeFit' ||
          (manifest['format'] as int? ?? 999) > backupFormatVersion) {
        throw const FormatException(
          'Backup de uma versão mais nova do app. Atualize o NodeFit antes.',
        );
      }
      if ((manifest['schemaVersion'] as int? ?? 999) > appSchema) {
        throw const FormatException(
          'Backup de uma versão mais nova do app. Atualize o NodeFit antes.',
        );
      }
      // Abre a cópia (o Drift migra backups antigos aqui) e confere.
      final probe = AppDatabase(probeExecutor(dbFile));
      try {
        final sessions = countAll();
        final s =
            await (probe.selectOnly(probe.workoutSessions)
                  ..addColumns([sessions])
                  ..where(probe.workoutSessions.endedAt.isNotNull()))
                .getSingle();
        final equipment = countAll();
        final e = await (probe.selectOnly(
          probe.equipment,
        )..addColumns([equipment])).getSingle();
        return RestorePreview(
          workDir: work,
          exportedAt: DateTime.tryParse(
            manifest['exportedAt'] as String? ?? '',
          ),
          sessions: s.read(sessions) ?? 0,
          equipment: e.read(equipment) ?? 0,
        );
      } finally {
        await probe.close();
      }
    } catch (_) {
      if (work.existsSync()) work.deleteSync(recursive: true);
      rethrow;
    }
  }

  /// Substitui o banco e as fotos atuais pelos do backup. Antes, guarda uma
  /// cópia de segurança dos dados atuais em backups/. Fecha [current]; quem
  /// chama deve reabrir o banco (invalidar o provider).
  Future<void> apply(RestorePreview preview, AppDatabase current) async {
    final dir = await _appDir();
    final backups = Directory(p.join(dir.path, 'backups'))
      ..createSync(recursive: true);
    final stamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
    await current.customStatement('VACUUM INTO ?', [
      p.join(backups.path, 'antes_de_restaurar_$stamp.sqlite'),
    ]);
    await current.close();

    final target = _dbFile(dir);
    for (final suffix in ['', '-journal', '-wal', '-shm']) {
      final f = File('${target.path}$suffix');
      if (f.existsSync()) f.deleteSync();
    }
    await File(p.join(preview.workDir.path, 'db.sqlite')).copy(target.path);

    final photos = Directory(p.join(dir.path, 'photos'));
    final newPhotos = Directory(p.join(preview.workDir.path, 'photos'));
    if (photos.existsSync()) photos.deleteSync(recursive: true);
    if (newPhotos.existsSync()) {
      await _copyDir(newPhotos, photos);
    }
    preview.workDir.deleteSync(recursive: true);
  }

  Future<void> _copyDir(Directory from, Directory to) async {
    to.createSync(recursive: true);
    await for (final entity in from.list(recursive: true)) {
      final rel = p.relative(entity.path, from: from.path);
      final dest = p.join(to.path, rel);
      if (entity is Directory) {
        Directory(dest).createSync(recursive: true);
      } else if (entity is File) {
        Directory(p.dirname(dest)).createSync(recursive: true);
        await entity.copy(dest);
      }
    }
  }

  /// Rede de segurança: uma cópia do banco por dia (as 3 últimas), feita
  /// ANTES de o banco abrir — cobre atualizações do app e migrações.
  static Future<void> dailyAutoCopy() async {
    final dir = await _appDir();
    final db = _dbFile(dir);
    if (!db.existsSync()) return;
    final backups = Directory(p.join(dir.path, 'backups'))
      ..createSync(recursive: true);
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final target = File(p.join(backups.path, 'auto_$today.sqlite'));
    if (!target.existsSync()) await db.copy(target.path);
    final autos =
        backups
            .listSync()
            .whereType<File>()
            .where((f) => p.basename(f.path).startsWith('auto_'))
            .toList()
          ..sort((a, b) => b.path.compareTo(a.path));
    for (final old in autos.skip(3)) {
      old.deleteSync();
    }
  }
}
