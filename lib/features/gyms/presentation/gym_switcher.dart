import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/app_database.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/widgets/common.dart';
import '../data/gym_repository.dart';

/// Botão com o nome da academia atual: trocar, criar ou renomear.
/// "Casa" é só mais uma academia, com os aparelhos e ajustes dela.
class GymSwitcher extends ConsumerWidget {
  const GymSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currentGymProvider).value;
    final gyms = ref.watch(gymsProvider).value ?? const <Gym>[];
    if (current == null) return const SizedBox.shrink();
    return PopupMenuButton<String>(
      tooltip: 'Trocar academia',
      onSelected: (value) => _onSelected(context, ref, value, current),
      itemBuilder: (_) => [
        for (final g in gyms)
          CheckedPopupMenuItem(
            value: 'gym:${g.id}',
            checked: g.id == current.id,
            child: Text(g.name),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(value: 'new', child: Text('Nova academia…')),
        PopupMenuItem(
          value: 'rename',
          child: Text('Renomear "${current.name}"…'),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place_outlined, size: 18),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(current.name, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
    Gym current,
  ) async {
    final prefs = ref.read(prefsRepositoryProvider);
    final repo = ref.read(gymRepositoryProvider);
    if (value.startsWith('gym:')) {
      await prefs.set(PrefKeys.currentGymId, value.substring(4));
    } else if (value == 'new') {
      final name = await showTextInputDialog(
        context,
        title: 'Nova academia',
        hint: 'Ex.: Unidade Centro, Casa',
        maxLength: 80,
      );
      if (name == null || name.trim().isEmpty) return;
      final gym = await repo.createGym(name);
      await prefs.set(PrefKeys.currentGymId, gym.id);
    } else if (value == 'rename') {
      final name = await showTextInputDialog(
        context,
        title: 'Nome da academia',
        initial: current.name,
        maxLength: 80,
      );
      if (name == null || name.trim().isEmpty) return;
      await repo.renameGym(current.id, name);
    }
  }
}
