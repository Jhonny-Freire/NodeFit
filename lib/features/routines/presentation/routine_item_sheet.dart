import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/value_stepper.dart';
import '../../gyms/data/gym_repository.dart';
import '../../gyms/data/station_repository.dart';
import '../../gyms/presentation/equipment_picker_sheet.dart';
import '../../workout/presentation/widgets/session_exercise_card.dart'
    show showRestPicker, supersetName;
import '../data/routine_repository.dart';

/// Edita a prescrição de um exercício da ficha (séries × reps, descanso,
/// aquecimentos, aparelho preferido, cadência e observação).
Future<void> showRoutineItemSheet(
  BuildContext context, {
  required RoutineItemView view,
  required String gymId,
  ({int position, int size})? superset,
  bool hasNext = false,
}) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _RoutineItemSheet(
    view: view,
    gymId: gymId,
    superset: superset,
    hasNext: hasNext,
  ),
);

class _RoutineItemSheet extends ConsumerStatefulWidget {
  const _RoutineItemSheet({
    required this.view,
    required this.gymId,
    required this.superset,
    required this.hasNext,
  });
  final RoutineItemView view;
  final String gymId;
  final ({int position, int size})? superset;
  final bool hasNext;

  @override
  ConsumerState<_RoutineItemSheet> createState() => _RoutineItemSheetState();
}

class _RoutineItemSheetState extends ConsumerState<_RoutineItemSheet> {
  late int _sets = widget.view.item.targetSets;
  late int? _repMin = widget.view.item.repMin;
  late int? _repMax = widget.view.item.repMax;
  late int? _rest = widget.view.item.restSec;
  late int _warmups = widget.view.item.warmupSets;
  late String? _equipmentId = widget.view.item.preferredEquipmentId;
  late String _equipmentName = equipmentDisplayName(widget.view.equipment);
  late final _tempo = TextEditingController(text: widget.view.item.tempo ?? '');
  late final _notes = TextEditingController(text: widget.view.item.notes ?? '');

  @override
  void dispose() {
    _tempo.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickEquipment() async {
    final pick = await showEquipmentPicker(
      context,
      gymId: widget.gymId,
      exercise: widget.view.exercise,
      currentEquipmentId: _equipmentId,
    );
    if (pick == null || !mounted) return;
    final item = pick.equipmentId == null
        ? null
        : await ref.read(gymRepositoryProvider).getEquipment(pick.equipmentId!);
    setState(() {
      _equipmentId = pick.equipmentId;
      _equipmentName = equipmentDisplayName(item);
    });
  }

  Future<void> _save() async {
    final min = _repMin;
    final max = _repMax;
    await ref
        .read(routineRepositoryProvider)
        .updateItem(
          widget.view.item,
          targetSets: _sets,
          repMin: (min != null && max != null && min > max) ? max : min,
          repMax: (min != null && max != null && min > max) ? min : max,
          restSec: _rest,
          warmupSets: _warmups,
          preferredEquipmentId: _equipmentId,
          notes: _notes.text,
          tempo: _tempo.text,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _remove() async {
    final ok = await showConfirmDialog(
      context,
      title: 'Tirar ${widget.view.exercise.name} da ficha?',
      confirmLabel: 'Tirar',
      destructive: true,
    );
    if (!ok) return;
    await ref.read(routineRepositoryProvider).removeItem(widget.view.item);
    if (mounted) Navigator.of(context).pop();
  }

  Widget _stepper(
    String label,
    int? value,
    ValueChanged<int> onChanged, {
    int min = 0,
    int max = 50,
  }) => ValueStepper(
    label: label,
    value: value,
    step: 1,
    min: min,
    max: max,
    format: (v) => v?.toString() ?? '—',
    onChanged: onChanged,
    decreaseTooltip: 'Diminuir $label',
    increaseTooltip: 'Aumentar $label',
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: sheetBottomPadding(context),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.view.exercise.name,
                    style: context.texts.titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Tirar da ficha',
                  onPressed: _remove,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _stepper(
                    'Séries',
                    _sets,
                    (v) => setState(() => _sets = v),
                    min: 1,
                    max: 10,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _stepper(
                    'Aquecimentos',
                    _warmups,
                    (v) => setState(() => _warmups = v),
                    max: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _stepper(
                    'Reps mín.',
                    _repMin,
                    (v) => setState(() => _repMin = v),
                    min: 1,
                    max: 100,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _stepper(
                    'Reps máx.',
                    _repMax,
                    (v) => setState(() => _repMax = v),
                    min: 1,
                    max: 100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'A faixa (ex.: 8–12) liga a sugestão de progressão: quando '
              'todas as séries chegam no máximo, o app sugere subir a carga.',
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Descanso'),
              trailing: Text(
                _rest == null ? 'padrão' : '$_rest s',
                style: context.texts.titleMedium,
              ),
              onTap: () async {
                final s = await showRestPicker(context, current: _rest ?? 0);
                if (s != null) setState(() => _rest = s);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.precision_manufacturing_outlined),
              title: const Text('Aparelho preferido'),
              subtitle: Text(
                _equipmentId == null
                    ? 'O último usado neste exercício'
                    : _equipmentName,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: _pickEquipment,
            ),
            // Bi-set: vale na hora (não depende do Salvar).
            if (widget.superset != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.link_off),
                title: const Text('Tirar do bi-set'),
                subtitle: Text(
                  'Hoje: ${supersetName(widget.superset!.size).toLowerCase()} '
                  '${widget.superset!.position}/${widget.superset!.size}',
                ),
                onTap: () async {
                  await ref
                      .read(routineRepositoryProvider)
                      .unlinkItem(widget.view.item);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            if (widget.hasNext &&
                (widget.superset == null ||
                    widget.superset!.position == widget.superset!.size))
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.link),
                title: const Text('Bi-set com o próximo'),
                subtitle: const Text(
                  'Uma série de cada, em sequência; o descanso vem no fim da '
                  'rodada',
                ),
                onTap: () async {
                  await ref
                      .read(routineRepositoryProvider)
                      .linkItemWithNext(widget.view.item);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            TextField(
              controller: _tempo,
              maxLength: 20,
              decoration: const InputDecoration(
                labelText: 'Cadência (opcional)',
                hintText: 'Ex.: 3-1-1-0',
              ),
            ),
            TextField(
              controller: _notes,
              maxLength: 300,
              maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Observação da ficha (opcional)',
                hintText: 'Ex.: pausa de 1 s embaixo',
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(onPressed: _save, child: const Text('Salvar')),
          ],
        ),
      ),
    );
  }
}
