import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/core/domain/workout_dates.dart';

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  // "Hoje" fixo: quinta, 19/11/2026.
  final now = DateTime(2026, 11, 19, 15);

  group('nextWorkoutInfo', () {
    test('sem data não mostra nada', () {
      expect(nextWorkoutInfo(null, now: now), isNull);
      expect(nextWorkoutInfo('lixo', now: now), isNull);
    });

    test('hoje', () {
      final info = nextWorkoutInfo('2026-11-19', now: now)!;
      expect(info.text, 'Próximo: hoje (19/11)');
      expect(info.overdue, isFalse);
    });

    test('amanhã e daqui a alguns dias (futuro)', () {
      expect(
        nextWorkoutInfo('2026-11-20', now: now)!.text,
        'Próximo: amanhã (20/11)',
      );
      final info = nextWorkoutInfo('2026-11-22', now: now)!;
      expect(info.text, 'Próximo: em 3 dias (22/11)');
      expect(info.overdue, isFalse);
    });

    test('data que já passou fica marcada como atrasada', () {
      final info = nextWorkoutInfo('2026-11-17', now: now)!;
      expect(info.text, 'Próximo era 17/11 (já passou)');
      expect(info.overdue, isTrue);
    });
  });

  group('lastWorkoutText', () {
    test('nunca feita', () => expect(lastWorkoutText(null), isNull));

    test('mostra o dia da semana e a data', () {
      expect(lastWorkoutText(DateTime(2026, 11, 18, 10)), 'Último: qua. 18/11');
    });
  });
}
