// Balanças "OKOK" (chip Chipsea) que anunciam o peso pelo Bluetooth LE,
// sem parear: o valor vem no manufacturer data de cada anúncio. Formatos
// reimplementados a partir da descrição do protocolo documentada pelo
// projeto openScale (sem copiar código). Os bytes aqui são o payload SEM os
// 2 bytes do company ID, como o Android entrega.

/// Uma leitura da balança.
class ScaleReading {
  const ScaleReading({
    required this.weightKg,
    required this.variant,
    this.impedanceOhm,
    this.stable,
  });
  final double weightKg;

  /// Só nos formatos que mandam (V20 e C0). 0 = ainda medindo / descalço não.
  final double? impedanceOhm;

  /// true = peso travado (final). null = o formato não informa.
  final bool? stable;

  /// "V20", "V11", "VF0" ou "C0" (para o diagnóstico).
  final String variant;
}

/// Nomes que essas balanças usam no anúncio (ou nenhum).
bool isOkokName(String? name) {
  final n = (name ?? '').trim().toLowerCase();
  return n.isEmpty ||
      n == 'adv' ||
      n == 'chipsea-ble' ||
      n.startsWith('okok') ||
      n.startsWith('yoda0') ||
      n.startsWith('yoda1');
}

/// Anuncia o serviço 0xFFF0: modelo que precisa de CONEXÃO (Chipsea GATT),
/// ainda não suportado.
bool looksLikeChipseaGatt(Iterable<String> services) => services.any(
  (s) => s.toLowerCase().startsWith('0000fff0') || s.toLowerCase() == 'fff0',
);

/// Tenta ler o peso de um anúncio. Null se não for uma balança conhecida
/// (ou se o checksum não bater).
ScaleReading? parseOkokAdvertisement({
  required String? name,
  required List<({int companyId, List<int> payload})> manufacturerData,
}) {
  if (!isOkokName(name)) return null;
  // Mesma ordem de preferência do protocolo: V20, V11, VF0, C0.
  for (final parse in [_v20, _v11, _vf0, _c0]) {
    for (final m in manufacturerData) {
      final r = parse(m.companyId, m.payload);
      if (r != null) return r;
    }
  }
  return null;
}

int _u16be(List<int> p, int i) => (p[i] << 8) | p[i + 1];

int _xor(List<int> p, int from, int toInclusive, int seed) {
  var x = seed;
  for (var i = from; i <= toInclusive; i++) {
    x ^= p[i];
  }
  return x & 0xFF;
}

/// Divisor pelos bits de resolução (0 → 10, 1 → 1, 2 → 100, 3 → 10).
int _divisor(int bits) => switch (bits & 0x3) {
  1 => 1,
  2 => 100,
  _ => 10,
};

/// Converte para kg pela unidade da balança (0 kg, 1 jin, 2 lb, 3 st:lb).
double _toKg(int raw, int divisor, int unit) => switch (unit & 0x3) {
  1 => raw / divisor / 2,
  2 => raw / divisor / 2.204623,
  3 => (raw >> 8) * 6.350293 + (raw & 0xFF) / divisor * 0.453592,
  _ => raw / divisor,
};

ScaleReading? _v20(int companyId, List<int> p) {
  if (companyId != 0x20CA || p.length != 19) return null;
  if (_xor(p, 0, 11, 0x20) != p[12]) return null;
  final flags = p[6];
  final div = (flags & 0x04) != 0 ? 100 : 10;
  return ScaleReading(
    weightKg: _u16be(p, 8) / div,
    impedanceOhm: _u16be(p, 10) / 10,
    stable: (flags & 0x01) != 0,
    variant: 'V20',
  );
}

ScaleReading? _v11(int companyId, List<int> p) {
  if (companyId != 0x11CA || p.length != 23) return null;
  if (_xor(p, 0, 15, 0xCA ^ 0x11) != p[16]) return null;
  final props = p[9];
  return ScaleReading(
    weightKg: _toKg(_u16be(p, 3), _divisor(props >> 1), props >> 3),
    variant: 'V11',
  );
}

ScaleReading? _vf0(int companyId, List<int> p) {
  if (companyId != 0xF0FF || p.length < 4) return null;
  // Little-endian nos bytes 2–3.
  return ScaleReading(weightKg: ((p[3] << 8) | p[2]) / 10, variant: 'VF0');
}

ScaleReading? _c0(int companyId, List<int> p) {
  if ((companyId & 0xFF) != 0xC0 || p.length < 13) return null;
  final attrib = p[6];
  return ScaleReading(
    weightKg: _toKg(_u16be(p, 0), _divisor(attrib >> 1), attrib >> 3),
    impedanceOhm: _u16be(p, 2) / 10,
    stable: (attrib & 0x01) != 0,
    variant: 'C0',
  );
}

/// "0A1B2C..." para o diagnóstico.
String hexBytes(List<int> bytes) => bytes
    .map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase())
    .join(' ');
