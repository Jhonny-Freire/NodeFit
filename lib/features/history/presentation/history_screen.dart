import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/frequency.dart';
import '../../../core/domain/load.dart';
import '../../../core/utils/plural.dart';
import '../../../core/widgets/common.dart';
import '../../body/presentation/body_tab.dart';
import '../../catalog/presentation/muscle_groups.dart';
import '../../workout/data/workout_repository.dart';
import '../../workout/presentation/widgets/elapsed_text.dart';

/// Aba Progresso: "Treinos" (constância, volume por músculo e histórico) e
/// "Corpo" (check-ins, medidas e fotos).
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: const Text('Progresso'),
        bottom: const TabBar(
          tabs: [
            Tab(text: 'Treinos'),
            Tab(text: 'Corpo'),
          ],
        ),
      ),
      body: const TabBarView(children: [_WorkoutsTab(), BodyTab()]),
    ),
  );
}

class _WorkoutsTab extends ConsumerWidget {
  const _WorkoutsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    return AsyncView(
      value: history,
      builder: (list) => list.isEmpty
          ? const EmptyState(
              icon: Icons.history,
              title: 'Nenhum treino finalizado ainda',
              message: 'Seus treinos aparecem aqui depois de "Finalizar".',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length + 3,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _FrequencyCard(
                    days: [for (final e in list) e.session.startedAt.toLocal()],
                  );
                }
                if (index == 1) return const _MuscleVolumeCard();
                if (index == 2) return const SectionLabel('Treinos');
                final e = list[index - 3];
                final s = e.session;
                final duration = s.endedAt?.difference(s.startedAt);
                return Card(
                  child: ListTile(
                    title: Text(
                      DateFormat("EEEE, d 'de' MMM")
                          .format(s.startedAt.toLocal()),
                    ),
                    subtitle: Text(
                      '${s.title} · ${e.gymName}\n'
                      '${plural(e.exerciseCount, 'exercício', 'exercícios')} · '
                      '${plural(e.setCount, 'série', 'séries')}'
                      '${duration == null ? '' : ' · ${formatDuration(duration)}'}',
                      style: TextStyle(color: context.colors.onSurfaceVariant),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/progresso/sessao/${s.id}'),
                  ),
                );
              },
            ),
    );
  }
}

/// Séries por grupo muscular nos últimos 7 dias (1 no primário, 0,5 no
/// secundário). Informativo, não é prescrição.
class _MuscleVolumeCard extends ConsumerWidget {
  const _MuscleVolumeCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final byMuscle = ref.watch(weeklyMuscleVolumeProvider).value ?? const {};
    final byGroup = <MuscleGroup, double>{};
    for (final e in byMuscle.entries) {
      final g = muscleGroups
          .where((g) => g.muscles.contains(e.key))
          .firstOrNull;
      if (g == null) continue;
      byGroup[g] = (byGroup[g] ?? 0) + e.value;
    }
    final rows = byGroup.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top = rows.isEmpty ? 1.0 : rows.first.value;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Séries por músculo (7 dias)',
              style: context.texts.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cada série conta 1 para o músculo principal e meia para os '
              'auxiliares.',
              style: context.texts.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            if (rows.isEmpty)
              Text(
                'Nenhuma série de força nos últimos 7 dias.',
                style: TextStyle(color: context.colors.onSurfaceVariant),
              ),
            for (final r in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    SizedBox(width: 96, child: Text(r.key.label)),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: r.value / top,
                          minHeight: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 44,
                      child: Text(
                        formatNumber(r.value),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFeatures: tabularFigures,
                        ),
                      ),
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

/// Constância: treinos na semana, semanas seguidas e as últimas 5 semanas
/// num calendário (um quadrado por dia).
class _FrequencyCard extends StatelessWidget {
  const _FrequencyCard({required this.days});
  final List<DateTime> days;

  static const _weeks = 5;
  static const _dayLetters = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final trained = {for (final d in days) DateTime(d.year, d.month, d.day)};
    final thisWeek = daysThisWeek(days, today);
    final streak = weekStreak(days, today);
    final monthCount = trained
        .where((d) => d.year == today.year && d.month == today.month)
        .length;
    final firstMonday = weekStart(today);
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
            textAlign: TextAlign.center,
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
          children: [
            Row(
              children: [
                stat(
                  '$thisWeek',
                  thisWeek == 1 ? 'dia nesta semana' : 'dias nesta semana',
                ),
                stat(
                  '$streak',
                  streak == 1 ? 'semana seguida' : 'semanas seguidas',
                ),
                stat('$monthCount', 'dias neste mês'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                for (final l in _dayLetters)
                  Expanded(
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      style: context.texts.labelSmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            for (var w = _weeks - 1; w >= 0; w--)
              Row(
                children: [
                  for (var d = 0; d < 7; d++)
                    Expanded(
                      child: _DayCell(
                        day: DateTime(
                          firstMonday.year,
                          firstMonday.month,
                          firstMonday.day - 7 * w + d,
                        ),
                        today: today,
                        trained: trained,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.today,
    required this.trained,
  });
  final DateTime day;
  final DateTime today;
  final Set<DateTime> trained;

  @override
  Widget build(BuildContext context) {
    final did = trained.contains(day);
    final isToday = day == today;
    final future = day.isAfter(today);
    return Padding(
      padding: const EdgeInsets.all(3),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: did
                ? context.colors.primary
                : context.colors.surfaceContainerHighest.withValues(
                    alpha: future ? 0.3 : 1,
                  ),
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: context.colors.primary, width: 2)
                : null,
          ),
          child: Text(
            '${day.day}',
            style: context.texts.labelSmall?.copyWith(
              color: did
                  ? context.colors.onPrimary
                  : context.colors.onSurfaceVariant.withValues(
                      alpha: future ? 0.4 : 1,
                    ),
              fontWeight: did ? FontWeight.w700 : null,
            ),
          ),
        ),
      ),
    );
  }
}
