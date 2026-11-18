import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/domain/body.dart';

void main() {
  group('Gordura pela Marinha (PLANO 7.4)', () {
    test('homem 178 cm, pescoço 38, abdômen 85 → ≈16,44%', () {
      expect(
        navyBodyFat(sex: Sex.male, heightCm: 178, neckCm: 38, abdomenCm: 85),
        closeTo(16.44, 0.01),
      );
    });
    test('mulher usa cintura e quadril', () {
      final bf = navyBodyFat(
        sex: Sex.female,
        heightCm: 165,
        neckCm: 33,
        waistCm: 72,
        hipCm: 98,
      );
      expect(bf, isNotNull);
      expect(bf, inInclusiveRange(20, 35));
    });
    test('medida faltando ou impossível → null', () {
      expect(navyBodyFat(sex: Sex.male, heightCm: 178, neckCm: 38), isNull);
      expect(
        navyBodyFat(sex: Sex.male, heightCm: 178, neckCm: 40, abdomenCm: 39),
        isNull,
        reason: 'abdômen precisa ser maior que o pescoço',
      );
      expect(
        navyBodyFat(sex: Sex.female, heightCm: 165, neckCm: 33, waistCm: 72),
        isNull,
      );
    });
  });

  test('IMC', () {
    expect(bmi(weightKg: 80, heightCm: 178), closeTo(25.25, 0.01));
    expect(bmi(weightKg: null, heightCm: 178), isNull);
  });

  group('Tendência do peso', () {
    test('um pulo de um dia mexe pouco na tendência', () {
      final d = DateTime(2026, 10, 1);
      final t = weightTrend([
        (day: d, kg: 80),
        (day: d.add(const Duration(days: 1)), kg: 82),
      ]);
      expect(t.first, 80);
      expect(t.last, closeTo(80.2, 0.001));
    });
    test('intervalo maior puxa mais (semana = 1 − 0,9⁷ ≈ 52%)', () {
      final d = DateTime(2026, 10, 1);
      final t = weightTrend([
        (day: d, kg: 80),
        (day: d.add(const Duration(days: 7)), kg: 78),
      ]);
      expect(t.last, closeTo(80 - 2 * (1 - 0.4782969), 0.001));
    });
    test('vazio', () => expect(weightTrend(const []), isEmpty));
  });

  test('séries por músculo: 1 no primário, 0,5 no secundário', () {
    final m = weeklyMuscleSets([
      (primary: 'chest', secondary: 'triceps,frontDelts'),
      (primary: 'chest', secondary: 'triceps'),
      (primary: 'triceps', secondary: ''),
    ]);
    expect(m['chest'], 2);
    expect(m['triceps'], 2);
    expect(m['frontDelts'], 0.5);
  });
}
