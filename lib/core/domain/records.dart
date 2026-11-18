import 'one_rep_max.dart';
import 'progression.dart';

enum RecordKind {
  load('Carga'),
  e1rm('1RM estimado');

  const RecordKind(this.label);
  final String label;
}

/// A série [set] bate um recorde da estação? Compara com TODAS as séries de
/// trabalho anteriores ([history]), inclusive as de hoje que vieram antes.
/// - carga maior que qualquer outra → recorde de carga;
/// - senão, 1RM estimado maior (ex.: mesma carga, mais reps) → recorde de
///   1RM, só quando [allowE1rm] (não vale para "placa 7").
/// Primeira vez na estação não é recorde.
RecordKind? recordOf({
  required List<DoneSet> history,
  required DoneSet set,
  bool allowE1rm = true,
}) {
  if (history.isEmpty || set.reps <= 0) return null;
  final maxLoad = history
      .map((s) => s.loadMilli)
      .reduce((a, b) => a > b ? a : b);
  if (set.loadMilli > maxLoad) return RecordKind.load;
  if (!allowE1rm) return null;
  final mine = epley(set.loadMilli / 1000, set.reps);
  if (mine == null) return null;
  final best = history
      .map((s) => epley(s.loadMilli / 1000, s.reps) ?? 0)
      .fold(0.0, (a, b) => a > b ? a : b);
  return mine > best + 0.01 ? RecordKind.e1rm : null;
}
