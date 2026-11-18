import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/domain/superset.dart';

void main() {
  group('Bi-set: grupos', () {
    test('normalizar: vizinhos iguais viram grupo; sozinho deixa de ser', () {
      expect(normalizeSupersets([7, 7, null, 3, 9, 9, 9]), [
        1,
        1,
        null,
        null,
        2,
        2,
        2,
      ]);
      // Mesmo número separado por outro exercício = grupos diferentes.
      expect(normalizeSupersets([5, 5, null, 5, 5]), [1, 1, null, 2, 2]);
    });
    test('juntar com o próximo cria bi-set e depois tri-set', () {
      var g = <int?>[null, null, null, null];
      g = linkWithNext(g, 1);
      expect(g, [null, 1, 1, null]);
      g = linkWithNext(g, 2);
      expect(g, [null, 1, 1, 1], reason: 'tri-set');
      g = linkWithNext(g, 0);
      expect(g, [1, 1, 1, 1]);
    });
    test('juntar dois grupos vizinhos', () {
      expect(linkWithNext([1, 1, 2, 2], 1), [1, 1, 1, 1]);
    });
    test('o último não tem com quem juntar', () {
      expect(linkWithNext([null, null], 1), [null, null]);
    });
    test('tirar do grupo', () {
      expect(unlinkAt([1, 1, 1], 2), [1, 1, null]);
      expect(unlinkAt([1, 1], 0), [null, null], reason: 'sobra um só');
      expect(unlinkAt([1, 1, 1], 1), [null, null, null]);
    });
    test('posição no grupo', () {
      final g = [null, 1, 1, 1];
      expect(supersetSlot(g, 0), isNull);
      expect(supersetSlot(g, 2), (position: 2, size: 3));
      expect(supersetMembers(g, 3), [1, 2, 3]);
      expect(supersetMembers(g, 0), [0]);
    });
  });

  group('Bi-set: próxima série', () {
    test('A1 → A2 sem descanso; A2 → A1 com descanso', () {
      expect(supersetStep([true, true], 0), (next: 1, rest: false));
      expect(supersetStep([true, true], 1), (next: 0, rest: true));
    });
    test('quem acabou sai da rodada', () {
      // A tem 4 séries, B só 3: depois da última de B, A continua sozinho.
      expect(supersetStep([true, false], 1), (next: 0, rest: true));
      expect(supersetStep([true, false], 0), (next: 0, rest: true));
    });
    test('grupo terminado', () {
      expect(supersetStep([false, false], 1), isNull);
    });
  });
}
