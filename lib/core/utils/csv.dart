// CSV que o Excel em pt-BR abre direto: separador ";", vírgula decimal,
// UTF-8 com BOM (senão os acentos quebram) e fim de linha CRLF.

/// Uma célula: entre aspas só quando precisa (";", aspas ou quebra de linha).
String csvCell(String value) {
  if (value.contains(RegExp('[;"\r\n]'))) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

/// Número sem separador de milhar e com vírgula decimal ("1250,5"). Null
/// vira célula vazia.
String csvNumber(num? value) {
  if (value == null) return '';
  if (value == value.roundToDouble()) return value.round().toString();
  return value
      .toStringAsFixed(3)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceAll('.', ',');
}

/// Arquivo inteiro (com BOM).
String toCsv(List<List<String>> rows) =>
    '﻿${rows.map((r) => r.map(csvCell).join(';')).join('\r\n')}\r\n';
