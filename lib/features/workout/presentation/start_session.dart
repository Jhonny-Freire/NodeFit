import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../core/utils/plural.dart';
import '../data/workout_repository.dart';

enum _OpenSessionAction { resume, closeAndStart }

/// Antes de começar outro treino: se já tem um aberto, pergunta o que fazer
/// com ele (continuar, ou fechar e começar o novo). Devolve true se pode
/// começar o novo.
Future<bool> settleOpenSession(BuildContext context, WidgetRef ref) async {
  final repo = ref.read(workoutRepositoryProvider);
  final open = await repo.openSession();
  if (open == null) return true;
  final counts = await repo.setCounts(open.id);
  if (!context.mounted) return false;
  final empty = counts.done == 0;
  final action = await showDialog<_OpenSessionAction>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tem um treino aberto'),
      content: Text(
        empty
            ? '${open.title}, sem nenhuma série feita.'
            : '${open.title}, com '
                  '${plural(counts.done, 'série feita', 'séries feitas')}.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_OpenSessionAction.resume),
          child: const Text('Continuar ele'),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.of(context).pop(_OpenSessionAction.closeAndStart),
          child: Text(empty ? 'Descartar e começar' : 'Finalizar e começar'),
        ),
      ],
    ),
  );
  if (!context.mounted || action == null) return false;
  if (action == _OpenSessionAction.resume) {
    await context.push(sessionPath(open.id));
    return false;
  }
  ScaffoldMessenger.of(context).clearSnackBars();
  if (empty) {
    await repo.discardSession(open.id);
  } else {
    await repo.finishSession(open.id);
  }
  return true;
}
