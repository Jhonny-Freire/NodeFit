import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/domain/enums.dart';
import 'package:nodefit/core/domain/frequency.dart';
import 'package:nodefit/core/domain/plates.dart';
import 'package:nodefit/core/domain/records.dart';
import 'package:nodefit/core/domain/warmup.dart';

void main() {
  group('Aquecimento em rampa', () {
    test('3 séries até 60 kg: 40/60/80% arredondado para baixo no passo', () {
      expect(
        warmupRamp(workLoadMilli: 60000, count: 3, incrementMilli: 2500),
        const [
          (loadMilli: 22500, reps: 10),
          (loadMilli: 35000, reps: 6),
          (loadMilli: 47500, reps: 3),
        ],
      );
    });
    test('1 série: 60% × 6; nunca abaixo de um passo', () {
      expect(
        warmupRamp(workLoadMilli: 50000, count: 1, incrementMilli: 5000),
        const [(loadMilli: 30000, reps: 6)],
      );
      expect(
        warmupRamp(workLoadMilli: 5000, count: 1, incrementMilli: 5000),
        const [(loadMilli: 5000, reps: 6)],
      );
    });
    test('5 séries sobem a carga e descem as reps', () {
      final ramp = warmupRamp(
        workLoadMilli: 100000,
        count: 5,
        incrementMilli: 2500,
      );
      expect(ramp, hasLength(5));
      expect(ramp.first, (loadMilli: 40000, reps: 10));
      expect(ramp.last, (loadMilli: 85000, reps: 3));
      for (var i = 1; i < ramp.length; i++) {
        expect(ramp[i].loadMilli, greaterThan(ramp[i - 1].loadMilli));
        expect(ramp[i].reps, lessThanOrEqualTo(ramp[i - 1].reps));
      }
    });
    test('sem carga de trabalho não inventa aquecimento', () {
      expect(
        warmupRamp(workLoadMilli: 0, count: 2, incrementMilli: 2500),
        isEmpty,
      );
    });
  });

  group('Calculadora de anilhas', () {
    test('100 kg na barra de 20: 25 + 15 de cada lado', () {
      final r = plateLoadout(
        targetMilli: 100000,
        basis: LoadBasis.total,
        barMilli: 20000,
      )!;
      expect(r.perSide, [25000, 15000]);
      expect(r.exact, isTrue);
    });
    test('62,5 kg na barra de 20: 20 + 1,25 de cada lado', () {
      final r = plateLoadout(
        targetMilli: 62500,
        basis: LoadBasis.total,
        barMilli: 20000,
      )!;
      expect(r.perSide, [20000, 1250]);
    });
    test('carga impossível avisa o que sobrou', () {
      final r = plateLoadout(
        targetMilli: 61000,
        basis: LoadBasis.total,
        barMilli: 20000,
      )!;
      expect(r.perSide, [20000]);
      expect(r.leftoverMilli, 500);
      expect(r.exact, isFalse);
    });
    test('"por lado" usa o valor anotado direto', () {
      final r = plateLoadout(targetMilli: 45000, basis: LoadBasis.perSide)!;
      expect(r.perSide, [25000, 20000]);
    });
    test('menos que a barra → null', () {
      expect(
        plateLoadout(
          targetMilli: 15000,
          basis: LoadBasis.total,
          barMilli: 20000,
        ),
        isNull,
      );
    });
  });

  group('Frequência', () {
    final today = DateTime(2026, 10, 28); // quarta
    test('semanas seguidas com treino', () {
      final days = [
        DateTime(2026, 10, 26),
        DateTime(2026, 10, 20),
        DateTime(2026, 10, 22),
        DateTime(2026, 10, 6), // buraco na semana de 12/10
      ];
      expect(weekStreak(days, today), 2);
      expect(daysThisWeek(days, today), 1);
    });
    test('semana atual ainda sem treino não quebra a sequência', () {
      final days = [DateTime(2026, 10, 21), DateTime(2026, 10, 14)];
      expect(weekStreak(days, today), 2);
      expect(daysThisWeek(days, today), 0);
    });
    test('sem treino nenhum', () {
      expect(weekStreak(const [], today), 0);
    });
    test('domingo ainda é a mesma semana', () {
      expect(weekStart(DateTime(2026, 11, 1)), DateTime(2026, 10, 26));
    });
  });

  group('Recorde na hora', () {
    const history = [(loadMilli: 40000, reps: 8), (loadMilli: 37500, reps: 10)];
    test('carga maior que todas → recorde de carga', () {
      expect(
        recordOf(history: history, set: (loadMilli: 42500, reps: 6)),
        RecordKind.load,
      );
    });
    test('mesma carga com mais reps → recorde de 1RM estimado', () {
      expect(
        recordOf(history: history, set: (loadMilli: 40000, reps: 10)),
        RecordKind.e1rm,
      );
    });
    test('igualar não é recorde; primeira vez também não', () {
      expect(
        recordOf(history: history, set: (loadMilli: 40000, reps: 8)),
        isNull,
      );
      expect(
        recordOf(history: const [], set: (loadMilli: 40000, reps: 8)),
        isNull,
      );
    });
    test('em "placa" só conta carga', () {
      expect(
        recordOf(
          history: history,
          set: (loadMilli: 40000, reps: 10),
          allowE1rm: false,
        ),
        isNull,
      );
    });
  });
}
