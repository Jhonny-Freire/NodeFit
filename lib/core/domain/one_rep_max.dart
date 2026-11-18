// 1RM estimado — sempre exibido como "estimado": o erro pode passar de 10%.
// Só vale para séries de 1 a 10 repetições (acima disso as fórmulas
// divergem). Fontes: Epley (1985); Brzycki (1993). As duas coincidem em
// 10 repetições.

const maxRepsForEstimate = 10;

/// Epley: carga × (1 + reps/30). Com 1 repetição, a própria carga.
double? epley(double load, int reps) {
  if (reps < 1 || reps > maxRepsForEstimate || load <= 0) return null;
  if (reps == 1) return load;
  return load * (1 + reps / 30);
}

/// Brzycki: carga × 36 / (37 − reps). Com 1 repetição, a própria carga.
double? brzycki(double load, int reps) {
  if (reps < 1 || reps > maxRepsForEstimate || load <= 0) return null;
  return load * 36 / (37 - reps);
}
