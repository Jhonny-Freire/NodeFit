import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/utils/csv.dart';

void main() {
  test('números no formato do Excel brasileiro', () {
    expect(csvNumber(42.5), '42,5');
    expect(csvNumber(1250), '1250');
    expect(csvNumber(80.125), '80,125');
    expect(csvNumber(null), '');
  });

  test('aspas só quando precisa', () {
    expect(csvCell('Supino reto'), 'Supino reto');
    expect(csvCell('pesado; joelho ok'), '"pesado; joelho ok"');
    expect(csvCell('disse "uau"'), '"disse ""uau"""');
  });

  test('arquivo com BOM, ";" e CRLF', () {
    final csv = toCsv([
      ['data', 'carga'],
      ['2026-10-26', csvNumber(42.5)],
    ]);
    expect(csv, '﻿data;carga\r\n2026-10-26;42,5\r\n');
  });
}
