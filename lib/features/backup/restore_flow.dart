import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/db/database_provider.dart';
import '../../core/widgets/common.dart';
import 'restore_service.dart';

/// Escolher o .zip → conferir → confirmar → substituir → reabrir o banco.
Future<void> restoreFromBackupFlow(BuildContext context, WidgetRef ref) async {
  final file = await FilePicker.pickFile(
    dialogTitle: 'Escolha o backup do NodeFit (.zip)',
  );
  final path = file?.path;
  if (path == null || !context.mounted) return;

  final db = ref.read(appDatabaseProvider);
  final service = RestoreService();
  final RestorePreview preview;
  try {
    preview = await service.inspect(path, appSchema: db.schemaVersion);
  } on FormatException catch (e) {
    if (context.mounted) showSnack(context, e.message);
    return;
  } catch (e) {
    if (context.mounted) showSnack(context, 'Não consegui ler o backup: $e');
    return;
  }
  if (!context.mounted) return;

  final when = preview.exportedAt == null
      ? ''
      : ' de ${DateFormat('dd/MM/yyyy HH:mm').format(preview.exportedAt!.toLocal())}';
  final ok = await showConfirmDialog(
    context,
    title: 'Restaurar backup?',
    message:
        'O backup$when tem ${preview.sessions} treino(s) e '
        '${preview.equipment} aparelho(s).\n\n'
        'Os dados atuais deste celular serão SUBSTITUÍDOS. Uma cópia deles '
        'fica guardada no app, por segurança.',
    confirmLabel: 'Restaurar',
    destructive: true,
  );
  if (!ok) {
    if (preview.workDir.existsSync()) {
      preview.workDir.deleteSync(recursive: true);
    }
    return;
  }
  await service.apply(preview, db);
  // Reabre o banco com os dados restaurados; as telas se atualizam sozinhas.
  ref.invalidate(appDatabaseProvider);
  if (context.mounted) showSnack(context, 'Backup restaurado.');
}
