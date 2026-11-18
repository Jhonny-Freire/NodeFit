import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/muscles.dart';
import '../../../core/widgets/common.dart';
import '../data/catalog_repository.dart';
import 'exercise_picker_sheet.dart';

/// Catálogo de exercícios (embarcados + os seus).
class ExerciseListScreen extends ConsumerStatefulWidget {
  const ExerciseListScreen({super.key});

  @override
  ConsumerState<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends ConsumerState<ExerciseListScreen> {
  String _query = '';
  List<Exercise> _last = const [];

  Future<void> _create() async {
    final name = await showTextInputDialog(
      context,
      title: 'Novo exercício',
      hint: 'Ex.: Remada unilateral no banco',
      maxLength: 120,
    );
    if (name == null || name.trim().isEmpty || !mounted) return;
    final kind = await showExerciseKindDialog(context);
    if (kind == null) return;
    await ref
        .read(catalogRepositoryProvider)
        .createExercise(
          name: name,
          equipmentType: kind.equipment,
          tracking: kind.tracking,
        );
    if (mounted) showSnack(context, 'Exercício "$name" criado.');
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(exerciseSearchProvider(_query));
    if (results.hasValue) _last = results.requireValue;
    return Scaffold(
      appBar: AppBar(title: const Text('Exercícios')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: const Text('Exercício'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: AsyncView(
              value: results.hasValue || _last.isEmpty
                  ? results
                  : AsyncData(_last),
              builder: (items) => items.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'Nada encontrado',
                      message: 'Crie o exercício pelo botão abaixo.',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 96),
                      itemCount: items.length,
                      itemBuilder: (context, i) => _ExerciseTile(items[i]),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile(this.exercise);
  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final e = exercise;
    final primary = muscleNames(e.primaryMuscles);
    final secondary = muscleNames(e.secondaryMuscles);
    return ExpansionTile(
      title: Text(e.name),
      subtitle: Text(
        [e.equipmentType.label, ...primary].join(' · '),
        style: TextStyle(color: context.colors.onSurfaceVariant),
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [
        if (secondary.isNotEmpty) Text('Secundários: ${secondary.join(', ')}'),
        if (e.aliases.isNotEmpty) Text('Também chamado: ${e.aliases}'),
        if (e.isCustom) const Text('Criado por você.'),
      ],
    );
  }
}
