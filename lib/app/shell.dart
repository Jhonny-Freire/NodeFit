import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/db/app_database.dart';
import '../features/workout/data/workout_repository.dart';
import '../features/workout/presentation/widgets/elapsed_text.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// Abas inferiores + minibarra "treino em andamento" (para voltar ao
/// treino de qualquer aba).
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeSessionProvider).value;
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: shell),
          // Na aba Treinar o cartão "Continuar treino" já aparece.
          if (active != null && shell.currentIndex != 0)
            _ActiveSessionBar(session: active),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Treinar',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Caderno',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Progresso',
          ),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'Mais'),
        ],
      ),
    );
  }
}

class _ActiveSessionBar extends StatelessWidget {
  const _ActiveSessionBar({required this.session});
  final WorkoutSession session;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.primaryContainer,
      child: InkWell(
        onTap: () => context.push(sessionPath(session.id)),
        child: SafeArea(
          top: false,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.play_circle_fill,
                  color: context.colors.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Treino em andamento',
                    style: context.texts.titleSmall?.copyWith(
                      color: context.colors.onPrimaryContainer,
                    ),
                  ),
                ),
                ElapsedText(
                  since: session.startedAt,
                  style: context.texts.titleSmall?.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontFeatures: tabularFigures,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: context.colors.onPrimaryContainer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
