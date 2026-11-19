import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/domain/superset.dart';
import '../../../core/domain/workout_dates.dart';
import '../../../core/widgets/common.dart';
import '../../catalog/presentation/exercise_picker_sheet.dart';
import '../../gyms/data/gym_repository.dart';
import '../../gyms/presentation/equipment_picker_sheet.dart';
import '../../workout/data/workout_repository.dart';
import '../../workout/presentation/start_session.dart';
import '../../workout/presentation/widgets/session_exercise_card.dart'
    show supersetName;
import '../data/routine_repository.dart';
import 'routine_item_sheet.dart';

/// Monta a ficha (em casa): exercícios em ordem, com séries × reps,
/// descanso, aquecimentos e aparelho preferido.
class RoutineEditorScreen extends ConsumerWidget {
  const RoutineEditorScreen({super.key, required this.routineId});
  final String routineId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routine = ref.watch(routineProvider(routineId));
    return AsyncView(
      value: routine,
      builder: (r) {
        if (r == null || r.archivedAt != null) {
          return const Scaffold(
            body: EmptyState(
              icon: Icons.view_list_outlined,
              title: 'Ficha não encontrada',
            ),
          );
        }
        return _Editor(routine: r);
      },
    );
  }
}

class _Editor extends ConsumerWidget {
  const _Editor({required this.routine});
  final Routine routine;

  String? _gymId(WidgetRef ref) =>
      routine.gymId ?? ref.read(currentGymProvider).value?.id;

  Future<void> _addExercise(BuildContext context, WidgetRef ref) async {
    final gymId = _gymId(ref);
    if (gymId == null) return;
    final exercise = await showExercisePicker(
      context,
      gymId: gymId,
      title: 'Adicionar à ficha',
    );
    if (exercise == null || !context.mounted) return;
    final choice = await chooseEquipment(
      context,
      ref,
      gymId: gymId,
      exercise: exercise,
    );
    if (choice == null) return;
    await ref
        .read(routineRepositoryProvider)
        .addItem(
          routineId: routine.id,
          exerciseId: exercise.id,
          preferredEquipmentId: choice.equipmentId,
        );
  }

  Future<void> _start(BuildContext context, WidgetRef ref) async {
    final gymId = _gymId(ref);
    if (gymId == null) return;
    if (!await settleOpenSession(context, ref)) return;
    final rest = await ref.read(prefsRepositoryProvider).defaultRestSec();
    final id = await ref
        .read(workoutRepositoryProvider)
        .startFromRoutine(
          routineId: routine.id,
          gymId: gymId,
          defaultRestSec: rest,
        );
    if (context.mounted) await context.push(sessionPath(id));
  }

  Future<void> _menu(BuildContext context, WidgetRef ref, String v) async {
    final repo = ref.read(routineRepositoryProvider);
    switch (v) {
      case 'info':
        await showRoutineInfoSheet(context, routine: routine);
      case 'duplicate':
        final copy = await repo.duplicateRoutine(routine.id);
        if (context.mounted) {
          context.pushReplacement('/treinar/ficha/${copy.id}');
        }
      case 'archive':
        final ok = await showConfirmDialog(
          context,
          title: 'Arquivar ${routineTitle(routine)}?',
          message:
              'Some da lista; os treinos feitos com ela continuam no '
              'histórico.',
          confirmLabel: 'Arquivar',
        );
        if (!ok) return;
        await repo.archiveRoutine(routine.id);
        if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(routineItemsProvider(routine.id));
    final gymId = _gymId(ref);
    final list = items.value ?? const <RoutineItemView>[];
    return Scaffold(
      appBar: AppBar(
        title: Text(routineTitle(routine)),
        actions: [
          IconButton(
            tooltip: 'Dados da ficha',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => showRoutineInfoSheet(context, routine: routine),
          ),
          PopupMenuButton<String>(
            onSelected: (v) => _menu(context, ref, v),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'info',
                child: Text('Nome, professor e vencimento'),
              ),
              PopupMenuItem(value: 'duplicate', child: Text('Duplicar ficha')),
              PopupMenuItem(value: 'archive', child: Text('Arquivar ficha')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addExercise(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Exercício'),
      ),
      bottomNavigationBar: list.isEmpty
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FilledButton(
                onPressed: () => _start(context, ref),
                style: FilledButton.styleFrom(minimumSize: const Size(64, 60)),
                child: const Text('INICIAR ESTA FICHA'),
              ),
            ),
      body: AsyncView(
        value: items,
        builder: (list) {
          final groups = [for (final v in list) v.item.supersetGroup];
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              _InfoCard(routine: routine),
              const SectionLabel(
                'Exercícios',
                trailing: Text('segure e arraste'),
              ),
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: EmptyState(
                    icon: Icons.playlist_add,
                    title: 'Ficha vazia',
                    message:
                        'Adicione os exercícios na ordem da ficha. Dica: copie '
                        'a ficha impressa da academia uma vez e anote os seus '
                        'ajustes por cima.',
                  ),
                )
              else
                Card(
                  child: ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    buildDefaultDragHandles: false,
                    onReorderItem: (from, to) {
                      final ids = [for (final v in list) v.item.id];
                      final moved = ids.removeAt(from);
                      ids.insert(to, moved);
                      ref
                          .read(routineRepositoryProvider)
                          .reorder(routine.id, ids);
                    },
                    children: [
                      for (var i = 0; i < list.length; i++)
                        ListTile(
                          key: ValueKey(list[i].item.id),
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                context.colors.surfaceContainerHigh,
                            child: Text('${i + 1}'),
                          ),
                          title: Text(list[i].exercise.name),
                          subtitle: Text(
                            [
                              if (supersetSlot(groups, i) case final slot?)
                                '${supersetName(slot.size)} ${slot.position}/${slot.size}',
                              list[i].prescription,
                              if (list[i].equipment != null)
                                list[i].equipment!.name,
                              ?list[i].item.notes,
                            ].join('\n'),
                            style: TextStyle(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          isThreeLine:
                              list[i].equipment != null ||
                              list[i].item.notes != null ||
                              groups[i] != null,
                          trailing: ReorderableDragStartListener(
                            index: i,
                            child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(Icons.drag_handle),
                            ),
                          ),
                          onTap: gymId == null
                              ? null
                              : () => showRoutineItemSheet(
                                  context,
                                  view: list[i],
                                  gymId: gymId,
                                  superset: supersetSlot(groups, i),
                                  hasNext: i < list.length - 1,
                                ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoCard extends ConsumerWidget {
  const _InfoCard({required this.routine});
  final Routine routine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expiry = expiryInfo(routine.expiresOn);
    // Datas do treino: o último feito (do histórico) e o próximo planejado.
    final lastDone = ref.watch(routineLastDoneProvider(routine.id)).value;
    final next = nextWorkoutInfo(routine.nextOn);
    final warn = expiry?.warn == true || next?.overdue == true;
    final lines = [
      if (routine.trainer != null) 'Professor: ${routine.trainer}',
      lastWorkoutText(lastDone) ?? 'Ainda não feita',
      next?.text ?? 'Próximo: sem data (toque para marcar)',
      ?expiry?.text,
      ?routine.notes,
    ];
    return Card(
      child: ListTile(
        leading: Icon(
          warn ? Icons.event_busy : Icons.event_note_outlined,
          color: warn ? context.semantic.attention : null,
        ),
        title: Text(lines.first),
        subtitle: lines.length > 1 ? Text(lines.skip(1).join('\n')) : null,
        onTap: () => showRoutineInfoSheet(context, routine: routine),
      ),
    );
  }
}

/// "Vence em 12 dias" / "Venceu em 03/10". [warn] quando faltam ≤14 dias.
({String text, bool warn})? expiryInfo(String? expiresOn) {
  if (expiresOn == null) return null;
  final date = DateTime.tryParse(expiresOn);
  if (date == null) return null;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final days = DateTime(
    date.year,
    date.month,
    date.day,
  ).difference(today).inDays;
  final fmt = DateFormat('dd/MM').format(date);
  if (days < 0) return (text: 'Venceu em $fmt', warn: true);
  if (days == 0) return (text: 'Vence hoje', warn: true);
  return (text: 'Vence em $days dia(s) ($fmt)', warn: days <= 14);
}

/// Nome, letra, professor, vencimento e observações da ficha.
Future<void> showRoutineInfoSheet(
  BuildContext context, {
  required Routine routine,
}) => showModalBottomSheet<void>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _InfoSheet(routine: routine),
);

class _InfoSheet extends ConsumerStatefulWidget {
  const _InfoSheet({required this.routine});
  final Routine routine;

  @override
  ConsumerState<_InfoSheet> createState() => _InfoSheetState();
}

class _InfoSheetState extends ConsumerState<_InfoSheet> {
  late final _name = TextEditingController(text: widget.routine.name);
  late final _label = TextEditingController(text: widget.routine.label ?? '');
  late final _trainer = TextEditingController(
    text: widget.routine.trainer ?? '',
  );
  late final _notes = TextEditingController(text: widget.routine.notes ?? '');
  late String? _expires = widget.routine.expiresOn;
  late String? _nextOn = widget.routine.nextOn;

  @override
  void dispose() {
    _name.dispose();
    _label.dispose();
    _trainer.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial =
        DateTime.tryParse(_expires ?? '') ?? now.add(const Duration(days: 60));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      setState(() => _expires = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  /// Data do próximo treino: aceita passado (para registrar um que já
  /// passou) e futuro.
  Future<void> _pickNextDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      helpText: 'Próximo treino',
      initialDate: DateTime.tryParse(_nextOn ?? '') ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked != null) {
      setState(() => _nextOn = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    await ref
        .read(routineRepositoryProvider)
        .updateRoutine(
          widget.routine.id,
          name: _name.text,
          label: _label.text,
          trainer: _trainer.text,
          expiresOn: _expires,
          nextOn: _nextOn,
          notes: _notes.text,
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Padding(
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
          Text('Dados da ficha', style: context.texts.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _label,
                  maxLength: 3,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Letra'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _name,
                  maxLength: 80,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    hintText: 'Ex.: Peito/Tríceps',
                  ),
                ),
              ),
            ],
          ),
          TextField(
            controller: _trainer,
            maxLength: 80,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Professor (opcional)',
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: const Text('Vencimento'),
            subtitle: Text(
              _expires == null
                  ? 'Sem vencimento'
                  : DateFormat('dd/MM/yyyy').format(DateTime.parse(_expires!)),
            ),
            trailing: _expires == null
                ? const Icon(Icons.chevron_right)
                : IconButton(
                    tooltip: 'Tirar vencimento',
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _expires = null),
                  ),
            onTap: _pickDate,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_available_outlined),
            title: const Text('Próximo treino'),
            subtitle: Text(
              nextWorkoutInfo(_nextOn)?.text ?? 'Sem data marcada',
            ),
            trailing: _nextOn == null
                ? const Icon(Icons.chevron_right)
                : IconButton(
                    tooltip: 'Tirar data do próximo treino',
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _nextOn = null),
                  ),
            onTap: _pickNextDate,
          ),
          TextField(
            controller: _notes,
            maxLength: 500,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Observações (opcional)',
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(onPressed: _save, child: const Text('Salvar')),
        ],
      ),
    ),
  );
}
