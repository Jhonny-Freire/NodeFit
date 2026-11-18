import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';
import '../../../core/widgets/common.dart';
import '../data/workout_repository.dart';

/// "Como foi?" — texto livre + 1 toque (fácil/ok/difícil, dor). Salva
/// SOZINHO ao fechar (como os ajustes): marcar a tag custa 2 toques. Volta em
/// cinza na próxima vez nesta estação.
Future<void> showHowItWentSheet(
  BuildContext context,
  WidgetRef ref, {
  required SessionExercise item,
  required String exerciseName,
}) async {
  final repo = ref.read(workoutRepositoryProvider); // antes do await
  final draft = _Draft(item.howItWent ?? '', item.effortTag, item.pain);
  await showModalBottomSheet<void>(
    useRootNavigator: true,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _HowItWentSheet(draft: draft, exerciseName: exerciseName),
  );
  final changed =
      draft.text.trim() != (item.howItWent ?? '') ||
      draft.tag != item.effortTag ||
      draft.pain != item.pain;
  if (changed) {
    await repo.updateHowItWent(
      item.id,
      text: draft.text,
      tag: draft.tag,
      pain: draft.pain,
    );
  }
}

class _Draft {
  _Draft(this.text, this.tag, this.pain);
  String text;
  EffortTag? tag;
  bool pain;
}

class _HowItWentSheet extends StatefulWidget {
  const _HowItWentSheet({required this.draft, required this.exerciseName});
  final _Draft draft;
  final String exerciseName;

  @override
  State<_HowItWentSheet> createState() => _HowItWentSheetState();
}

class _HowItWentSheetState extends State<_HowItWentSheet> {
  late final _text = TextEditingController(text: widget.draft.text);

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.draft;
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
            Text('Como foi?', style: context.texts.titleLarge),
            Text(
              '${widget.exerciseName} · salva sozinho ao fechar',
              style: context.texts.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final t in EffortTag.values)
                  ChoiceChip(
                    label: Text(t.label),
                    selected: d.tag == t,
                    onSelected: (on) => setState(() => d.tag = on ? t : null),
                  ),
                FilterChip(
                  label: const Text('Dor / incômodo'),
                  selected: d.pain,
                  selectedColor: context.colors.error.withValues(alpha: 0.25),
                  onSelected: (on) => setState(() => d.pain = on),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _text,
              maxLines: 3,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Ex.: 3ª série pesada, ombro E incomodou',
              ),
              onChanged: (v) => d.text = v,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Pronto'),
            ),
          ],
        ),
      ),
    );
  }
}
