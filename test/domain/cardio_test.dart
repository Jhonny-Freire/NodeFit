import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/core/domain/cardio.dart';
import 'package:nodefit/core/domain/enums.dart';

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  test('tempo em texto', () {
    expect(formatSeconds(90), '1:30');
    expect(formatSeconds(45), '0:45');
    expect(formatSeconds(3725), '1:02:05');
    expect(formatSeconds(null), '—');
  });

  test('ler o tempo digitado', () {
    expect(parseClock('1:30'), 90);
    expect(parseClock('90'), 90, reason: 'prancha: número sozinho = segundos');
    expect(parseClock('20', plainUnitSec: 60), 1200, reason: 'cardio: minutos');
    expect(parseClock('20,5', plainUnitSec: 60), 1230);
    expect(parseClock('1:02:05'), 3725);
    expect(parseClock('abc'), isNull);
    expect(parseClock(''), isNull);
  });

  test('distância', () {
    expect(parseKm('2,5'), 2500);
    expect(parseKm('0.8'), 800);
    expect(formatKmValue(2500), '2,5');
    expect(parseKm('x'), isNull);
  });

  test('série curta por tipo de exercício', () {
    expect(
      formatSetShort(
        tracking: TrackingType.weightReps,
        unit: LoadUnit.kg,
        loadMilli: 42500,
        reps: 10,
      ),
      '42,5×10',
    );
    expect(
      formatSetShort(
        tracking: TrackingType.duration,
        unit: LoadUnit.kg,
        durationSec: 60,
      ),
      '1:00',
    );
    expect(
      formatSetShort(
        tracking: TrackingType.cardio,
        unit: LoadUnit.kg,
        durationSec: 1200,
        distanceM: 2500,
      ),
      '20:00 · 2,5 km',
    );
  });
}
