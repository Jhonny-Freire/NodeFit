import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/cardio.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/domain/one_rep_max.dart';
import '../../../core/widgets/common.dart';
import '../../workout/data/workout_repository.dart';
import '../data/station_repository.dart';
import 'setting_sheets.dart';
import 'station_progress_chart.dart';

/// A estação (exercício × aparelho): ajustes, nota fixada, histórico de
/// ajustes e as últimas vezes.
class StationDetailScreen extends ConsumerWidget {
  const StationDetailScreen({super.key, required this.stationId});
  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(stationViewProvider(stationId));
    return AsyncView(
      value: view,
      builder: (v) {
        if (v == null) {
          return const Scaffold(
            body: EmptyState(icon: Icons.help_outline, title: 'Não encontrado'),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(v.exercise.name),
                Text(
                  equipmentDisplayName(v.equipment),
                  style: context.texts.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: StationSettingsStrip(stationId: stationId),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.push_pin_outlined),
                  title: Text(v.station.pinnedNote ?? 'Sem nota fixada'),
                  subtitle: const Text(
                    'Aparece sempre neste exercício neste aparelho',
                  ),
                  trailing: const Icon(Icons.edit_outlined),
                  onTap: () async {
                    final text = await showTextInputDialog(
                      context,
                      title: 'Nota fixada',
                      initial: v.station.pinnedNote,
                      maxLines: 3,
                      allowEmpty: true,
                    );
                    if (text != null) {
                      await ref
                          .read(stationRepositoryProvider)
                          .updatePinnedNote(stationId, text);
                    }
                  },
                ),
              ),
              // O gráfico é de carga; prancha e cardio ficam só no histórico.
              if (v.exercise.tracking == TrackingType.weightReps) ...[
                const SectionLabel('Evolução'),
                StationProgressChart(stationId: stationId),
              ],
              const SectionLabel('Últimas vezes'),
              _History(stationId: stationId, tracking: v.exercise.tracking),
              const SectionLabel('Histórico de ajustes'),
              _Changes(stationId: stationId),
            ],
          ),
        );
      },
    );
  }
}

class _History extends ConsumerWidget {
  const _History({required this.stationId, required this.tracking});
  final String stationId;
  final TrackingType tracking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(stationHistoryProvider(stationId));
    return AsyncView(
      value: entries,
      builder: (list) {
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Nenhum treino finalizado nesta estação ainda.'),
          );
        }
        return Card(
          child: Column(
            children: [
              for (final e in list)
                ListTile(
                  title: Text(
                    DateFormat('EEE, dd/MM').format(e.startedAt.toLocal()),
                  ),
                  subtitle: Text(
                    [
                      e.sets
                          .map(
                            (s) =>
                                '${s.setType == SetType.warmup ? 'A ' : ''}'
                                '${formatSetShort(tracking: tracking, unit: e.item.loadUnit, loadMilli: s.loadMilli, reps: s.reps, durationSec: s.durationSec, distanceM: s.distanceM)}',
                          )
                          .join(' · '),
                      if (e.item.howItWent != null) '"${e.item.howItWent}"',
                    ].join('\n'),
                  ),
                  trailing: _BestE1rm(entry: e),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Maior 1RM estimado do dia (Epley, só séries de 1–10 reps, sem
/// aquecimento) — rotulado como estimativa.
class _BestE1rm extends StatelessWidget {
  const _BestE1rm({required this.entry});
  final StationHistoryEntry entry;

  @override
  Widget build(BuildContext context) {
    double? best;
    for (final s in entry.sets) {
      if (s.setType == SetType.warmup ||
          s.loadMilli == null ||
          s.reps == null) {
        continue;
      }
      final e = epley(s.loadMilli! / 1000, s.reps!);
      if (e != null && (best == null || e > best)) best = e;
    }
    if (best == null) return const SizedBox.shrink();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          formatNumber(double.parse(best.toStringAsFixed(1))),
          style: context.texts.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          '1RM est.',
          style: context.texts.labelSmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Changes extends ConsumerWidget {
  const _Changes({required this.stationId});
  final String stationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final changes = ref.watch(stationChangesProvider(stationId));
    return AsyncView(
      value: changes,
      builder: (list) => list.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(8),
              child: Text('Nenhum ajuste anotado ainda.'),
            )
          : Card(
              child: Column(
                children: [
                  for (final c in list)
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.tune, size: 20),
                      title: Text(
                        c.change.oldValue == null
                            ? '${c.label}: ${c.change.newValue}'
                            : '${c.label}: ${c.change.oldValue} → ${c.change.newValue}',
                      ),
                      trailing: Text(
                        DateFormat('dd/MM HH:mm')
                            .format(c.change.changedAt.toLocal()),
                        style: TextStyle(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
