import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/domain/workout_dates.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/common.dart';
import '../../backup/restore_flow.dart';
import '../../gyms/data/gym_repository.dart';
import '../../gyms/presentation/gym_switcher.dart';
import '../../routines/data/routine_repository.dart';
import '../../routines/presentation/routine_editor_screen.dart' show expiryInfo;
import '../data/workout_repository.dart';
import 'start_session.dart';
import 'widgets/elapsed_text.dart';

/// Ficha vencida (ou perto) ou com o próximo treino já passado.
bool _needsAttention(RoutineSummary r) =>
    expiryInfo(r.routine.expiresOn)?.warn == true ||
    nextWorkoutInfo(r.routine.nextOn)?.overdue == true;

/// Aba Treinar: começar (ou continuar) o treino em 1 toque.
class TrainHomeScreen extends ConsumerWidget {
  const TrainHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gyms = ref.watch(gymsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinar'),
        actions: const [GymSwitcher()],
      ),
      body: AsyncView(
        value: gyms,
        builder: (list) =>
            list.isEmpty ? const _Welcome() : const _TrainHomeBody(),
      ),
    );
  }
}

class _TrainHomeBody extends ConsumerWidget {
  const _TrainHomeBody();

  Future<void> _startFree(BuildContext context, WidgetRef ref, Gym gym) async {
    if (!await settleOpenSession(context, ref)) return;
    final id = await ref
        .read(workoutRepositoryProvider)
        .startFreeSession(gymId: gym.id);
    if (context.mounted) await context.push(sessionPath(id));
  }

  Future<void> _startRoutine(
    BuildContext context,
    WidgetRef ref,
    Gym gym,
    Routine routine,
  ) async {
    if (!await settleOpenSession(context, ref)) return;
    final rest = await ref.read(prefsRepositoryProvider).defaultRestSec();
    final id = await ref
        .read(workoutRepositoryProvider)
        .startFromRoutine(
          routineId: routine.id,
          gymId: gym.id,
          defaultRestSec: rest,
        );
    if (context.mounted) await context.push(sessionPath(id));
  }

  Future<void> _newRoutine(
    BuildContext context,
    WidgetRef ref,
    Gym gym,
    int existing,
  ) async {
    final name = await showTextInputDialog(
      context,
      title: 'Nova ficha',
      hint: 'Ex.: Peito/Tríceps',
      confirmLabel: 'Criar',
      maxLength: 80,
    );
    if (name == null || name.trim().isEmpty) return;
    // Letra automática: A, B, C... (dá para mudar depois).
    final label = existing < 26 ? String.fromCharCode(65 + existing) : null;
    final routine = await ref
        .read(routineRepositoryProvider)
        .createRoutine(name: name, label: label, gymId: gym.id);
    if (context.mounted) await context.push('/treinar/ficha/${routine.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeSessionProvider).value;
    final gym = ref.watch(currentGymProvider).value;
    final history = ref.watch(historyProvider).value ?? const [];
    final last = history.isEmpty ? null : history.first;
    final routines = gym == null
        ? const <RoutineSummary>[]
        : ref.watch(gymRoutinesProvider(gym.id)).value ?? const [];
    final next = gym == null
        ? null
        : ref.watch(nextRoutineProvider(gym.id)).value;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (active != null)
          _BigCard(
            icon: Icons.play_circle_fill,
            title: 'Treino em andamento',
            subtitle: Row(
              children: [
                const Text('Começou há '),
                ElapsedText(since: active.startedAt),
              ],
            ),
            buttonLabel: 'CONTINUAR TREINO',
            onPressed: () => context.push(sessionPath(active.id)),
          )
        else if (gym != null && next != null)
          _BigCard(
            icon: Icons.fitness_center,
            title: 'Próxima: ${next.title}',
            subtitle: Text(
              [
                plural(next.exerciseCount, 'exercício', 'exercícios'),
                if (next.lastDoneAt != null)
                  'última: ${DateFormat('EEE dd/MM').format(next.lastDoneAt!.toLocal())}',
                ?nextWorkoutInfo(next.routine.nextOn)?.text,
                ?expiryInfo(next.routine.expiresOn)?.text,
              ].join(' · '),
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
            buttonLabel: 'INICIAR FICHA',
            onPressed: () => _startRoutine(context, ref, gym, next.routine),
          )
        else if (gym != null)
          _BigCard(
            icon: Icons.fitness_center,
            title: 'Treino livre',
            subtitle: Text(
              'Adicione os exercícios na hora. Os ajustes e as cargas da '
              'última vez aparecem sozinhos.',
              style: TextStyle(color: context.colors.onSurfaceVariant),
            ),
            buttonLabel: 'INICIAR TREINO',
            onPressed: () => _startFree(context, ref, gym),
          ),
        if (gym != null) ...[
          SectionLabel(
            'Fichas',
            trailing: TextButton.icon(
              onPressed: () => _newRoutine(context, ref, gym, routines.length),
              icon: const Icon(Icons.add),
              label: const Text('Nova ficha'),
            ),
          ),
          if (routines.isEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.view_list_outlined),
                title: const Text('Monte suas fichas A/B/C'),
                subtitle: const Text(
                  'Digite a ficha da academia uma vez; depois é iniciar o '
                  'treino do dia em 1 toque, com as cargas sugeridas.',
                ),
                onTap: () => _newRoutine(context, ref, gym, 0),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final r in routines)
                    ListTile(
                      title: Text(r.title),
                      // Linha 1: exercícios e vencimento.
                      // Linha 2: último treino feito e próximo planejado.
                      subtitle: Text(
                        [
                          [
                            plural(r.exerciseCount, 'exercício', 'exercícios'),
                            ?expiryInfo(r.routine.expiresOn)?.text,
                          ].join(' · '),
                          [
                            ?lastWorkoutText(r.lastDoneAt),
                            ?nextWorkoutInfo(r.routine.nextOn)?.text,
                          ].join(' · '),
                        ].where((l) => l.isNotEmpty).join('\n'),
                        style: TextStyle(
                          color: _needsAttention(r)
                              ? context.semantic.attention
                              : context.colors.onSurfaceVariant,
                        ),
                      ),
                      onTap: () =>
                          context.push('/treinar/ficha/${r.routine.id}'),
                      trailing: active != null || r.exerciseCount == 0
                          ? const Icon(Icons.chevron_right)
                          : IconButton.filledTonal(
                              tooltip: 'Iniciar ${r.title}',
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () =>
                                  _startRoutine(context, ref, gym, r.routine),
                            ),
                    ),
                ],
              ),
            ),
          if (active == null && next != null) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _startFree(context, ref, gym),
              icon: const Icon(Icons.bolt),
              label: const Text('Treino livre (sem ficha)'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(64, 52)),
            ),
          ],
        ],
        if (last != null) ...[
          const SectionLabel('Último treino'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: Text(
                DateFormat("EEEE, d 'de' MMMM")
                    .format(last.session.startedAt.toLocal()),
              ),
              subtitle: Text(
                '${last.session.title} · '
                '${plural(last.exerciseCount, 'exercício', 'exercícios')} · '
                '${plural(last.setCount, 'série', 'séries')}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/progresso/sessao/${last.session.id}'),
            ),
          ),
        ],
      ],
    );
  }
}

class _BigCard extends StatelessWidget {
  const _BigCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
  });
  final IconData icon;
  final String title;
  final Widget subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: context.colors.primary, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: context.texts.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DefaultTextStyle.merge(
            style: context.texts.bodyMedium,
            child: subtitle,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(minimumSize: const Size(64, 64)),
            child: Text(buttonLabel),
          ),
        ],
      ),
    ),
  );
}

/// Primeira execução: só o nome da academia. Sem conta, sem senha.
class _Welcome extends ConsumerStatefulWidget {
  const _Welcome();

  @override
  ConsumerState<_Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<_Welcome> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final gym = await ref.read(gymRepositoryProvider).createGym(name);
    await ref.read(prefsRepositoryProvider).set(PrefKeys.currentGymId, gym.id);
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Icon(Icons.menu_book, size: 56, color: context.colors.primary),
      const SizedBox(height: 16),
      Text(
        'Seu caderno de treino',
        style: context.texts.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Cargas, repetições, como foi o exercício e como você deixa cada '
        'máquina ajustada. Tudo fica no celular e funciona sem internet.',
        style: context.texts.bodyLarge?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      const SizedBox(height: 28),
      TextField(
        controller: _name,
        maxLength: 80,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(
          labelText: 'Onde você treina?',
          hintText: 'Ex.: Academia do bairro',
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _create(),
      ),
      const SizedBox(height: 16),
      FilledButton(
        onPressed: _name.text.trim().isEmpty ? null : _create,
        child: const Text('COMEÇAR'),
      ),
      const SizedBox(height: 8),
      // Restaurar lê um .zip do celular: só no app Android.
      if (!kIsWeb)
        TextButton.icon(
          onPressed: () => restoreFromBackupFlow(context, ref),
          icon: const Icon(Icons.settings_backup_restore),
          label: const Text('Já tenho um backup: restaurar'),
        ),
      const SizedBox(height: 4),
      Text(
        'Dá para cadastrar outras academias (e "Casa") depois.',
        textAlign: TextAlign.center,
        style: context.texts.bodySmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    ],
  );
}
