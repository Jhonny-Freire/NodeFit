import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../catalog/presentation/muscle_groups.dart';
import '../data/gym_repository.dart';
import '../data/station_repository.dart';
import 'equipment_form_sheet.dart';

/// Resultado da escolha: um aparelho, ou "sem aparelho" (equipmentId null).
class EquipmentPick {
  const EquipmentPick(this.equipmentId);
  final String? equipmentId;
}

/// Aparelho escolhido para um exercício, e se foi automático.
class EquipmentChoice {
  const EquipmentChoice({
    required this.equipmentId,
    required this.automatic,
    required this.label,
  });
  final String? equipmentId;

  /// true = o app escolheu sozinho (o da última vez / peso corporal).
  final bool automatic;
  final String label;
}

/// O jeito rápido: se você já fez o exercício nesta academia, usa o mesmo
/// aparelho sem perguntar; peso corporal entra sem aparelho. Só pergunta
/// na primeira vez. Null se a pessoa cancelar.
Future<EquipmentChoice?> chooseEquipment(
  BuildContext context,
  WidgetRef ref, {
  required String gymId,
  required Exercise exercise,
}) async {
  final stations = ref.read(stationRepositoryProvider);
  final gyms = ref.read(gymRepositoryProvider);
  final last = await stations.lastUseFor(exerciseId: exercise.id, gymId: gymId);
  if (last.found) {
    final eq = last.equipmentId == null
        ? null
        : await gyms.getEquipment(last.equipmentId!);
    return EquipmentChoice(
      equipmentId: last.equipmentId,
      automatic: true,
      label: equipmentDisplayName(eq),
    );
  }
  if (exercise.equipmentType == EquipmentType.bodyweight) {
    return const EquipmentChoice(
      equipmentId: null,
      automatic: true,
      label: 'Sem aparelho',
    );
  }
  if (!context.mounted) return null;
  final pick = await showEquipmentPicker(
    context,
    gymId: gymId,
    exercise: exercise,
  );
  if (pick == null) return null;
  final eq = pick.equipmentId == null
      ? null
      : await gyms.getEquipment(pick.equipmentId!);
  return EquipmentChoice(
    equipmentId: pick.equipmentId,
    automatic: false,
    label: equipmentDisplayName(eq),
  );
}

/// "Em qual aparelho?" — criar um novo é só digitar o nome.
Future<EquipmentPick?> showEquipmentPicker(
  BuildContext context, {
  required String gymId,
  required Exercise exercise,
  String? currentEquipmentId,
}) => showModalBottomSheet<EquipmentPick>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _EquipmentPicker(
    gymId: gymId,
    exercise: exercise,
    currentEquipmentId: currentEquipmentId,
  ),
);

/// Tipo de aparelho que combina com o tipo do exercício.
EquipmentType _equipmentTypeFor(EquipmentType exerciseType) =>
    exerciseType == EquipmentType.bodyweight
    ? EquipmentType.other
    : exerciseType;

class _EquipmentPicker extends ConsumerStatefulWidget {
  const _EquipmentPicker({
    required this.gymId,
    required this.exercise,
    this.currentEquipmentId,
  });
  final String gymId;
  final Exercise exercise;
  final String? currentEquipmentId;

  @override
  ConsumerState<_EquipmentPicker> createState() => _EquipmentPickerState();
}

class _EquipmentPickerState extends ConsumerState<_EquipmentPicker> {
  final _name = TextEditingController();
  late final Future<String?> _lastUsed = ref
      .read(stationRepositoryProvider)
      .lastEquipmentIdFor(exerciseId: widget.exercise.id, gymId: widget.gymId);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _quickCreate() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final type = _equipmentTypeFor(widget.exercise.equipmentType);
    final d = equipmentDefaults(type);
    final created = await ref
        .read(gymRepositoryProvider)
        .createEquipment(
          gymId: widget.gymId,
          name: name,
          type: type,
          loadUnit: d.unit,
          loadBasis: d.basis,
          incrementMilli: d.incrementMilli,
        );
    if (mounted) Navigator.of(context).pop(EquipmentPick(created.id));
  }

  Future<void> _fullForm() async {
    final created = await showEquipmentForm(
      context,
      gymId: widget.gymId,
      suggestedName: _name.text.trim().isEmpty
          ? widget.exercise.name
          : _name.text.trim(),
      suggestedType: _equipmentTypeFor(widget.exercise.equipmentType),
    );
    if (created != null && mounted) {
      Navigator.of(context).pop(EquipmentPick(created.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final equipment =
        ref.watch(gymEquipmentProvider(widget.gymId)).value ?? const [];
    final type = _equipmentTypeFor(widget.exercise.equipmentType);
    final d = equipmentDefaults(type);
    final withLoad = widget.exercise.tracking == TrackingType.weightReps;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scroll) => FutureBuilder<String?>(
        future: _lastUsed,
        builder: (context, lastSnap) {
          final lastId = lastSnap.data;
          final matching =
              equipment.where((e) => e.type == type || e.id == lastId).toList()
                ..sort((a, b) {
                  if (a.id == lastId) return -1;
                  if (b.id == lastId) return 1;
                  return a.name.compareTo(b.name);
                });
          final others = equipment.where((e) => !matching.contains(e)).toList();
          return ListView(
            controller: scroll,
            padding: EdgeInsets.only(
              bottom:
                  MediaQuery.viewInsetsOf(context).bottom +
                  MediaQuery.viewPaddingOf(context).bottom +
                  24,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
                child: Text(
                  'Em qual aparelho?',
                  style: context.texts.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Text(
                  '${widget.exercise.name} · da próxima vez o app já lembra',
                  style: context.texts.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              // Criar é só digitar o nome.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _name,
                        maxLength: 80,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Aparelho novo',
                          hintText: 'Ex.: ${widget.exercise.name} preto, nº 12',
                          counterText: '',
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _quickCreate(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: _name.text.trim().isEmpty
                          ? null
                          : _quickCreate,
                      child: const Text('Criar'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 8, 0),
                child: Row(
                  children: [
                    Expanded(
                      // Passo e carga por lado só importam com carga.
                      child: Text(
                        !withLoad
                            ? 'Para anotar os ajustes (inclinação, nível...)'
                            : 'Padrão: ${type.label.toLowerCase()} · passo '
                                  '${formatLoad(d.incrementMilli, d.unit)}'
                                  '${d.basis == LoadBasis.total ? '' : ' · ${d.basis.label.toLowerCase()}'}',
                        style: context.texts.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _fullForm,
                      child: const Text('Mais opções'),
                    ),
                  ],
                ),
              ),
              if (matching.isNotEmpty) ...[
                _header(context, 'Aparelhos desta academia'),
                for (final e in matching) _tile(context, e, lastId),
              ],
              if (others.isNotEmpty) ...[
                _header(context, 'Outros aparelhos'),
                for (final e in others) _tile(context, e, lastId),
              ],
              _header(context, 'Sem aparelho'),
              ListTile(
                leading: _icon(context, Icons.accessibility_new, false),
                title: Text(
                  withLoad ? 'Peso corporal / sem aparelho' : 'Sem aparelho',
                ),
                subtitle: Text(
                  withLoad
                      ? 'Anota só as repetições e a carga extra'
                      : 'Anota só o tempo${widget.exercise.tracking == TrackingType.cardio ? ' e a distância' : ''}',
                ),
                onTap: () =>
                    Navigator.of(context).pop(const EquipmentPick(null)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
    child: Text(
      text.toUpperCase(),
      style: context.texts.labelMedium?.copyWith(
        color: context.colors.onSurfaceVariant,
        letterSpacing: 1.1,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _icon(BuildContext context, IconData icon, bool highlight) =>
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: highlight
              ? context.colors.primaryContainer
              : context.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: highlight
              ? context.colors.onPrimaryContainer
              : context.colors.onSurfaceVariant,
        ),
      );

  Widget _tile(BuildContext context, EquipmentItem e, String? lastId) {
    final isLast = e.id == lastId;
    final isCurrent = e.id == widget.currentEquipmentId;
    return ListTile(
      leading: _icon(context, equipmentIcon(e.type), isLast || isCurrent),
      title: Text(equipmentDisplayName(e)),
      subtitle: Text(
        [
          if (isCurrent) 'em uso agora',
          if (isLast && !isCurrent) 'o da última vez',
          'passo ${formatLoad(e.incrementMilli, e.loadUnit)}',
          if (e.loadBasis != LoadBasis.total) e.loadBasis.label.toLowerCase(),
        ].join(' · '),
        style: TextStyle(
          color: isLast || isCurrent
              ? context.colors.primary
              : context.colors.onSurfaceVariant,
        ),
      ),
      onTap: () => Navigator.of(context).pop(EquipmentPick(e.id)),
    );
  }
}
