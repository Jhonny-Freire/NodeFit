import 'progression.dart';

/// Aquecimento em rampa até a carga de trabalho (como Strong e Hevy fazem):
/// cada série sobe a carga e desce as reps, para chegar aquecido sem cansar.
///
/// - 1 série: 60% × 6
/// - 2 séries: 50% × 8, 75% × 4
/// - 3 séries: 40% × 10, 60% × 6, 80% × 3
/// - mais: espalha de 40% a 85% e de 10 a 3 reps.
///
/// A carga arredonda para BAIXO no passo do aparelho (nunca passa do
/// planejado) e nunca fica abaixo de um passo.
List<SetTarget> warmupRamp({
  required int workLoadMilli,
  required int count,
  required int incrementMilli,
}) {
  if (count <= 0 || workLoadMilli <= 0) return const [];
  final (percents, reps) = switch (count) {
    1 => (const [0.60], const [6]),
    2 => (const [0.50, 0.75], const [8, 4]),
    3 => (const [0.40, 0.60, 0.80], const [10, 6, 3]),
    _ => (
      [for (var i = 0; i < count; i++) 0.40 + 0.45 * i / (count - 1)],
      [for (var i = 0; i < count; i++) (10 - 7 * i / (count - 1)).round()],
    ),
  };
  final step = incrementMilli > 0 ? incrementMilli : 1000;
  return [
    for (var i = 0; i < count; i++)
      (loadMilli: _roundDown(workLoadMilli * percents[i], step), reps: reps[i]),
  ];
}

int _roundDown(double value, int step) {
  final rounded = (value / step).floor() * step;
  return rounded < step ? step : rounded;
}
