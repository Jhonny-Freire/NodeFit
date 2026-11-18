import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../data/gym_repository.dart';
import '../data/station_repository.dart';
import 'equipment_form_sheet.dart';
import 'gym_switcher.dart';

/// Aba Caderno: os aparelhos da academia atual e o catálogo de exercícios.
class NotebookScreen extends ConsumerWidget {
  const NotebookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gym = ref.watch(currentGymProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caderno'),
        actions: const [GymSwitcher()],
      ),
      floatingActionButton: gym == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => showEquipmentForm(context, gymId: gym.id),
              icon: const Icon(Icons.add),
              label: const Text('Aparelho'),
            ),
      body: gym == null
          ? const EmptyState(
              icon: Icons.place_outlined,
              title: 'Cadastre sua academia na aba Treinar',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.list_alt),
                    title: const Text('Exercícios'),
                    subtitle: const Text('Catálogo em PT-BR + os seus'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/caderno/exercicios'),
                  ),
                ),
                SectionLabel('Aparelhos · ${gym.name}'),
                _EquipmentList(gymId: gym.id),
                _NoEquipmentStations(gymId: gym.id),
              ],
            ),
    );
  }
}

class _EquipmentList extends ConsumerWidget {
  const _EquipmentList({required this.gymId});
  final String gymId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(gymEquipmentProvider(gymId));
    return AsyncView(
      value: items,
      builder: (list) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 24),
            child: EmptyState(
              icon: Icons.precision_manufacturing_outlined,
              title: 'Nenhum aparelho ainda',
              message:
                  'Eles aparecem aqui quando você os escolhe no treino — '
                  'ou cadastre agora pelo botão abaixo.',
            ),
          );
        }
        return Card(
          child: Column(
            children: [
              for (final e in list)
                ListTile(
                  leading: Icon(
                    e.type == EquipmentType.bodyweight
                        ? Icons.accessibility_new
                        : Icons.precision_manufacturing_outlined,
                  ),
                  title: Text(
                    e.gymLabel == null
                        ? e.name
                        : '${e.name} (nº ${e.gymLabel})',
                  ),
                  subtitle: Text(
                    '${e.type.label} · passo ${formatLoad(e.incrementMilli, e.loadUnit)}',
                    style: TextStyle(color: context.colors.onSurfaceVariant),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/caderno/aparelho/${e.id}'),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Exercícios feitos sem aparelho (flexão, prancha...): também têm ajustes,
/// nota e histórico.
class _NoEquipmentStations extends ConsumerWidget {
  const _NoEquipmentStations({required this.gymId});
  final String gymId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list =
        ref.watch(gymStationsWithoutEquipmentProvider(gymId)).value ?? const [];
    if (list.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('Sem aparelho'),
        Card(
          child: Column(
            children: [
              for (final s in list)
                ListTile(
                  leading: const Icon(Icons.accessibility_new),
                  title: Text(s.exercise.name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/caderno/estacao/${s.station.id}'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
