import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/domain/body.dart';
import '../../../core/domain/load.dart';
import '../../../core/widgets/common.dart';
import '../data/body_repository.dart';
import 'body_format.dart';
import 'checkin_screen.dart';
import 'profile_sheet.dart';

/// Aba "Corpo" do Progresso: o último check-in, o gráfico de cada medida,
/// as fotos lado a lado (primeira × última) e a lista de check-ins.
class BodyTab extends ConsumerWidget {
  const BodyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkins = ref.watch(checkinsProvider);
    final profile = ref.watch(bodyProfileProvider).value;
    return AsyncView(
      value: checkins,
      builder: (list) => ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          FilledButton.icon(
            onPressed: () => context.push('/checkin'),
            icon: const Icon(Icons.add),
            label: const Text('Novo check-in'),
            style: FilledButton.styleFrom(minimumSize: const Size(64, 56)),
          ),
          if (profile != null && !profile.complete) ...[
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Complete seu perfil'),
                subtitle: const Text(
                  'Sexo e altura liberam o IMC e a gordura pela fita',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showProfileSheet(context),
              ),
            ),
          ],
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 32),
              child: EmptyState(
                icon: Icons.monitor_weight_outlined,
                title: 'Nenhum check-in ainda',
                message:
                    'Pese-se, meça com a fita e tire as fotos uma vez por '
                    'semana (mesmo dia e horário, de preferência em jejum). '
                    'O app mostra a tendência, não o sobe-e-desce diário.',
              ),
            )
          else ...[
            const SizedBox(height: 12),
            _Summary(list: list, profile: profile),
            const SectionLabel('Evolução'),
            _ChartCard(list: list),
            if (list.any((c) => c.photos.isNotEmpty)) ...[
              const SectionLabel('Fotos'),
              _PhotoCompare(list: list),
            ],
            const SectionLabel('Check-ins'),
            Card(
              child: Column(
                children: [
                  for (final c in list)
                    ListTile(
                      title: Text(
                        DateFormat("EEE, d 'de' MMM yyyy")
                            .format(c.checkin.takenAt.toLocal()),
                      ),
                      subtitle: Text(
                        [
                          if (c.value(BodyMetric.weight) case final w?)
                            formatMetric(BodyMetric.weight, w),
                          if (c.value(BodyMetric.bodyFat) case final f?)
                            '${formatMetric(BodyMetric.bodyFat, f)} gordura',
                          if (c.values.keys.any(
                            (m) => m.group == BodyMetricGroup.tape,
                          ))
                            'medidas',
                          if (c.photos.isNotEmpty)
                            '${c.photos.length} foto${c.photos.length == 1 ? '' : 's'}',
                        ].join(' · '),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/checkin/${c.checkin.id}'),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Peso de agora, a tendência e a gordura (da balança ou pela fita).
class _Summary extends StatelessWidget {
  const _Summary({required this.list, required this.profile});
  final List<CheckinView> list;
  final BodyProfile? profile;

  /// Último valor da medida (o check-in mais novo que a tem).
  double? _latest(BodyMetric m) {
    for (final c in list) {
      if (c.value(m) case final v?) return v;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final weights = [
      for (final c in list.reversed)
        if (c.value(BodyMetric.weight) case final w?)
          (day: c.checkin.takenAt, kg: w),
    ];
    final trend = weightTrend(weights);
    String? trendText;
    if (trend.length >= 2) {
      // Variação da tendência em ~4 semanas (ou desde o começo).
      final cutoff = weights.last.day.subtract(const Duration(days: 28));
      var i = weights.indexWhere((w) => !w.day.isBefore(cutoff));
      if (i == weights.length - 1) i = math.max(0, i - 1);
      final days = weights.last.day.difference(weights[i].day).inDays;
      trendText =
          '${formatMetricDelta(BodyMetric.weight, trend.last - trend[i])} '
          'em ${days <= 1 ? '1 dia' : '$days dias'} (tendência)';
    }
    final p = profile;
    final weight = _latest(BodyMetric.weight);
    final scaleFat = list.first.value(BodyMetric.bodyFat);
    final navy = p == null || !p.complete
        ? null
        : navyBodyFat(
            sex: p.sex!,
            heightCm: p.heightCm!,
            neckCm: _latest(BodyMetric.neck),
            abdomenCm: _latest(BodyMetric.abdomen),
            waistCm: _latest(BodyMetric.waist),
            hipCm: _latest(BodyMetric.hip),
          );
    final imc = bmi(weightKg: weight, heightCm: p?.heightCm);
    final fat = scaleFat ?? navy;

    Widget stat(String value, String label) => Expanded(
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
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
    String one(double v) => formatNumber(double.parse(v.toStringAsFixed(1)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                stat(weight == null ? '—' : '${one(weight)} kg', 'peso'),
                stat(
                  fat == null ? '—' : '${one(fat)}%',
                  scaleFat != null ? 'gordura (balança)' : 'gordura (fita) ±4',
                ),
                stat(imc == null ? '—' : one(imc), 'IMC'),
              ],
            ),
            if (trendText != null) ...[
              const SizedBox(height: 12),
              Text(
                trendText,
                style: context.texts.bodyMedium?.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (weight != null && fat != null) ...[
              const SizedBox(height: 4),
              Text(
                'Massa gorda ${one(weight * fat / 100)} kg · '
                'massa magra ${one(weight * (1 - fat / 100))} kg',
                style: context.texts.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Gráfico de uma medida (peso com a linha de tendência).
class _ChartCard extends StatefulWidget {
  const _ChartCard({required this.list});
  final List<CheckinView> list;

  @override
  State<_ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<_ChartCard> {
  BodyMetric _metric = BodyMetric.weight;

  @override
  Widget build(BuildContext context) {
    // Só medidas com pelo menos 2 pontos viram gráfico.
    final counts = <BodyMetric, int>{};
    for (final c in widget.list) {
      for (final m in c.values.keys) {
        counts[m] = (counts[m] ?? 0) + 1;
      }
    }
    final available = [
      for (final m in BodyMetric.values)
        if ((counts[m] ?? 0) >= 2 && m.typed) m,
    ];
    if (available.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Os gráficos aparecem a partir do 2º check-in.',
            style: TextStyle(color: context.colors.onSurfaceVariant),
          ),
        ),
      );
    }
    final metric = available.contains(_metric) ? _metric : available.first;
    final points = [
      for (final c in widget.list.reversed)
        if (c.value(metric) case final v?) (day: c.checkin.takenAt, value: v),
    ];
    final trend = metric == BodyMetric.weight
        ? weightTrend([for (final p in points) (day: p.day, kg: p.value)])
        : const <double>[];
    final values = [for (final p in points) p.value, ...trend];
    final minY = values.reduce(math.min);
    final maxY = values.reduce(math.max);
    final pad = math.max((maxY - minY) * 0.2, 0.5);
    final first = points.first.day;
    double x(DateTime d) => d.difference(first).inHours / 24;
    final delta = points.last.value - points.first.value;
    final good = metric.neutral
        ? null
        : (delta > 0) == metric.higherIsBetter && delta.abs() >= 0.05;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 8),
                children: [
                  for (final m in available)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(m.label),
                        selected: m == metric,
                        onSelected: (_) => setState(() => _metric = m),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 0, 12),
              child: Text(
                '${formatMetricDelta(metric, delta)} desde '
                '${DateFormat('dd/MM').format(first.toLocal())}',
                style: context.texts.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: good == null
                      ? null
                      : good
                      ? context.colors.primary
                      : context.semantic.attention,
                ),
              ),
            ),
            SizedBox(
              height: 190,
              child: LineChart(
                LineChartData(
                  minY: minY - pad,
                  maxY: maxY + pad,
                  minX: 0,
                  maxX: math.max(1, x(points.last.day)),
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
                        reservedSize: 44,
                        minIncluded: false,
                        maxIncluded: false,
                        getTitlesWidget: (v, meta) => SideTitleWidget(
                          meta: meta,
                          child: Text(
                            formatNumber(double.parse(v.toStringAsFixed(1))),
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
                        interval: math.max(1, x(points.last.day)),
                        getTitlesWidget: (v, meta) => SideTitleWidget(
                          meta: meta,
                          fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                          child: Text(
                            DateFormat('dd/MM').format(
                              first
                                  .add(Duration(hours: (v * 24).round()))
                                  .toLocal(),
                            ),
                            style: context.texts.labelSmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) =>
                          context.colors.surfaceContainerHighest,
                      getTooltipItems: (spots) => [
                        for (final s in spots)
                          s.barIndex == 0
                              ? LineTooltipItem(
                                  formatMetric(metric, s.y),
                                  context.texts.labelMedium!.copyWith(
                                    color: context.colors.onSurface,
                                  ),
                                )
                              : null,
                      ],
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (final p in points) FlSpot(x(p.day), p.value),
                      ],
                      // Com tendência, os pontos do dia ficam discretos.
                      color: trend.isEmpty
                          ? context.colors.primary
                          : context.colors.onSurfaceVariant,
                      barWidth: trend.isEmpty ? 3 : 0,
                      dotData: const FlDotData(),
                      belowBarData: BarAreaData(
                        show: trend.isEmpty,
                        color: context.colors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    if (trend.isNotEmpty)
                      LineChartBarData(
                        spots: [
                          for (var i = 0; i < points.length; i++)
                            FlSpot(x(points[i].day), trend[i]),
                        ],
                        isCurved: true,
                        color: context.colors.primary,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                  ],
                ),
              ),
            ),
            if (trend.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                child: Text(
                  'Pontos: cada pesagem · linha: tendência',
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

/// Primeira × última foto da pose, lado a lado.
class _PhotoCompare extends StatefulWidget {
  const _PhotoCompare({required this.list});
  final List<CheckinView> list;

  @override
  State<_PhotoCompare> createState() => _PhotoCompareState();
}

class _PhotoCompareState extends State<_PhotoCompare> {
  PhotoPose _pose = PhotoPose.front;

  @override
  Widget build(BuildContext context) {
    final withPose = [
      for (final c in widget.list.reversed)
        for (final p in c.photos)
          if (p.pose == _pose) (day: c.checkin.takenAt, path: p.path),
    ];
    Widget side(({DateTime day, String path}) e) => Expanded(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BodyPhotoImage(path: e.path),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            DateFormat('dd/MM/yy').format(e.day.toLocal()),
            style: context.texts.labelMedium,
          ),
        ],
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SegmentedButton<PhotoPose>(
              segments: [
                for (final p in PhotoPose.values)
                  ButtonSegment(value: p, label: Text(p.label)),
              ],
              selected: {_pose},
              showSelectedIcon: false,
              onSelectionChanged: (s) => setState(() => _pose = s.first),
            ),
            const SizedBox(height: 12),
            if (withPose.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Sem foto de ${_pose.label.toLowerCase()} ainda.',
                  style: TextStyle(color: context.colors.onSurfaceVariant),
                ),
              )
            else
              Row(
                children: [
                  side(withPose.first),
                  if (withPose.length > 1) ...[
                    const SizedBox(width: 8),
                    side(withPose.last),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
