import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/core/domain/enums.dart';
import 'package:nodefit/core/domain/load.dart';
import 'package:nodefit/core/domain/one_rep_max.dart';
import 'package:nodefit/core/domain/progression.dart';
import 'package:nodefit/core/utils/text_normalize.dart';
import 'package:nodefit/features/workout/presentation/widgets/elapsed_text.dart';

void main() {
  setUpAll(() async {
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  group('1RM estimado (PLANO 7.2)', () {
    test('Epley e Brzycki coincidem em 10 repetições', () {
      expect(epley(100, 10), closeTo(133.33, 0.01));
      expect(brzycki(100, 10), closeTo(133.33, 0.01));
    });
    test('com 1 repetição o valor é a própria carga', () {
      expect(epley(80, 1), 80);
      expect(brzycki(80, 1), 80);
    });
    test('não estima acima de 10 repetições nem sem carga', () {
      expect(epley(60, 11), isNull);
      expect(brzycki(60, 15), isNull);
      expect(epley(0, 5), isNull);
    });
  });

  group('Dupla progressão (PLANO 7.1)', () {
    test('todas no topo da faixa → +1 incremento e volta ao fundo', () {
      final next = doubleProgression(
        lastWorkingSets: const [
          (loadMilli: 40000, reps: 12),
          (loadMilli: 40000, reps: 12),
          (loadMilli: 40000, reps: 12),
        ],
        repMin: 8,
        repMax: 12,
        incrementMilli: 2500,
      );
      expect(next, everyElement((loadMilli: 42500, reps: 8)));
    });
    test('alguma abaixo do topo → mesma carga, +1 rep onde faltou', () {
      final next = doubleProgression(
        lastWorkingSets: const [
          (loadMilli: 40000, reps: 12),
          (loadMilli: 40000, reps: 10),
          (loadMilli: 40000, reps: 9),
        ],
        repMin: 8,
        repMax: 12,
        incrementMilli: 2500,
      );
      expect(next, const [
        (loadMilli: 40000, reps: 12),
        (loadMilli: 40000, reps: 11),
        (loadMilli: 40000, reps: 10),
      ]);
    });
    test('sem histórico → sem sugestão', () {
      expect(
        doubleProgression(
          lastWorkingSets: const [],
          repMin: 8,
          repMax: 12,
          incrementMilli: 2500,
        ),
        isEmpty,
      );
    });
  });

  group('Cargas como inteiros (× 1000)', () {
    test('lê vírgula ou ponto', () {
      expect(parseLoadMilli('62,5'), 62500);
      expect(parseLoadMilli('62.5'), 62500);
      expect(parseLoadMilli(' 40 '), 40000);
      expect(parseLoadMilli('abc'), isNull);
      expect(parseLoadMilli(''), isNull);
    });
    test('formata em pt-BR, sem zeros sobrando', () {
      expect(formatLoad(62500, LoadUnit.kg), '62,5 kg');
      expect(formatLoad(45000, LoadUnit.lb), '45 lb');
      expect(formatLoad(7000, LoadUnit.plate), 'placa 7');
      expect(formatLoad(null, LoadUnit.kg), '—');
    });
    test(
      'total em kg: por lado dobra e soma o carrinho; placa não vira kg',
      () {
        expect(
          totalKg(
            loadMilli: 40000,
            unit: LoadUnit.kg,
            basis: LoadBasis.perSide,
            baseLoadMilli: 30000,
          ),
          110,
        );
        expect(
          totalKg(loadMilli: 45000, unit: LoadUnit.lb, basis: LoadBasis.total),
          closeTo(20.41, 0.01),
        );
        expect(
          totalKg(
            loadMilli: 7000,
            unit: LoadUnit.plate,
            basis: LoadBasis.total,
          ),
          isNull,
        );
      },
    );
  });

  test('busca ignora acento e maiúsculas', () {
    expect(normalizeForSearch('Cadeira  Extensora'), 'cadeira extensora');
    expect(normalizeForSearch('Leg press 45°'), 'leg press 45');
    expect(normalizeForSearch('Elevação pélvica'), 'elevacao pelvica');
  });

  test('duração formatada', () {
    expect(formatDuration(const Duration(seconds: 75)), '1:15');
    expect(formatDuration(const Duration(seconds: 3725)), '1:02:05');
    expect(formatDuration(const Duration(seconds: -5)), '0:00');
  });

  group('Plano das séries da ficha', () {
    test('com histórico completo → sugestão; mais séries repetem a última', () {
      final plan = planWorkingSets(
        previousWorking: const [
          (loadMilli: 40000, reps: 12),
          (loadMilli: 40000, reps: 12),
        ],
        sameUnit: true,
        targetSets: 3,
        repMin: 8,
        repMax: 12,
        incrementMilli: 5000,
      );
      expect(plan, everyElement((loadMilli: 45000, reps: 8)));
      expect(plan.length, 3);
    });
    test('unidade diferente → não copia a carga', () {
      final plan = planWorkingSets(
        previousWorking: const [(loadMilli: 8000, reps: 10)],
        sameUnit: false,
        targetSets: 2,
        repMin: 8,
        repMax: 12,
        incrementMilli: 2500,
      );
      expect(plan, const [
        (loadMilli: null, reps: 10),
        (loadMilli: null, reps: 10),
      ]);
    });
    test('sem histórico → fundo da faixa', () {
      final plan = planWorkingSets(
        previousWorking: const [],
        sameUnit: true,
        targetSets: 3,
        repMin: 6,
        repMax: 10,
        incrementMilli: 2500,
      );
      expect(plan, everyElement((loadMilli: null, reps: 6)));
    });
  });
}
