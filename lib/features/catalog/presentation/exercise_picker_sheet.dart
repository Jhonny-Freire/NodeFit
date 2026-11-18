import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/muscles.dart';
import '../../../core/utils/text_normalize.dart';
import '../../../core/widgets/common.dart';
import '../../gyms/data/station_repository.dart';
import '../data/catalog_repository.dart';
import 'muscle_groups.dart';

/// Escolher (ou criar) um exercício. Com [gymId], mostra primeiro os que
/// você fez por último nesta academia. Devolve null se cancelar.
Future<Exercise?> showExercisePicker(
  BuildContext context, {
  String? gymId,
  String title = 'Adicionar exercício',
}) => showModalBottomSheet<Exercise>(
  useRootNavigator: true,
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => _ExercisePicker(gymId: gymId, title: title),
);

/// Filtro "Meus" (exercícios criados por você).
const _mine = MuscleGroup('mine', 'Meus', {});

class _ExercisePicker extends ConsumerStatefulWidget {
  const _ExercisePicker({required this.gymId, required this.title});
  final String? gymId;
  final String title;

  @override
  ConsumerState<_ExercisePicker> createState() => _ExercisePickerState();
}

class _ExercisePickerState extends ConsumerState<_ExercisePicker> {
  final _search = TextEditingController();
  String _query = '';
  MuscleGroup? _group;

  /// Último resultado: a lista não pisca a cada letra digitada.
  List<Exercise> _last = const [];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    var name = _query.trim();
    if (name.isEmpty) {
      final typed = await showTextInputDialog(
        context,
        title: 'Novo exercício',
        hint: 'Ex.: Remada unilateral no banco',
        confirmLabel: 'Continuar',
        maxLength: 120,
      );
      if (typed == null || typed.trim().isEmpty || !mounted) return;
      name = typed.trim();
    }
    final kind = await showExerciseKindDialog(context);
    if (kind == null || !mounted) return;
    final created = await ref
        .read(catalogRepositoryProvider)
        .createExercise(
          name: name,
          equipmentType: kind.equipment,
          tracking: kind.tracking,
        );
    if (mounted) Navigator.of(context).pop(created);
  }

  void _pick(Exercise e) => Navigator.of(context).pop(e);

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(exerciseSearchProvider(_query));
    if (results.hasValue) _last = results.requireValue;
    final gymId = widget.gymId;
    final recents = gymId == null
        ? const <RecentExercise>[]
        : ref.watch(recentExercisesProvider(gymId)).value ?? const [];
    final done = gymId == null
        ? const <String>{}
        : ref.watch(doneExerciseIdsProvider(gymId)).value ?? const {};
    final normalized = normalizeForSearch(_query);
    final searching = normalized.isNotEmpty;

    var items = _last;
    final group = _group;
    if (group != null) {
      items = identical(group, _mine)
          ? items.where((e) => e.isCustom).toList()
          : items.where((e) => belongsTo(e, group)).toList();
      // Dentro do grupo, os que você já fez vêm primeiro.
      items.sort((a, b) {
        final d = (done.contains(b.id) ? 1 : 0) - (done.contains(a.id) ? 1 : 0);
        return d != 0 ? d : a.name.compareTo(b.name);
      });
    }

    final children = <Widget>[];
    if (searching) {
      // Os que já existem vêm antes; criar fica no fim (ou sozinho, se
      // a busca não achou nada).
      children.addAll([
        for (final e in items)
          _ExerciseTile(exercise: e, done: done.contains(e.id), onTap: _pick),
      ]);
      final exact = items.any((e) => normalizeForSearch(e.name) == normalized);
      if (!exact) {
        children.add(
          _CreateTile(label: 'Criar "${_query.trim()}"', onTap: _create),
        );
      }
    } else if (group != null) {
      children.addAll([
        for (final e in items)
          _ExerciseTile(exercise: e, done: done.contains(e.id), onTap: _pick),
      ]);
      if (items.isEmpty) {
        children.add(
          const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Nada aqui ainda.', textAlign: TextAlign.center),
          ),
        );
      }
    } else {
      // Sem busca nem filtro: recentes desta academia + tudo por grupo.
      if (recents.isNotEmpty) {
        children.add(const _Header('Recentes nesta academia'));
        children.addAll([
          for (final r in recents)
            _ExerciseTile(
              exercise: r.exercise,
              done: true,
              detail:
                  '${r.equipment == null ? 'Sem aparelho' : equipmentDisplayName(r.equipment)} · ${relativeDay(r.lastAt)}',
              onTap: _pick,
            ),
        ]);
      }
      for (final g in muscleGroups) {
        final inGroup = [
          for (final e in items)
            if (groupOf(e) == g) e,
        ];
        if (inGroup.isEmpty) continue;
        children.add(_Header(g.label));
        children.addAll([
          for (final e in inGroup)
            _ExerciseTile(exercise: e, done: done.contains(e.id), onTap: _pick),
        ]);
      }
      final others = [
        for (final e in items)
          if (groupOf(e) == null) e,
      ];
      if (others.isNotEmpty) {
        children.add(const _Header('Outros'));
        children.addAll([
          for (final e in others)
            _ExerciseTile(exercise: e, done: done.contains(e.id), onTap: _pick),
        ]);
      }
    }
    children.add(
      Padding(
        // Espaço para a barra de navegação do Android.
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          24 + MediaQuery.viewPaddingOf(context).bottom,
        ),
        child: OutlinedButton.icon(
          onPressed: _create,
          icon: const Icon(Icons.add),
          label: const Text('Não achou? Criar exercício'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(64, 52)),
        ),
      ),
    );

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.94,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(widget.title, style: context.texts.titleLarge),
                ),
                IconButton(
                  tooltip: 'Fechar',
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Buscar (ex.: extensora, supino, puxada)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _search.clear();
                          _query = '';
                        }),
                      ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                for (final g in [null, ...muscleGroups, _mine])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(g?.label ?? 'Todos'),
                      selected: identical(_group, g),
                      onSelected: (_) => setState(() => _group = g),
                    ),
                  ),
              ],
            ),
          ),
          if (results.isLoading && _last.isNotEmpty)
            const LinearProgressIndicator(minHeight: 2),
          Expanded(
            child: !results.hasValue && _last.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(controller: scroll, children: children),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
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
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.exercise,
    required this.done,
    required this.onTap,
    this.detail,
  });
  final Exercise exercise;
  final bool done;
  final ValueChanged<Exercise> onTap;

  /// Texto no lugar do padrão (ex.: o aparelho da última vez).
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final e = exercise;
    final subtitle =
        detail ??
        [e.equipmentType.label, ...muscleNames(e.primaryMuscles)].join(' · ');
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: done
              ? context.colors.primaryContainer
              : context.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          equipmentIcon(e.equipmentType),
          color: done
              ? context.colors.onPrimaryContainer
              : context.colors.onSurfaceVariant,
        ),
      ),
      title: Text(e.name),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: context.colors.onSurfaceVariant),
      ),
      trailing: done
          ? Icon(Icons.history, size: 20, color: context.colors.primary)
          : (e.isCustom
                ? Icon(
                    Icons.person_outline,
                    size: 20,
                    color: context.colors.onSurfaceVariant,
                  )
                : null),
      onTap: () => onTap(e),
    );
  }
}

class _CreateTile extends StatelessWidget {
  const _CreateTile({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.add, color: context.colors.onPrimary),
    ),
    title: Text(label),
    subtitle: const Text('Novo exercício seu'),
    onTap: onTap,
  );
}

/// Exercício novo, em linguagem de academia: com o que é feito e o que se
/// anota (carga × reps, só tempo, ou tempo e distância).
typedef ExerciseKind = ({EquipmentType equipment, TrackingType tracking});

Future<ExerciseKind?> showExerciseKindDialog(BuildContext context) {
  Widget option(
    BuildContext context,
    IconData icon,
    String label,
    ExerciseKind kind, {
    String? hint,
  }) => SimpleDialogOption(
    onPressed: () => Navigator.of(context).pop(kind),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              if (hint != null)
                Text(
                  hint,
                  style: context.texts.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );

  return showDialog<ExerciseKind>(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text('Como ele é feito?'),
      children: [
        for (final t in EquipmentType.values)
          option(context, equipmentIcon(t), t.label, (
            equipment: t,
            tracking: TrackingType.weightReps,
          )),
        const Divider(),
        option(context, Icons.timer_outlined, 'Por tempo', (
          equipment: EquipmentType.bodyweight,
          tracking: TrackingType.duration,
        ), hint: 'Prancha, isometria'),
        option(context, Icons.directions_run, 'Cardio', (
          equipment: EquipmentType.machine,
          tracking: TrackingType.cardio,
        ), hint: 'Tempo e distância: esteira, bike, elíptico'),
      ],
    ),
  );
}
