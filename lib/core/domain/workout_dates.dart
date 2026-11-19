import 'package:intl/intl.dart';

/// Textos das datas de treino de uma ficha: o último feito e o próximo
/// planejado. Funções puras (recebem [now]) para dar para testar.

DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

/// "Último: qua 18/11". Nulo se a ficha nunca foi feita.
String? lastWorkoutText(DateTime? lastDoneAt) {
  if (lastDoneAt == null) return null;
  final day = DateFormat('EEE dd/MM').format(lastDoneAt.toLocal());
  return 'Último: $day';
}

/// Situação do próximo treino planejado ([nextOn] em AAAA-MM-DD).
///
/// - futuro: "Próximo: amanhã (20/11)" / "Próximo: em 3 dias (22/11)"
/// - hoje: "Próximo: hoje (19/11)"
/// - passado: "Próximo era 17/11 (já passou)", com [overdue] = true
({String text, bool overdue})? nextWorkoutInfo(
  String? nextOn, {
  DateTime? now,
}) {
  if (nextOn == null) return null;
  final date = DateTime.tryParse(nextOn);
  if (date == null) return null;
  final today = _day(now ?? DateTime.now());
  final days = _day(date).difference(today).inDays;
  final fmt = DateFormat('dd/MM').format(date);
  return switch (days) {
    < 0 => (text: 'Próximo era $fmt (já passou)', overdue: true),
    0 => (text: 'Próximo: hoje ($fmt)', overdue: false),
    1 => (text: 'Próximo: amanhã ($fmt)', overdue: false),
    _ => (text: 'Próximo: em $days dias ($fmt)', overdue: false),
  };
}
