import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../workout/data/workout_repository.dart';

enum _Metric { load, e1rm }

/// Evolução na estação: carga máxima ou 1RM estimado, treino a treino.
class StationProgressChart extends ConsumerStatefulWidget {
  const StationProgressChart({super.key, required this.stationId});
  final String stationId;

  @override
  ConsumerState<StationProgressChart> createState() =>
      _StationProgressChartState();
}

class _StationProgressChartState extends ConsumerState<StationProgressChart> {
  _Metric _metric = _Metric.load;

  @override
  Widget build(BuildContext context) {
    final points =
        ref.watch(stationProgressProvider(widget.stationId)).value ?? const [];
    if (points.length < 2) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'O gráfico aparece a partir do 2º treino nesta estação.',
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
        ),
      );
    }
    final unit = points.last.unit;
    // "placa 7" não vira 1RM: só carga.
    final metric = unit == LoadUnit.plate ? _Metric.load : _metric;
    final values = [
      for (final p in points)
        metric == _Metric.load
            ? p.maxLoadMilli / 1000
            : (p.bestE1rm ?? p.maxLoadMilli / 1000),
    ];
    final first = values.first;
    final last = values.last;
    final diff = last - first;
    final minY = values.reduce(math.min);
    final maxY = values.reduce(math.max);
    final pad = math.max((maxY - minY) * 0.15, 1.0);
    String fmt(double v) => unit == LoadUnit.plate
        ? 'placa ${formatNumber(v)}'
        : '${formatNumber(double.parse(v.toStringAsFixed(1)))} ${unit.label}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (unit != LoadUnit.plate)
              SegmentedButton<_Metric>(
                segments: const [
                  ButtonSegment(value: _Metric.load, label: Text('Carga máx.')),
                  ButtonSegment(value: _Metric.e1rm, label: Text('1RM est.')),
                ],
                selected: {metric},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _metric = s.first),
              ),
            const SizedBox(height: 12),
            Text(
              diff == 0
                  ? 'Igual ao primeiro treino (${fmt(last)})'
                  : '${diff > 0 ? '+' : '−'}${fmt(diff.abs())} desde '
                        '${DateFormat('dd/MM').format(points.first.day.toLocal())}',
              style: context.texts.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: diff > 0 ? context.colors.primary : null,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  minY: math.max(0, minY - pad),
                  maxY: maxY + pad,
                  gridData: FlGridData(
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: context.colors.outlineVariant.withValues(
                        alpha: 0.4,
                      ),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        minIncluded: false,
                        maxIncluded: false,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(
                            formatNumber(value.round()),
                            style: context.texts.labelSmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 24,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final i = value.round();
                          final show =
                              i == 0 ||
                              i == points.length - 1 ||
                              (points.length <= 6 && i < points.length);
                          if (!show || (value - i).abs() > 0.01) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            fitInside: SideTitleFitInsideData.fromTitleMeta(
                              meta,
                            ),
                            child: Text(
                              DateFormat('dd/MM')
                                  .format(points[i].day.toLocal()),
                              style: context.texts.labelSmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) =>
                          context.colors.surfaceContainerHighest,
                      getTooltipItems: (spots) => [
                        for (final s in spots)
                          LineTooltipItem(
                            '${fmt(s.y)}\n'
                            '${DateFormat('dd/MM').format(points[s.x.round()].day.toLocal())}',
                            context.texts.labelMedium!.copyWith(
                              color: context.colors.onSurface,
                            ),
                          ),
                      ],
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (var i = 0; i < values.length; i++)
                          FlSpot(i.toDouble(), values[i]),
                      ],
                      color: context.colors.primary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(),
                      belowBarData: BarAreaData(
                        show: true,
                        color: context.colors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (metric == _Metric.e1rm)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Estimativa (Epley), só séries de até 10 reps.',
                  style: context.texts.labelSmall?.copyWith(
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
