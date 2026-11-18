import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/db/app_database.dart';
import '../../../core/domain/cardio.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../../routines/data/routine_repository.dart';
import '../../workout/data/workout_repository.dart';
import '../../workout/presentation/widgets/elapsed_text.dart';

/// Um treino passado: resumo, séries e "salvar como ficha".
class SessionDetailScreen extends ConsumerWidget {
  const SessionDetailScreen({super.key, required this.sessionId});
  final String sessionId;

  /// O treino de hoje vira ficha: da próxima vez é só iniciar.
  Future<void> _saveAsRoutine(
    BuildContext context,
    WidgetRef ref,
    WorkoutSession session,
  ) async {
    final name = await showTextInputDialog(
      context,
      title: 'Salvar como ficha',
      initial: session.routineId == null ? null : session.title,
      hint: 'Ex.: Peito/Tríceps',
      confirmLabel: 'Salvar',
      maxLength: 80,
    );
    if (name == null || name.trim().isEmpty) return;
    final repo = ref.read(routineRepositoryProvider);
    final existing = (await repo.watchRoutines(session.gymId).first).length;
    // Letra automática, como em "Nova ficha".
    final label = existing < 26 ? String.fromCharCode(65 + existing) : null;
    final routine = await repo.saveSessionAsRoutine(
      sessionId: session.id,
      name: name,
      label: label,
    );
    if (context.mounted) context.go('/treinar/ficha/${routine.id}');
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Apagar este treino?',
      message: 'As séries deste dia somem do histórico. Não dá para desfazer.',
      confirmLabel: 'Apagar',
      destructive: true,
    );
    if (!ok) return;
    await ref.read(workoutRepositoryProvider).discardSession(sessionId);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider(sessionId)).value;
    final exercises =
        ref.watch(sessionExercisesProvider(sessionId)).value ?? const [];
    final sets = ref.watch(sessionSetsProvider(sessionId)).value ?? const {};
    if (session == null) {
      return const Scaffold(
        body: EmptyState(icon: Icons.history, title: 'Treino não encontrado'),
      );
    }
    final duration = session.endedAt?.difference(session.startedAt);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat("EEE, d 'de' MMM").format(session.startedAt.toLocal()),
        ),
        actions: [
          IconButton(
            tooltip: 'Salvar como ficha',
            icon: const Icon(Icons.bookmark_add_outlined),
            onPressed: () => _saveAsRoutine(context, ref, session),
          ),
          IconButton(
            tooltip: 'Apagar treino',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            [
              session.title,
              DateFormat('HH:mm').format(session.startedAt.toLocal()),
              if (duration != null) formatDuration(duration),
            ].join(' · '),
            style: context.texts.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryCard(sessionId: sessionId),
          const SizedBox(height: 12),
          for (final v in exercises) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.exercise.name,
                      style: context.texts.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      v.equipmentName,
                      style: context.texts.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final s in sets[v.item.id] ?? const <WorkoutSet>[])
                      if (s.completedAt != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            [
                              if (s.setType != SetType.working)
                                '${s.setType.label}:',
                              formatSetShort(
                                tracking: v.exercise.tracking,
                                unit: v.item.loadUnit,
                                loadMilli: s.loadMilli,
                                reps: s.reps,
                                durationSec: s.durationSec,
                                distanceM: s.distanceM,
                                withUnit: true,
                              ),
                              if (s.rir != null)
                                '(RIR ${formatNumber(s.rir!)})',
                            ].join(' '),
                            style: const TextStyle(
                              fontFeatures: tabularFigures,
                            ),
                          ),
                        ),
                    if (v.item.howItWent != null ||
                        v.item.effortTag != null ||
                        v.item.pain)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          [
                            ?v.item.effortTag?.label,
                            if (v.item.pain) 'dor',
                            if (v.item.howItWent != null)
                              '"${v.item.howItWent}"',
                          ].join(' · '),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

/// Resumo: duração, séries, volume e recordes do dia.
class _SummaryCard extends ConsumerWidget {
  const _SummaryCard({required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(sessionSummaryProvider(sessionId)).value;
    if (summary == null) return const SizedBox.shrink();
    Widget stat(String value, String label) => Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: context.texts.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontFeatures: tabularFigures,
            ),
          ),
          Text(
            label,
            style: context.texts.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                stat(
                  summary.duration == null
                      ? '—'
                      : formatDuration(summary.duration!),
                  'duração',
                ),
                stat('${summary.completedSets}', 'séries'),
                stat(
                  '${formatNumber(summary.volumeKg.roundToDouble())} kg',
                  'volume',
                ),
              ],
            ),
            if (summary.records.isNotEmpty) ...[
              const Divider(height: 28),
              for (final r in summary.records)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.emoji_events,
                    color: context.semantic.attention,
                  ),
                  title: Text('${r.exerciseName}: ${r.value}'),
                  subtitle: Text(
                    'Recorde de ${r.kind.toLowerCase()} · ${r.equipmentName}',
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
