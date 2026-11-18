import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Novo ID de linha. UUID v7 é ordenado no tempo, o que ajuda os índices,
/// e nasce no aparelho (pronto para uma sincronização futura).
///
/// Público de propósito: o Drift copia `clientDefault(newId)` para o
/// arquivo gerado, que não enxerga nomes privados.
String newId() => _uuid.v7();

/// Instante atual em UTC. Todo instante gravado no banco é UTC.
DateTime nowUtc() => DateTime.now().toUtc();

/// "Dia" do evento no fuso do aparelho, no formato AAAA-MM-DD.
String localDateOf(DateTime instant) =>
    DateFormat('yyyy-MM-dd').format(instant.toLocal());
