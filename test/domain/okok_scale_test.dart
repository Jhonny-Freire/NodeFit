import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/domain/okok_scale.dart';

/// XOR de [p] (do índice 0 até [to]) começando por [seed].
int xor(List<int> p, int to, int seed) {
  var x = seed;
  for (var i = 0; i <= to; i++) {
    x ^= p[i];
  }
  return x & 0xFF;
}

void main() {
  test('V20 (0x20CA): peso ÷100, impedância e checksum', () {
    // 64,35 kg = 6435 = 0x1923; impedância 512,3 Ω = 5123 = 0x1403.
    final p = List<int>.filled(19, 0);
    p[6] = 0x01 | 0x04; // estável + resolução ÷100
    p[8] = 0x19;
    p[9] = 0x23;
    p[10] = 0x14;
    p[11] = 0x03;
    p[12] = xor(p, 11, 0x20);
    final r = parseOkokAdvertisement(
      name: 'Chipsea-BLE',
      manufacturerData: [(companyId: 0x20CA, payload: p)],
    )!;
    expect(r.variant, 'V20');
    expect(r.weightKg, closeTo(64.35, 1e-9));
    expect(r.impedanceOhm, closeTo(512.3, 1e-9));
    expect(r.stable, isTrue);

    // Checksum errado: ignora.
    final bad = [...p]..[12] ^= 0xFF;
    expect(
      parseOkokAdvertisement(
        name: 'Chipsea-BLE',
        manufacturerData: [(companyId: 0x20CA, payload: bad)],
      ),
      isNull,
    );
  });

  test('C0: peso ÷10 ainda medindo (não estável)', () {
    // 80,4 kg = 804 = 0x0324; resolução bits = 0 (÷10), kg.
    final p = List<int>.filled(13, 0);
    p[0] = 0x03;
    p[1] = 0x24;
    p[6] = 0x00;
    final r = parseOkokAdvertisement(
      name: null,
      manufacturerData: [(companyId: 0x12C0, payload: p)],
    )!;
    expect(r.variant, 'C0');
    expect(r.weightKg, closeTo(80.4, 1e-9));
    expect(r.stable, isFalse);
  });

  test('C0 em libras vira kg', () {
    // 177,2 lb (÷10) = 1772 = 0x06EC; unit=2 (lb) → bits 3–4 = 0b10.
    final p = List<int>.filled(13, 0);
    p[0] = 0x06;
    p[1] = 0xEC;
    p[6] = 0x01 | (2 << 3);
    final r = parseOkokAdvertisement(
      name: 'ADV',
      manufacturerData: [(companyId: 0x00C0, payload: p)],
    )!;
    expect(r.weightKg, closeTo(177.2 / 2.204623, 1e-6));
  });

  test('V11 (0x11CA) com checksum', () {
    final p = List<int>.filled(23, 0);
    p[3] = 0x02; // 0x02F8 = 760 → ÷10 = 76,0 kg
    p[4] = 0xF8;
    p[9] = 0x00;
    p[16] = xor(p, 15, 0xCA ^ 0x11);
    final r = parseOkokAdvertisement(
      name: '',
      manufacturerData: [(companyId: 0x11CA, payload: p)],
    )!;
    expect(r.variant, 'V11');
    expect(r.weightKg, closeTo(76.0, 1e-9));
    expect(r.stable, isNull);
  });

  test('VF0 (0xF0FF): little-endian ÷10', () {
    final r = parseOkokAdvertisement(
      name: 'Yoda1',
      manufacturerData: [
        (companyId: 0xF0FF, payload: [0, 0, 0x24, 0x03]),
      ],
    )!;
    expect(r.weightKg, closeTo(80.4, 1e-9));
  });

  test('outros aparelhos não viram balança', () {
    final p = List<int>.filled(13, 0)..[1] = 0x50;
    expect(
      parseOkokAdvertisement(
        name: 'Galaxy Buds',
        manufacturerData: [(companyId: 0x00C0, payload: p)],
      ),
      isNull,
      reason: 'nome que não é de balança',
    );
    expect(
      parseOkokAdvertisement(
        name: null,
        manufacturerData: [
          (companyId: 0x0075, payload: [1, 2, 3]),
        ],
      ),
      isNull,
    );
  });

  test('balança que precisa de conexão (serviço FFF0)', () {
    expect(
      looksLikeChipseaGatt(['0000fff0-0000-1000-8000-00805f9b34fb']),
      isTrue,
    );
    expect(
      looksLikeChipseaGatt(['0000180d-0000-1000-8000-00805f9b34fb']),
      isFalse,
    );
  });
}
