// Enums gravados no banco como texto (`textEnum`): o Drift grava o `.name`.
// Renomear um valor quebra os dados antigos — trate como migração.

/// Tipo de equipamento (do exercício ou do aparelho).
enum EquipmentType {
  barbell('Barra'),
  dumbbell('Halteres'),
  machine('Máquina'),
  plateLoaded('Máquina de anilhas'),
  cable('Polia / cabo'),
  smith('Smith'),
  bodyweight('Peso corporal'),
  kettlebell('Kettlebell'),
  band('Elástico'),
  other('Outro');

  const EquipmentType(this.label);
  final String label;
}

/// Unidade em que o aparelho mostra a carga.
enum LoadUnit {
  kg('kg'),
  lb('lb'),

  /// A máquina mostra o número da placa/pino, não o peso.
  plate('placa');

  const LoadUnit(this.label);
  final String label;
}

/// O que o número da carga representa.
enum LoadBasis {
  total('Total'),
  perSide('Por lado'),
  perHand('Por mão');

  const LoadBasis(this.label);
  final String label;
}

/// Tipo do valor de um ajuste do aparelho.
enum SettingKind { number, text }

/// O que se anota em cada série do exercício.
enum TrackingType {
  /// Carga × repetições (a maioria).
  weightReps('Carga e repetições'),

  /// Só o tempo (prancha, isometria).
  duration('Tempo'),

  /// Tempo e distância (esteira, bicicleta, elíptico, remo).
  cardio('Tempo e distância');

  const TrackingType(this.label);
  final String label;
}

/// Tipo da série. Aquecimento não conta para recordes nem volume.
enum SetType {
  warmup('Aquecimento', 'A'),
  working('Normal', ''),
  drop('Drop', 'D'),
  failure('Até a falha', 'F');

  const SetType(this.label, this.badge);
  final String label;

  /// Letra curta mostrada no lugar do número da série ('' = número).
  final String badge;
}

/// Como foi o exercício, em 1 toque.
enum EffortTag {
  easy('Fácil'),
  ok('Ok'),
  hard('Difícil');

  const EffortTag(this.label);
  final String label;
}
