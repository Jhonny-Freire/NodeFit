import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/db/app_database.dart';
import '../../../../core/domain/enums.dart';
import '../../../../core/domain/cardio.dart';
import '../../../../core/domain/load.dart';
import '../../../../core/domain/progression.dart';
import '../../../../core/widgets/common.dart';
import '../../../catalog/presentation/exercise_picker_sheet.dart';
import '../../../gyms/data/station_repository.dart';
import '../../../gyms/presentation/equipment_picker_sheet.dart';
import '../../../gyms/presentation/setting_sheets.dart';
import '../../../gyms/presentation/station_detail_screen.dart';
import '../../data/workout_repository.dart';
import '../how_it_went_sheet.dart';

/// Um exercício do treino: ajustes (0 toques para ver), nota fixada,
/// última vez, e as séries com a coluna "Anterior".
class SessionExerciseCard extends ConsumerWidget {
  const SessionExerciseCard({
    super.key,
    required this.view,
    required this.sets,
    required this.session,
    required this.selectedSetId,
    required this.onSelectSet,
    required this.onCompleteSet,
    required this.onReplaced,
    this.superset,
    this.hasNext = false,
  });

  final SessionExerciseView view;

  /// Posição no bi-set/tri-set (null = exercício solo).
  final ({int position, int size})? superset;

  /// Tem exercício depois deste (dá para juntar num bi-set).
  final bool hasNext;
  final List<WorkoutSet> sets;
  final WorkoutSession session;
  final String? selectedSetId;
  final ValueChanged<WorkoutSet> onSelectSet;

  /// Concluir fica num lugar só (a tela do treino): validação, vibração,
  /// descanso, próxima série e "Desfazer".
  final void Function(WorkoutSet set) onCompleteSet;

  /// Trocou aparelho/exercício: o item ativo pode ser outro (id novo).
  final ValueChanged<String> onReplaced;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = view.item;
    final previous = ref
        .watch(
          previousPerformanceProvider(
            stationId: view.station.id,
            sessionId: session.id,
            exerciseId: view.exercise.id,
            gymId: session.gymId,
          ),
        )
        .value;
    // A coluna "Anterior" só usa a MESMA estação; outro aparelho é só a
    // linha de referência.
    final anterior = (previous == null || previous.fromOtherEquipment)
        ? const <WorkoutSet>[]
        : previous.sets;
    final allDone = sets.isNotEmpty && sets.every((s) => s.completedAt != null);

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 4, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (superset case final slot?)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${supersetName(slot.size)} · ${slot.position}/${slot.size}',
                            style: context.texts.labelMedium?.copyWith(
                              color: context.semantic.attention,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      Row(
                        children: [
                          if (allDone)
                            Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(
                                Icons.check_circle,
                                size: 20,
                                color: context.colors.primary,
                              ),
                            ),
                          Flexible(
                            child: Text(
                              view.exercise.name,
                              style: context.texts.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        [
                          view.equipmentName,
                          // Passo e carga por lado só fazem sentido com carga.
                          if (view.exercise.tracking ==
                              TrackingType.weightReps) ...[
                            'passo ${formatLoad(item.incrementMilli, item.loadUnit)}',
                            if (item.loadBasis != LoadBasis.total)
                              item.loadBasis.label.toLowerCase(),
                          ],
                          if (item.restSec > 0) 'descanso ${item.restSec}s',
                        ].join(' · '),
                        style: context.texts.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _CardMenu(
                  view: view,
                  session: session,
                  hasDoneSets: sets.any((s) => s.completedAt != null),
                  onReplaced: onReplaced,
                  inSuperset: superset != null,
                  canLinkNext:
                      hasNext &&
                      (superset == null ||
                          superset!.position == superset!.size),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: StationSettingsStrip(
                stationId: view.station.id,
                sessionId: session.id,
              ),
            ),
            if (view.station.pinnedNote != null)
              _NoteLine(
                icon: Icons.push_pin,
                text: view.station.pinnedNote!,
                onTap: () => editPinnedNote(context, ref, view.station),
              ),
            if (item.targetSets != null)
              _TargetLine(
                item: item,
                tracking: view.exercise.tracking,
                previous: previous,
                routineItem: view.routineItem,
              ),
            if (previous != null)
              _PreviousLine(
                previous: previous,
                currentUnit: item.loadUnit,
                tracking: view.exercise.tracking,
              ),
            if (item.howItWent != null || item.effortTag != null || item.pain)
              _NoteLine(
                icon: Icons.edit_note,
                text: [
                  'Hoje:',
                  ?item.effortTag?.label,
                  if (item.pain) 'dor',
                  ?item.howItWent,
                ].join(' '),
                onTap: () => showHowItWentSheet(
                  context,
                  ref,
                  item: item,
                  exerciseName: view.exercise.name,
                ),
              ),
            const SizedBox(height: 8),
            _SetsHeader(unit: item.loadUnit, tracking: view.exercise.tracking),
            for (var i = 0; i < sets.length; i++)
              _SetRow(
                set: sets[i],
                index: workingNumber(sets, sets[i]) - 1,
                previous: i < anterior.length ? anterior[i] : null,
                previousUnit: previous?.unit ?? item.loadUnit,
                unit: item.loadUnit,
                tracking: view.exercise.tracking,
                selected: sets[i].id == selectedSetId,
                onTap: () => onSelectSet(sets[i]),
                onComplete: () => onCompleteSet(sets[i]),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(workoutRepositoryProvider).addSet(item.id),
                    icon: const Icon(Icons.add),
                    label: const Text('Série'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => showHowItWentSheet(
                      context,
                      ref,
                      item: item,
                      exerciseName: view.exercise.name,
                    ),
                    icon: const Icon(Icons.edit_note),
                    label: const Text('Como foi?'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> editPinnedNote(
  BuildContext context,
  WidgetRef ref,
  Station station,
) async {
  final repo = ref.read(stationRepositoryProvider);
  final text = await showTextInputDialog(
    context,
    title: 'Nota fixada',
    initial: station.pinnedNote,
    hint: 'Ex.: escápula travada, não travar o cotovelo',
    maxLines: 3,
    allowEmpty: true,
    maxLength: 300,
  );
  if (text != null) await repo.updatePinnedNote(station.id, text);
}

/// "BI-SET", "TRI-SET" ou "CIRCUITO" (4 ou mais).
String supersetName(int size) => switch (size) {
  2 => 'BI-SET',
  3 => 'TRI-SET',
  _ => 'CIRCUITO',
};

enum _MenuAction {
  linkNext,
  unlink,
  swapEquipment,
  swapExercise,
  history,
  pinned,
  howItWent,
  rest,
  remove,
}

class _CardMenu extends ConsumerWidget {
  const _CardMenu({
    required this.view,
    required this.session,
    required this.hasDoneSets,
    required this.onReplaced,
    required this.inSuperset,
    required this.canLinkNext,
  });
  final SessionExerciseView view;
  final WorkoutSession session;
  final bool hasDoneSets;
  final ValueChanged<String> onReplaced;
  final bool inSuperset;
  final bool canLinkNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PopupMenuItem<_MenuAction> entry(_MenuAction a, IconData icon, String t) =>
        PopupMenuItem(
          value: a,
          child: ListTile(leading: Icon(icon), title: Text(t)),
        );
    return PopupMenuButton<_MenuAction>(
      tooltip: 'Opções do exercício',
      onSelected: (a) => _run(context, ref, a),
      itemBuilder: (_) => [
        if (canLinkNext)
          entry(_MenuAction.linkNext, Icons.link, 'Bi-set com o próximo'),
        if (inSuperset)
          entry(_MenuAction.unlink, Icons.link_off, 'Tirar do bi-set'),
        entry(
          _MenuAction.swapEquipment,
          Icons.swap_horiz,
          'Trocar aparelho (ocupado)',
        ),
        entry(_MenuAction.swapExercise, Icons.swap_vert, 'Trocar exercício'),
        entry(_MenuAction.history, Icons.history, 'Ver ajustes e histórico'),
        entry(_MenuAction.pinned, Icons.push_pin_outlined, 'Nota fixada'),
        entry(_MenuAction.howItWent, Icons.edit_note, 'Como foi?'),
        entry(
          _MenuAction.rest,
          Icons.timer_outlined,
          'Descanso deste exercício',
        ),
        entry(_MenuAction.remove, Icons.delete_outline, 'Remover do treino'),
      ],
    );
  }

  Future<void> _run(BuildContext context, WidgetRef ref, _MenuAction a) async {
    final repo = ref.read(workoutRepositoryProvider);
    switch (a) {
      case _MenuAction.linkNext:
        await repo.linkSupersetWithNext(view.item.id);
      case _MenuAction.unlink:
        await repo.unlinkSuperset(view.item.id);
      case _MenuAction.swapEquipment:
        final pick = await showEquipmentPicker(
          context,
          gymId: session.gymId,
          exercise: view.exercise,
          currentEquipmentId: view.equipment?.id,
        );
        if (pick == null) return;
        onReplaced(await repo.swapEquipment(view.item.id, pick.equipmentId));
        if (hasDoneSets && context.mounted) {
          showSnack(
            context,
            'As séries feitas ficaram no aparelho anterior; o novo entrou logo abaixo.',
          );
        }
      case _MenuAction.swapExercise:
        final exercise = await showExercisePicker(
          context,
          gymId: session.gymId,
          title: 'Trocar por',
        );
        if (exercise == null || !context.mounted) return;
        final choice = await chooseEquipment(
          context,
          ref,
          gymId: session.gymId,
          exercise: exercise,
        );
        if (choice == null) return;
        onReplaced(
          await repo.swapExercise(
            view.item.id,
            exerciseId: exercise.id,
            equipmentId: choice.equipmentId,
          ),
        );
      case _MenuAction.history:
        // Rota imperativa no navegador raiz: o treino continua por baixo.
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => StationDetailScreen(stationId: view.station.id),
          ),
        );
      case _MenuAction.pinned:
        await editPinnedNote(context, ref, view.station);
      case _MenuAction.howItWent:
        await showHowItWentSheet(
          context,
          ref,
          item: view.item,
          exerciseName: view.exercise.name,
        );
      case _MenuAction.rest:
        final sec = await showRestPicker(context, current: view.item.restSec);
        if (sec != null) await repo.updateRestSec(view.item.id, sec);
      case _MenuAction.remove:
        final ok =
            !hasDoneSets ||
            await showConfirmDialog(
              context,
              title: 'Remover ${view.exercise.name}?',
              message: 'As séries já feitas deste exercício serão apagadas.',
              confirmLabel: 'Remover',
              destructive: true,
            );
        if (ok) await repo.removeExercise(view.item.id);
    }
  }
}

const restOptions = [30, 45, 60, 75, 90, 120, 150, 180, 240, 300];

Future<int?> showRestPicker(
  BuildContext context, {
  required int current,
}) => showDialog<int>(
  context: context,
  builder: (context) => SimpleDialog(
    title: const Text('Descanso'),
    children: [
      for (final s in restOptions)
        SimpleDialogOption(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          onPressed: () => Navigator.of(context).pop(s),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  s < 60
                      ? '$s s'
                      : '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')} min',
                ),
              ),
              if (s == current) const Icon(Icons.check),
            ],
          ),
        ),
    ],
  ),
);

class _NoteLine extends StatelessWidget {
  const _NoteLine({required this.icon, required this.text, this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 12, 12, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: context.semantic.attention),
            const SizedBox(width: 6),
            Expanded(child: Text(text, style: context.texts.bodyMedium)),
          ],
        ),
      ),
    ),
  );
}

/// Ficha: "Alvo 3 × 8–12 · Sugestão: 42,5 kg × 8" + observação/cadência.
class _TargetLine extends StatelessWidget {
  const _TargetLine({
    required this.item,
    required this.tracking,
    required this.previous,
    required this.routineItem,
  });
  final SessionExercise item;
  final TrackingType tracking;
  final PreviousPerformance? previous;
  final RoutineExercise? routineItem;

  @override
  Widget build(BuildContext context) {
    final reps = switch ((item.repMin, item.repMax)) {
      (final a?, final b?) when a != b => '$a–$b',
      (final a?, _) => '$a',
      (_, final b?) => '$b',
      _ => null,
    };
    // Prancha e cardio: a ficha só diz quantas vezes.
    final target = tracking == TrackingType.weightReps
        ? 'Alvo ${item.targetSets} × ${reps ?? '?'}'
        : 'Alvo ${item.targetSets}×';
    String? suggestion;
    final p = previous;
    if (p != null &&
        !p.fromOtherEquipment &&
        p.unit == item.loadUnit &&
        item.repMin != null &&
        item.repMax != null) {
      final done = [
        for (final s in p.sets)
          if (s.setType != SetType.warmup &&
              s.loadMilli != null &&
              s.reps != null)
            (loadMilli: s.loadMilli!, reps: s.reps!),
      ];
      final next = doubleProgression(
        lastWorkingSets: done,
        repMin: item.repMin!,
        repMax: item.repMax!,
        incrementMilli: item.incrementMilli,
      );
      if (next.isNotEmpty) {
        final up = next.first.loadMilli > done.first.loadMilli;
        suggestion =
            '${up ? '↑ ' : ''}${formatLoad(next.first.loadMilli, item.loadUnit)} × ${next.first.reps}';
      }
    }
    final extra = [
      ?routineItem?.notes,
      if (routineItem?.tempo != null) 'cadência ${routineItem!.tempo}',
    ].join(' · ');
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: target,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (suggestion != null) ...[
                  const TextSpan(text: '  ·  Sugestão: '),
                  TextSpan(
                    text: suggestion,
                    style: TextStyle(
                      color: context.colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
            style: context.texts.bodyMedium,
          ),
          if (extra.isNotEmpty)
            Text(
              'Ficha: $extra',
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// "Última vez (09/10): 40×12 · 40×11" + a nota em cinza.
class _PreviousLine extends StatelessWidget {
  const _PreviousLine({
    required this.previous,
    required this.currentUnit,
    required this.tracking,
  });
  final PreviousPerformance previous;
  final LoadUnit currentUnit;
  final TrackingType tracking;

  @override
  Widget build(BuildContext context) {
    final muted = context.colors.onSurfaceVariant;
    final date = DateFormat('dd/MM').format(previous.startedAt.toLocal());
    // Unidade diferente (outro aparelho, ou o aparelho mudou): mostra a
    // unidade, para "8" não parecer "8 kg".
    final showUnit =
        previous.fromOtherEquipment || previous.unit != currentUnit;
    final sets = previous.sets
        .where((s) => s.setType != SetType.warmup)
        .map(
          (s) => formatSetShort(
            tracking: tracking,
            unit: previous.unit,
            loadMilli: s.loadMilli,
            reps: s.reps,
            durationSec: s.durationSec,
            distanceM: s.distanceM,
            withUnit: showUnit,
          ),
        )
        .join(' · ');
    final note = [
      ?previous.effortTag?.label,
      if (previous.pain) 'dor',
      if (previous.howItWent != null) '"${previous.howItWent}"',
    ].join(' ');
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            previous.fromOtherEquipment
                ? 'Referência — outro aparelho (${previous.otherEquipmentName}), $date: $sets'
                : 'Última vez ($date): $sets',
            style: context.texts.bodySmall?.copyWith(color: muted),
          ),
          if (note.isNotEmpty)
            Text(
              note,
              style: context.texts.bodySmall?.copyWith(
                color: muted,
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}

/// Os dois números de cada série, conforme o que o exercício anota.
({String first, String second}) _columnTitles(
  TrackingType tracking,
  LoadUnit unit,
) => switch (tracking) {
  TrackingType.weightReps => (first: unit.label.toUpperCase(), second: 'REPS'),
  TrackingType.duration => (first: 'TEMPO', second: ''),
  TrackingType.cardio => (first: 'TEMPO', second: 'KM'),
};

({String first, String second}) _columnValues(
  TrackingType tracking,
  WorkoutSet s,
) => switch (tracking) {
  TrackingType.weightReps => (
    first: formatLoadValue(s.loadMilli),
    second: [
      s.reps?.toString() ?? '—',
      if (s.rir != null) 'R${formatNumber(s.rir!)}',
    ].join(' '),
  ),
  TrackingType.duration => (first: formatSeconds(s.durationSec), second: ''),
  TrackingType.cardio => (
    first: formatSeconds(s.durationSec),
    second: formatKmValue(s.distanceM),
  ),
};

class _SetsHeader extends StatelessWidget {
  const _SetsHeader({required this.unit, required this.tracking});
  final LoadUnit unit;
  final TrackingType tracking;

  @override
  Widget build(BuildContext context) {
    final style = context.texts.labelSmall?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 2),
      child: Row(
        children: [
          SizedBox(width: 48, child: Text('#', style: style)),
          Expanded(flex: 3, child: Text('ANTERIOR', style: style)),
          Expanded(
            flex: 2,
            child: Text(_columnTitles(tracking, unit).first, style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(_columnTitles(tracking, unit).second, style: style),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SetRow extends ConsumerWidget {
  const _SetRow({
    required this.set,
    required this.index,
    required this.previous,
    required this.previousUnit,
    required this.unit,
    required this.tracking,
    required this.selected,
    required this.onTap,
    required this.onComplete,
  });

  final WorkoutSet set;
  final TrackingType tracking;
  final int index;
  final WorkoutSet? previous;
  final LoadUnit previousUnit;
  final LoadUnit unit;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(workoutRepositoryProvider);
    final done = set.completedAt != null;
    final sameUnit = previousUnit == unit;
    final prev = previous;
    final valueStyle = context.texts.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      fontFeatures: tabularFigures,
      color: done ? context.colors.onSurfaceVariant : context.colors.onSurface,
    );
    return Material(
      color: selected
          ? context.colors.primaryContainer.withValues(alpha: 0.55)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        onLongPress: () => _delete(context, ref),
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _setMenu(context, ref),
                  child: Center(
                    child: Text(
                      set.setType.badge.isEmpty
                          ? '${index + 1}'
                          : set.setType.badge,
                      style: context.texts.titleSmall?.copyWith(
                        color: set.setType == SetType.working
                            ? context.colors.onSurface
                            : context.semantic.attention,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: InkWell(
                  // Tocar no "Anterior" copia para a série (a carga só se a
                  // unidade for a mesma).
                  onTap: prev == null || done
                      ? null
                      : () => repo.updateSet(
                          set.id,
                          loadMilli: sameUnit
                              ? Value(prev.loadMilli)
                              : const Value.absent(),
                          reps: Value(prev.reps),
                          durationSec: Value(prev.durationSec),
                          distanceM: Value(prev.distanceM),
                        ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 48),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        prev == null
                            ? '—'
                            : formatSetShort(
                                tracking: tracking,
                                unit: previousUnit,
                                loadMilli: prev.loadMilli,
                                reps: prev.reps,
                                durationSec: prev.durationSec,
                                distanceM: prev.distanceM,
                                withUnit: !sameUnit,
                              ),
                        style: context.texts.bodyMedium?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          fontFeatures: tabularFigures,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _columnValues(tracking, set).first,
                  style: valueStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  _columnValues(tracking, set).second,
                  style: valueStyle,
                ),
              ),
              IconButton(
                // Série feita: tocar seleciona (para corrigir). Desmarcar fica
                // no menu do número da série — um toque acidental não apaga.
                tooltip: done ? 'Série concluída' : 'Concluir série',
                onPressed: done ? onTap : onComplete,
                icon: Icon(
                  done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: done
                      ? context.colors.primary
                      : context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setMenu(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(workoutRepositoryProvider);
    final done = set.completedAt != null;
    final choice = await showModalBottomSheet<Object>(
      useRootNavigator: true,
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final t in SetType.values)
              ListTile(
                leading: Text(
                  t.badge.isEmpty ? '#' : t.badge,
                  style: context.texts.titleMedium,
                ),
                title: Text(t.label),
                subtitle: t == SetType.warmup
                    ? const Text('Não conta para recordes nem volume')
                    : null,
                trailing: t == set.setType ? const Icon(Icons.check) : null,
                onTap: () => Navigator.of(context).pop(t),
              ),
            if (done) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text('Desmarcar série'),
                subtitle: const Text('Volta a ser uma série não feita'),
                onTap: () => Navigator.of(context).pop('uncomplete'),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Apagar série'),
              onTap: () => Navigator.of(context).pop('delete'),
            ),
          ],
        ),
      ),
    );
    if (choice is SetType) {
      await repo.updateSet(set.id, setType: Value(choice));
    } else if (choice == 'uncomplete') {
      await repo.uncompleteSet(set.id);
    } else if (choice == 'delete' && context.mounted) {
      await _delete(context, ref);
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(workoutRepositoryProvider);
    final removed = await repo.deleteSet(set.id);
    if (removed == null || !context.mounted) return;
    showSnack(
      context,
      'Série apagada',
      actionLabel: 'Desfazer',
      onAction: () => repo.restoreSet(removed),
      duration: const Duration(seconds: 5),
    );
  }
}

/// Número da série contando só as de trabalho (aquecimento é "A"):
/// aquecimento + 3 séries aparece como A, 1, 2, 3.
int workingNumber(List<WorkoutSet> sets, WorkoutSet set) {
  var n = 0;
  for (final s in sets) {
    if (s.setType != SetType.warmup) n++;
    if (s.id == set.id) return s.setType == SetType.warmup ? 0 : n;
  }
  return 0;
}
