/// Segunda-feira da semana de [day] (só a data, sem hora).
DateTime weekStart(DateTime day) {
  final d = DateTime(day.year, day.month, day.day);
  return d.subtract(Duration(days: d.weekday - DateTime.monday));
}

/// Quantas semanas seguidas (segunda a domingo) têm pelo menos um treino.
/// A semana atual sem treino ainda não quebra a sequência: conta a partir
/// da semana passada.
int weekStreak(Iterable<DateTime> trainingDays, DateTime today) {
  final weeks = {for (final d in trainingDays) weekStart(d)};
  var week = weekStart(today);
  if (!weeks.contains(week)) week = _previousWeek(week);
  var streak = 0;
  while (weeks.contains(week)) {
    streak++;
    week = _previousWeek(week);
  }
  return streak;
}

/// Dias diferentes com treino na semana de [today].
int daysThisWeek(Iterable<DateTime> trainingDays, DateTime today) {
  final start = weekStart(today);
  return {
    for (final d in trainingDays)
      if (weekStart(d) == start) DateTime(d.year, d.month, d.day),
  }.length;
}

// Sem Duration(days: 7): no horário de verão um dia pode ter 23 h.
DateTime _previousWeek(DateTime monday) =>
    DateTime(monday.year, monday.month, monday.day - 7);
