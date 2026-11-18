import 'enums.dart';
import 'load.dart';

// Séries por tempo (prancha) e de cardio (esteira): o tempo fica em
// segundos e a distância em metros, ambos inteiros.

/// 90 → "1:30"; 3725 → "1:02:05"; null → "—".
String formatSeconds(int? sec) {
  if (sec == null) return '—';
  final h = sec ~/ 3600;
  final m = (sec % 3600) ~/ 60;
  final s = (sec % 60).toString().padLeft(2, '0');
  return h > 0 ? '$h:${m.toString().padLeft(2, '0')}:$s' : '$m:$s';
}

/// 2500 → "2,5"; 800 → "0,8" (km, sem a unidade); null → "—".
String formatKmValue(int? meters) =>
    meters == null ? '—' : formatNumber(meters / 1000);

/// "1:30" → 90; "1:02:05" → 3725. Número sozinho vale [plainUnitSec]
/// segundos (1 na prancha; 60 no cardio, onde se pensa em minutos).
/// Null se não der para entender.
int? parseClock(String text, {int plainUnitSec = 1}) {
  final t = text.trim().replaceAll(' ', '');
  if (t.isEmpty) return null;
  final parts = t.split(':');
  if (parts.length == 1) {
    final v = double.tryParse(t.replaceAll(',', '.'));
    if (v == null || v < 0) return null;
    return (v * plainUnitSec).round();
  }
  if (parts.length > 3) return null;
  var total = 0;
  for (final p in parts) {
    final v = int.tryParse(p);
    if (v == null || v < 0) return null;
    total = total * 60 + v;
  }
  return total;
}

/// "2,5" → 2500 m. Null se não for um número.
int? parseKm(String text) {
  final v = double.tryParse(text.trim().replaceAll(',', '.'));
  if (v == null || v < 0 || v > 1000) return null;
  return (v * 1000).round();
}

/// Uma série em texto curto, do jeito de cada tipo de exercício:
/// "42,5×10", "1:30", "20:00 · 2,5 km". Com [withUnit], a carga leva a
/// unidade ("42,5 kg×10").
String formatSetShort({
  required TrackingType tracking,
  required LoadUnit unit,
  int? loadMilli,
  int? reps,
  int? durationSec,
  int? distanceM,
  bool withUnit = false,
}) => switch (tracking) {
  TrackingType.weightReps =>
    '${withUnit ? formatLoad(loadMilli, unit) : formatLoadValue(loadMilli)}'
        '×${reps ?? '—'}',
  TrackingType.duration => formatSeconds(durationSec),
  TrackingType.cardio => [
    formatSeconds(durationSec),
    if (distanceM != null) '${formatKmValue(distanceM)} km',
  ].join(' · '),
};
