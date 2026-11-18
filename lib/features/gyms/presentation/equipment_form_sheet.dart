import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';
import '../../../core/widgets/common.dart';
import '../../../core/domain/load.dart';
import '../data/gym_repository.dart';

/// Padrões sensatos por tipo de aparelho (dá para mudar no formulário).
({LoadUnit unit, LoadBasis basis, int incrementMilli}) equipmentDefaults(
  EquipmentType type,
) => switch (type) {
  EquipmentType.machine => (
    unit: LoadUnit.kg,
    basis: LoadBasis.total,
    incrementMilli: 5000,
  ),
  EquipmentType.cable => (
    unit: LoadUnit.kg,
    basis: LoadBasis.total,
    incrementMilli: 2500,
  ),
  EquipmentType.plateLoaded => (
    unit: LoadUnit.kg,
    basis: LoadBasis.perSide,
    incrementMilli: 5000,
  ),
  EquipmentType.barbell || EquipmentType.smith => (
    unit: LoadUnit.kg,
    basis: LoadBasis.total,
    incrementMilli: 2000,
  ),
  EquipmentType.dumbbell || EquipmentType.kettlebell => (
    unit: LoadUnit.kg,
    basis: LoadBasis.perHand,
    incrementMilli: 2000,
  ),
  EquipmentType.bodyweight || EquipmentType.band || EquipmentType.other => (
    unit: LoadUnit.kg,
    basis: LoadBasis.total,
    incrementMilli: 1000,
  ),
};

/// Cria ([existing] == null) ou edita um aparelho. Devolve o aparelho salvo.
Future<EquipmentItem?> showEquipmentForm(
  BuildContext context, {
  required String gymId,
  EquipmentItem? existing,
  String? suggestedName,
  EquipmentType? suggestedType,
}) => showModalBottomSheet<EquipmentItem>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _EquipmentForm(
    gymId: gymId,
    existing: existing,
    suggestedName: suggestedName,
    suggestedType: suggestedType,
  ),
);

class _EquipmentForm extends ConsumerStatefulWidget {
  const _EquipmentForm({
    required this.gymId,
    this.existing,
    this.suggestedName,
    this.suggestedType,
  });
  final String gymId;
  final EquipmentItem? existing;
  final String? suggestedName;
  final EquipmentType? suggestedType;

  @override
  ConsumerState<_EquipmentForm> createState() => _EquipmentFormState();
}

class _EquipmentFormState extends ConsumerState<_EquipmentForm> {
  late final TextEditingController _name;
  late final TextEditingController _label;
  late final TextEditingController _increment;
  late final TextEditingController _base;
  late EquipmentType _type;
  late LoadUnit _unit;
  late LoadBasis _basis;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _type = e?.type ?? widget.suggestedType ?? EquipmentType.machine;
    final d = equipmentDefaults(_type);
    _unit = e?.loadUnit ?? d.unit;
    _basis = e?.loadBasis ?? d.basis;
    _name = TextEditingController(text: e?.name ?? widget.suggestedName ?? '');
    _label = TextEditingController(text: e?.gymLabel ?? '');
    _increment = TextEditingController(
      text: formatLoadValue(e?.incrementMilli ?? d.incrementMilli),
    );
    _base = TextEditingController(
      text: e?.baseLoadMilli == null ? '' : formatLoadValue(e!.baseLoadMilli),
    );
  }

  @override
  void dispose() {
    _name.dispose();
    _label.dispose();
    _increment.dispose();
    _base.dispose();
    super.dispose();
  }

  void _onTypeChanged(EquipmentType? t) {
    if (t == null) return;
    setState(() {
      _type = t;
      if (widget.existing == null) {
        final d = equipmentDefaults(t);
        _unit = d.unit;
        _basis = d.basis;
        _increment.text = formatLoadValue(d.incrementMilli);
      }
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final increment = parseLoadMilli(_increment.text);
    if (name.isEmpty || increment == null || increment <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha o nome e um incremento válido.'),
        ),
      );
      return;
    }
    setState(() => _saving = true);
    final repo = ref.read(gymRepositoryProvider);
    final base = parseLoadMilli(_base.text);
    EquipmentItem? saved;
    try {
      if (widget.existing == null) {
        saved = await repo.createEquipment(
          gymId: widget.gymId,
          name: name,
          type: _type,
          loadUnit: _unit,
          loadBasis: _basis,
          incrementMilli: increment,
          baseLoadMilli: base,
          gymLabel: _label.text,
        );
      } else {
        await repo.updateEquipment(
          widget.existing!.id,
          name: name,
          type: _type,
          loadUnit: _unit,
          loadBasis: _basis,
          incrementMilli: increment,
          baseLoadMilli: base,
          gymLabel: _label.text,
        );
        saved = await repo.getEquipment(widget.existing!.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Não consegui salvar: $e')));
      }
      return;
    }
    if (mounted) Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    final unitLabel = _unit.label;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: sheetBottomPadding(context, 20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existing == null ? 'Novo aparelho' : 'Editar aparelho',
              style: context.texts.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              maxLength: 80,
              autofocus: widget.existing == null && _name.text.isEmpty,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nome',
                hintText: 'Ex.: Leg press 45° preto',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<EquipmentType>(
                    initialValue: _type,
                    decoration: const InputDecoration(labelText: 'Tipo'),
                    items: [
                      for (final t in EquipmentType.values)
                        DropdownMenuItem(value: t, child: Text(t.label)),
                    ],
                    onChanged: _onTypeChanged,
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: _label,
                    decoration: const InputDecoration(
                      labelText: 'Nº na academia',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'A máquina mostra a carga em',
              style: context.texts.labelLarge,
            ),
            const SizedBox(height: 8),
            SegmentedButton<LoadUnit>(
              segments: const [
                ButtonSegment(value: LoadUnit.kg, label: Text('kg')),
                ButtonSegment(value: LoadUnit.lb, label: Text('lb')),
                ButtonSegment(
                  value: LoadUnit.plate,
                  label: Text('nº da placa'),
                ),
              ],
              selected: {_unit},
              onSelectionChanged: (s) => setState(() => _unit = s.first),
            ),
            const SizedBox(height: 16),
            Text('O número que você anota é', style: context.texts.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<LoadBasis>(
              segments: [
                for (final b in LoadBasis.values)
                  ButtonSegment(value: b, label: Text(b.label)),
              ],
              selected: {_basis},
              onSelectionChanged: (s) => setState(() => _basis = s.first),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _increment,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Menor salto de carga',
                      suffixText: unitLabel,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _base,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Carrinho/barra',
                      hintText: 'opcional',
                      suffixText: unitLabel,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Salvando…' : 'Salvar aparelho'),
            ),
          ],
        ),
      ),
    );
  }
}
