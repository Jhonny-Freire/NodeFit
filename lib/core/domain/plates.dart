import 'enums.dart';

/// Anilhas comuns em academia, da maior para a menor (× 1000).
const standardPlatesKg = [25000, 20000, 15000, 10000, 5000, 2500, 1250];
const standardPlatesLb = [45000, 35000, 25000, 10000, 5000, 2500];

/// Quais anilhas pôr de CADA lado para chegar em [targetMilli].
class PlateLoadout {
  const PlateLoadout({required this.perSide, required this.leftoverMilli});

  /// Anilhas de um lado, da maior para a menor.
  final List<int> perSide;

  /// O que faltou (por lado) porque não existe anilha tão pequena.
  final int leftoverMilli;

  bool get exact => leftoverMilli == 0;
}

/// [targetMilli] é o valor que você anota no app:
/// - carga total (barra + anilhas), descontando [barMilli];
/// - "por lado": o próprio valor já é de um lado.
/// Retorna null se a carga for menor que a barra.
PlateLoadout? plateLoadout({
  required int targetMilli,
  required LoadBasis basis,
  int barMilli = 0,
  List<int> platesMilli = standardPlatesKg,
}) {
  final int perSideMilli;
  if (basis == LoadBasis.total) {
    final onPlates = targetMilli - barMilli;
    if (onPlates < 0) return null;
    perSideMilli = onPlates ~/ 2;
  } else {
    perSideMilli = targetMilli;
  }
  final sorted = [...platesMilli]..sort((a, b) => b.compareTo(a));
  var left = perSideMilli;
  final result = <int>[];
  for (final p in sorted) {
    if (p <= 0) continue;
    while (left >= p) {
      result.add(p);
      left -= p;
    }
  }
  return PlateLoadout(perSide: result, leftoverMilli: left);
}
