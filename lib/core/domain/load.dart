import 'package:intl/intl.dart';

import 'enums.dart';

// Cargas são inteiros: o valor que você lê na máquina × 1000, na unidade
// do aparelho. 62,5 kg = 62500; 45 lb = 45000; "placa 7" = 7000.
// Assim não há erro de ponto flutuante, e "Anterior", recordes e
// progressão funcionam igual para qualquer máquina.

const _kgPerLb = 0.45359237;

final _number = NumberFormat('#,##0.##', 'pt_BR');

/// "62,5", "40", "1.250" — sem zeros sobrando.
String formatNumber(num value) => _number.format(value);

/// "62,5 kg", "45 lb", "placa 7", ou "—" quando vazio.
String formatLoad(int? loadMilli, LoadUnit unit) {
  if (loadMilli == null) return '—';
  final value = formatNumber(loadMilli / 1000);
  return switch (unit) {
    LoadUnit.plate => 'placa $value',
    LoadUnit.kg || LoadUnit.lb => '$value ${unit.label}',
  };
}

/// Só o número ("62,5"), para colunas onde a unidade já aparece.
String formatLoadValue(int? loadMilli) =>
    loadMilli == null ? '—' : formatNumber(loadMilli / 1000);

/// Lê o que a pessoa digitou ("62,5", "62.5", "62") → 62500.
/// Aceita vírgula ou ponto. Retorna null se não for um número válido.
int? parseLoadMilli(String text) {
  final cleaned = text.trim().replaceAll(' ', '').replaceAll(',', '.');
  if (cleaned.isEmpty) return null;
  final value = double.tryParse(cleaned);
  if (value == null || value < 0 || value > 10000) return null;
  return (value * 1000).round();
}

/// Carga total em kg, para volume e exibição. Null para aparelhos em
/// "nº da placa", porque o banco não sabe quanto pesa cada placa.
double? totalKg({
  required int loadMilli,
  required LoadUnit unit,
  required LoadBasis basis,
  int? baseLoadMilli,
}) {
  final perUnitKg = switch (unit) {
    LoadUnit.kg => 1.0,
    LoadUnit.lb => _kgPerLb,
    LoadUnit.plate => null,
  };
  if (perUnitKg == null) return null;
  final multiplier = switch (basis) {
    LoadBasis.total => 1,
    LoadBasis.perSide || LoadBasis.perHand => 2,
  };
  final base = (baseLoadMilli ?? 0) / 1000;
  return (loadMilli / 1000 * multiplier + base) * perUnitKg;
}
