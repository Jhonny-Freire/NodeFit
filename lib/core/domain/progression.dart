/// Uma série de trabalho já feita (para calcular a próxima).
typedef DoneSet = ({int loadMilli, int reps});

/// O que tentar na próxima vez, série a série.
typedef SetTarget = ({int loadMilli, int reps});

/// Série planejada (carga e reps podem ficar vazias).
typedef PlannedSet = ({int? loadMilli, int? reps});

/// As [targetSets] séries de trabalho da próxima vez numa ficha:
/// - com histórico completo na mesma unidade e faixa de reps → sugestão da
///   dupla progressão;
/// - com histórico (unidade diferente ou sem faixa) → repete reps (e carga,
///   se a unidade for a mesma);
/// - sem histórico → só o fundo da faixa nas reps.
/// Se a ficha pede mais séries que a última vez, repete a última.
List<PlannedSet> planWorkingSets({
  required List<PlannedSet> previousWorking,
  required bool sameUnit,
  required int targetSets,
  int? repMin,
  int? repMax,
  required int incrementMilli,
}) {
  if (targetSets <= 0) return const [];
  T at<T>(List<T> list, int i) => list[i < list.length ? i : list.length - 1];

  final complete = [
    for (final s in previousWorking)
      if (s.loadMilli != null && s.reps != null)
        (loadMilli: s.loadMilli!, reps: s.reps!),
  ];
  if (sameUnit &&
      repMin != null &&
      repMax != null &&
      repMax >= repMin &&
      complete.isNotEmpty) {
    final next = doubleProgression(
      lastWorkingSets: complete,
      repMin: repMin,
      repMax: repMax,
      incrementMilli: incrementMilli,
    );
    return [
      for (var i = 0; i < targetSets; i++)
        (loadMilli: at(next, i).loadMilli, reps: at(next, i).reps),
    ];
  }
  if (previousWorking.isNotEmpty) {
    return [
      for (var i = 0; i < targetSets; i++)
        (
          loadMilli: sameUnit ? at(previousWorking, i).loadMilli : null,
          reps: at(previousWorking, i).reps,
        ),
    ];
  }
  return [for (var i = 0; i < targetSets; i++) (loadMilli: null, reps: repMin)];
}

/// Dupla progressão (docs/PLANO.md, 7.1). A ficha define uma faixa
/// (ex.: 3 × 8–12):
/// - se TODAS as séries chegaram ao topo da faixa → carga + 1 incremento
///   do aparelho e volta ao fundo da faixa;
/// - senão → mesma carga, +1 rep nas séries abaixo do topo.
///
/// O app só sugere; nunca muda nada sozinho. Retorna lista vazia se não
/// houver séries anteriores.
List<SetTarget> doubleProgression({
  required List<DoneSet> lastWorkingSets,
  required int repMin,
  required int repMax,
  required int incrementMilli,
}) {
  assert(repMin >= 1 && repMax >= repMin, 'faixa inválida');
  if (lastWorkingSets.isEmpty) return const [];

  final allAtTop = lastWorkingSets.every((s) => s.reps >= repMax);
  if (allAtTop) {
    return [
      for (final s in lastWorkingSets)
        (loadMilli: s.loadMilli + incrementMilli, reps: repMin),
    ];
  }
  return [
    for (final s in lastWorkingSets)
      (
        loadMilli: s.loadMilli,
        reps: s.reps >= repMax ? s.reps : (s.reps + 1).clamp(repMin, repMax),
      ),
  ];
}
