import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../data/gym_repository.dart';
import '../data/station_repository.dart';
import 'equipment_form_sheet.dart';

/// Um aparelho: dados, exercícios feitos nele (estações) e o que fazer
/// quando a academia troca a máquina.
class EquipmentDetailScreen extends ConsumerWidget {
  const EquipmentDetailScreen({super.key, required this.equipmentId});
  final String equipmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(equipmentItemProvider(equipmentId));
    return AsyncView(
      value: item,
      builder: (e) {
        if (e == null) {
          return const Scaffold(
            body: EmptyState(
              icon: Icons.help_outline,
              title: 'Aparelho não encontrado',
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(e.name),
            actions: [
              IconButton(
                tooltip: 'Editar aparelho',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    showEquipmentForm(context, gymId: e.gymId, existing: e),
              ),
              PopupMenuButton<String>(
                onSelected: (v) => _menu(context, ref, e, v),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'replace',
                    child: Text('A academia trocou esta máquina'),
                  ),
                  PopupMenuItem(value: 'archive', child: Text('Arquivar')),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (e.archivedAt != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Arquivado — o histórico continua disponível.',
                    style: TextStyle(color: context.semantic.attention),
                  ),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Info('Tipo', e.type.label),
                      _Info(
                        'Carga em',
                        e.loadUnit == LoadUnit.plate
                            ? 'nº da placa'
                            : e.loadUnit.label,
                      ),
                      _Info(
                        'O número anotado é',
                        e.loadBasis.label.toLowerCase(),
                      ),
                      _Info(
                        'Menor salto',
                        formatLoad(e.incrementMilli, e.loadUnit),
                      ),
                      if (e.baseLoadMilli != null)
                        _Info(
                          'Carrinho/barra',
                          formatLoad(e.baseLoadMilli, e.loadUnit),
                        ),
                      if (e.gymLabel != null)
                        _Info('Nº na academia', e.gymLabel!),
                    ],
                  ),
                ),
              ),
              const SectionLabel('Exercícios neste aparelho'),
              _StationsList(equipmentId: e.id),
            ],
          ),
        );
      },
    );
  }

  Future<void> _menu(
    BuildContext context,
    WidgetRef ref,
    EquipmentItem e,
    String action,
  ) async {
    final repo = ref.read(gymRepositoryProvider);
    if (action == 'replace') {
      final ok = await showConfirmDialog(
        context,
        title: 'A academia trocou a máquina?',
        message:
            'A antiga é arquivada com todo o histórico. A nova começa limpa, '
            'porque "20" na máquina nova pode não ser "20" na velha.',
        confirmLabel: 'Trocar',
      );
      if (!ok) return;
      final created = await repo.replaceEquipment(e);
      if (context.mounted) context.go('/caderno/aparelho/${created.id}');
    } else if (action == 'archive') {
      final ok = await showConfirmDialog(
        context,
        title: 'Arquivar ${e.name}?',
        message: 'Some das listas, mas o histórico continua.',
        confirmLabel: 'Arquivar',
      );
      if (!ok) return;
      await repo.archiveEquipment(e.id);
      if (context.mounted) context.pop();
    }
  }
}

class _Info extends StatelessWidget {
  const _Info(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

class _StationsList extends ConsumerWidget {
  const _StationsList({required this.equipmentId});
  final String equipmentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(equipmentStationsProvider(equipmentId));
    return AsyncView(
      value: stations,
      builder: (list) => list.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Ainda não. Ao usar este aparelho num treino, o exercício '
                'aparece aqui com os ajustes.',
              ),
            )
          : Card(
              child: Column(
                children: [for (final s in list) _StationTile(view: s)],
              ),
            ),
    );
  }
}

class _StationTile extends ConsumerWidget {
  const _StationTile({required this.view});
  final StationView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings =
        ref.watch(stationSettingsProvider(view.station.id)).value ?? const [];
    return ListTile(
      title: Text(view.exercise.name),
      subtitle: Text(
        settings.isEmpty
            ? 'Sem ajustes anotados'
            : settings
                  .map((s) => '${s.label} ${formatSettingValue(s)}')
                  .join(' · '),
        style: TextStyle(color: context.colors.onSurfaceVariant),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push('/caderno/estacao/${view.station.id}'),
    );
  }
}
