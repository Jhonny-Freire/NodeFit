import '../../../core/domain/body.dart';
import '../../../core/domain/load.dart';

/// "80,4 kg", "19,5%", "nível 8", "1.650 kcal", "85,5 cm".
String formatMetric(BodyMetric m, double value) {
  final n = formatNumber(double.parse(value.toStringAsFixed(1)));
  return switch (m.unit) {
    '%' => '$n%',
    'nível' => 'nível $n',
    _ => '$n ${m.unit}',
  };
}

/// "+0,8 kg", "−1,5 cm" (sinal sempre visível; 0 = "=").
String formatMetricDelta(BodyMetric m, double delta) {
  if (delta.abs() < 0.05) return '=';
  final sign = delta > 0 ? '+' : '−';
  return '$sign${formatMetric(m, delta.abs())}';
}
