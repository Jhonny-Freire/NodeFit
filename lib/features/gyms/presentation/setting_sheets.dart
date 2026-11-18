import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/value_stepper.dart';
import '../data/station_repository.dart';

enum _SettingAction { rename, remove }

/// Edita o valor de um ajuste. Salva SOZINHO ao fechar (arrastar para baixo
/// ou tocar fora): mudar "Banco 7 → 8" custa 2 toques no treino.
Future<void> showEditSettingSheet(
  BuildContext context,
  WidgetRef ref, {
  required StationSetting setting,
  String? sessionId,
}) async {
  final repo = ref.read(stationRepositoryProvider); // antes de qualquer await
  final draft = _Draft(setting.valueNum, setting.valueText ?? '');
  final action = await showModalBottomSheet<_SettingAction>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _EditSettingSheet(setting: setting, draft: draft),
  );
  switch (action) {
    case _SettingAction.remove:
      await repo.archiveSetting(setting.id);
    case _SettingAction.rename:
      // Primeiro salva o valor que foi mexido antes de renomear.
      await repo.updateSettingValue(
        setting,
        valueNum: draft.number,
        valueText: draft.text,
        sessionId: sessionId,
      );
      if (!context.mounted) return;
      final name = await showTextInputDialog(
        context,
        title: 'Nome do ajuste',
        initial: setting.label,
        maxLength: 40,
      );
      if (name != null && name.trim().isNotEmpty) {
        await repo.updateSettingMeta(
          setting.id,
          label: name,
          step: setting.step,
        );
      }
    case null:
      await repo.updateSettingValue(
        setting,
        valueNum: draft.number,
        valueText: draft.text,
        sessionId: sessionId,
      );
  }
}

class _Draft {
  _Draft(this.number, this.text);
  double? number;
  String text;
}

class _EditSettingSheet extends StatefulWidget {
  const _EditSettingSheet({required this.setting, required this.draft});
  final StationSetting setting;
  final _Draft draft;

  @override
  State<_EditSettingSheet> createState() => _EditSettingSheetState();
}

class _EditSettingSheetState extends State<_EditSettingSheet> {
  late final TextEditingController _text = TextEditingController(
    text: widget.draft.text,
  );

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  int? get _milli => widget.draft.number == null
      ? null
      : (widget.draft.number! * 1000).round();

  Future<void> _typeValue() async {
    final typed = await showNumberInputDialog(
      context,
      title: widget.setting.label,
      initial: widget.draft.number == null
          ? ''
          : formatNumber(widget.draft.number!),
    );
    final milli = typed == null ? null : parseLoadMilli(typed);
    if (milli != null) setState(() => widget.draft.number = milli / 1000);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.setting;
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: sheetBottomPadding(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(s.label, style: context.texts.titleLarge)),
              PopupMenuButton<_SettingAction>(
                onSelected: (a) => Navigator.of(context).pop(a),
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: _SettingAction.rename,
                    child: Text('Renomear ajuste'),
                  ),
                  PopupMenuItem(
                    value: _SettingAction.remove,
                    child: Text('Remover ajuste'),
                  ),
                ],
              ),
            ],
          ),
          Text(
            'Salva sozinho ao fechar.',
            style: context.texts.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          if (s.kind == SettingKind.number)
            ValueStepper(
              label: 'Valor (passo ${formatNumber(s.step)})',
              value: _milli,
              step: (s.step * 1000).round().clamp(1, 1000000),
              min: -1000000,
              format: (v) => v == null ? '—' : formatNumber(v / 1000),
              onChanged: (v) => setState(() => widget.draft.number = v / 1000),
              onTapValue: _typeValue,
              decreaseTooltip: 'Diminuir ${s.label}',
              increaseTooltip: 'Aumentar ${s.label}',
            )
          else
            TextField(
              controller: _text,
              autofocus: true,
              maxLength: 60,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(hintText: 'Ex.: corda, aberta'),
              onChanged: (v) => widget.draft.text = v,
              onSubmitted: (_) => Navigator.of(context).pop(),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Pronto'),
          ),
        ],
      ),
    );
  }
}

/// Novo ajuste na estação, com modelos prontos (Banco, Encosto, Pino...).
Future<void> showNewSettingSheet(
  BuildContext context, {
  required String stationId,
  String? sessionId,
}) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _NewSettingSheet(stationId: stationId, sessionId: sessionId),
);

class _NewSettingSheet extends ConsumerStatefulWidget {
  const _NewSettingSheet({required this.stationId, this.sessionId});
  final String stationId;
  final String? sessionId;

  @override
  ConsumerState<_NewSettingSheet> createState() => _NewSettingSheetState();
}

class _NewSettingSheetState extends ConsumerState<_NewSettingSheet> {
  final _label = TextEditingController();
  final _value = TextEditingController();
  final _step = TextEditingController(text: '1');
  SettingKind _kind = SettingKind.number;

  @override
  void dispose() {
    _label.dispose();
    _value.dispose();
    _step.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final label = _label.text.trim();
    if (label.isEmpty) return;
    final number = _kind == SettingKind.number
        ? parseLoadMilli(_value.text)
        : null;
    final step = parseLoadMilli(_step.text) ?? 1000;
    await ref
        .read(stationRepositoryProvider)
        .addSetting(
          stationId: widget.stationId,
          label: label,
          kind: _kind,
          valueNum: number == null ? null : number / 1000,
          valueText: _kind == SettingKind.text ? _value.text.trim() : null,
          step: step <= 0 ? 1 : step / 1000,
          sessionId: widget.sessionId,
        );
    if (mounted) Navigator.of(context).pop();
  }

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
            Text('Novo ajuste', style: context.texts.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final p in settingPresets)
                  ActionChip(
                    label: Text(p.label),
                    onPressed: () => setState(() {
                      _label.text = p.label;
                      _kind = p.kind;
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _label,
              maxLength: 40,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Nome do ajuste'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
            SegmentedButton<SettingKind>(
              segments: const [
                ButtonSegment(
                  value: SettingKind.number,
                  label: Text('Número'),
                  icon: Icon(Icons.pin_outlined),
                ),
                ButtonSegment(
                  value: SettingKind.text,
                  label: Text('Texto'),
                  icon: Icon(Icons.short_text),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (s) => setState(() => _kind = s.first),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _value,
                    keyboardType: _kind == SettingKind.number
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Valor atual',
                      hintText: _kind == SettingKind.number
                          ? 'Ex.: 7'
                          : 'Ex.: corda',
                    ),
                  ),
                ),
                if (_kind == SettingKind.number) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _step,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(labelText: 'Passo'),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _label.text.trim().isEmpty ? null : _save,
              child: const Text('Adicionar ajuste'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Os ajustes da estação como chips ("Banco 7 · Encosto 3"), sempre
/// visíveis antes da primeira série: você regula a máquina antes de sentar.
class StationSettingsStrip extends ConsumerWidget {
  const StationSettingsStrip({
    super.key,
    required this.stationId,
    this.sessionId,
  });
  final String stationId;
  final String? sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(stationSettingsProvider(stationId)).value ?? [];
    final changes = ref.watch(stationChangesProvider(stationId)).value ?? [];
    final since = changes.isEmpty ? null : changes.first.change.changedAt;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.tune, size: 16, color: context.colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              'AJUSTES',
              style: context.texts.labelSmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                letterSpacing: 1.1,
              ),
            ),
            const Spacer(),
            if (since != null)
              Text(
                'mudou em ${_shortDate(since)}',
                style: context.texts.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in settings)
              ActionChip(
                label: Text(
                  '${s.label} ${formatSettingValue(s)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFeatures: tabularFigures,
                  ),
                ),
                onPressed: () => showEditSettingSheet(
                  context,
                  ref,
                  setting: s,
                  sessionId: sessionId,
                ),
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(settings.isEmpty ? 'Anotar ajuste' : 'Ajuste'),
              onPressed: () => showNewSettingSheet(
                context,
                stationId: stationId,
                sessionId: sessionId,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

String _shortDate(DateTime d) {
  final l = d.toLocal();
  return '${l.day.toString().padLeft(2, '0')}/${l.month.toString().padLeft(2, '0')}';
}
