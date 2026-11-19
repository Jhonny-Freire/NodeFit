import 'package:drift/drift.dart';

import '../domain/body.dart';
import '../domain/enums.dart';
import '../utils/ids.dart';

// Schema v1 — o mapa completo está em docs/PLANO.md, seção 5.1.
//
// Convenções:
// - `id` é texto (UUID v7, ou slug nos exercícios embarcados);
// - instantes em UTC (`nowUtc`); "dia" do treino em `localDate` (AAAA-MM-DD);
// - cargas em inteiros: valor mostrado na máquina × 1000, na unidade do aparelho;
// - coisas com histórico são arquivadas (`archivedAt`), não apagadas.

class Gyms extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Um aparelho específico de uma academia ("Leg press 45° preto").
@DataClassName('EquipmentItem')
@TableIndex(name: 'idx_equipment_gym', columns: {#gymId})
class Equipment extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get gymId => text().references(Gyms, #id)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get type => textEnum<EquipmentType>()();

  /// Número ou etiqueta do aparelho na academia ("14").
  TextColumn get gymLabel => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get loadUnit => textEnum<LoadUnit>()();
  TextColumn get loadBasis => textEnum<LoadBasis>()();

  /// Menor salto de carga (× 1000). Ex.: 2500 = 2,5 kg; 1000 = 1 placa.
  IntColumn get incrementMilli => integer().withDefault(const Constant(2500))();

  /// Carga do carrinho/barra (× 1000), somada no total em kg.
  IntColumn get baseLoadMilli => integer().nullable()();

  /// Aparelho que este substituiu (a academia trocou a máquina).
  TextColumn get replacesEquipmentId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'idx_exercises_search', columns: {#searchText})
class Exercises extends Table {
  /// Slug nos embarcados ("supino-reto-barra"), UUID nos criados pelo usuário.
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get name => text().withLength(min: 1, max: 120)();

  /// Nome + apelidos normalizados (minúsculas, sem acento) para a busca.
  TextColumn get searchText => text()();

  /// Apelidos separados por " | ".
  TextColumn get aliases => text().withDefault(const Constant(''))();
  TextColumn get equipmentType => textEnum<EquipmentType>()();

  /// O que se anota: carga × reps, tempo, ou tempo e distância (schema v2).
  TextColumn get tracking => textEnum<TrackingType>().withDefault(
    Constant(TrackingType.weightReps.name),
  )();

  /// Chaves de `Muscle` separadas por vírgula.
  TextColumn get primaryMuscles => text().withDefault(const Constant(''))();
  TextColumn get secondaryMuscles => text().withDefault(const Constant(''))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get seedVersion => integer().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// ESTAÇÃO = exercício × aparelho (nesta academia). É onde moram os ajustes,
/// a nota fixada e o histórico de carga. Única por (exercício, academia,
/// aparelho) — garantido no repositório, porque o SQLite trata NULL
/// como valor distinto em UNIQUE.
@TableIndex(
  name: 'idx_stations_lookup',
  columns: {#exerciseId, #gymId, #equipmentId},
)
class Stations extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  TextColumn get gymId => text().references(Gyms, #id)();

  /// Nulo para exercício sem aparelho (flexão, prancha...).
  TextColumn get equipmentId => text().nullable().references(Equipment, #id)();
  TextColumn get pinnedNote => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Um ajuste da estação ("Banco = 7"), com o valor atual.
@TableIndex(name: 'idx_settings_station', columns: {#stationId, #sortOrder})
class StationSettings extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get stationId =>
      text().references(Stations, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text().withLength(min: 1, max: 40)();
  TextColumn get kind => textEnum<SettingKind>()();
  RealColumn get valueNum => real().nullable()();
  TextColumn get valueText => text().nullable()();
  RealColumn get step => real().withDefault(const Constant(1.0))();
  TextColumn get photoPath => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Histórico dos ajustes ("Banco 7 → 8 em 14/10"). Só cresce.
@TableIndex(name: 'idx_setting_changes', columns: {#settingId, #changedAt})
class StationSettingChanges extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get settingId =>
      text().references(StationSettings, #id, onDelete: KeyAction.cascade)();
  TextColumn get oldValue => text().nullable()();
  TextColumn get newValue => text().nullable()();
  TextColumn get sessionId => text().nullable().references(
    WorkoutSessions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  DateTimeColumn get changedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Ficha (A, B, C...). Usada a partir da Fatia 2.
class Routines extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get label => text().nullable()();
  TextColumn get gymId => text().nullable().references(Gyms, #id)();
  TextColumn get trainer => text().nullable()();

  /// Vencimento da ficha (AAAA-MM-DD).
  TextColumn get expiresOn => text().nullable()();

  /// Data planejada do próximo treino com esta ficha (AAAA-MM-DD).
  /// Pode estar no futuro (vai acontecer) ou no passado (já passou).
  TextColumn get nextOn => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'idx_routine_exercises', columns: {#routineId, #position})
class RoutineExercises extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get routineId =>
      text().references(Routines, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  TextColumn get preferredEquipmentId =>
      text().nullable().references(Equipment, #id)();
  IntColumn get position => integer()();
  IntColumn get targetSets => integer().withDefault(const Constant(3))();
  IntColumn get repMin => integer().nullable()();
  IntColumn get repMax => integer().nullable()();
  IntColumn get targetRir => integer().nullable()();
  IntColumn get restSec => integer().nullable()();
  IntColumn get warmupSets => integer().withDefault(const Constant(0))();

  /// Cadência prescrita ("3-1-1-0"). Não se digita por série.
  TextColumn get tempo => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get supersetGroup => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(name: 'idx_sessions_started', columns: {#startedAt})
class WorkoutSessions extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get routineId => text().nullable().references(
    Routines,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get gymId => text().references(Gyms, #id)();

  /// Cópia do nome da ficha naquele dia ("Treino livre" se não houver).
  TextColumn get title => text()();
  DateTimeColumn get startedAt => dateTime().clientDefault(nowUtc)();

  /// Nulo enquanto o treino está em andamento.
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get localDate => text()();

  /// Instante absoluto em que o descanso atual termina. A tela calcula
  /// `restante = restEndsAt − agora`, então o timer sobrevive ao app fechar.
  DateTimeColumn get restEndsAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// O exercício como foi feito naquele dia. Guarda CÓPIAS da unidade e das
/// metas: editar o aparelho ou a ficha depois não reescreve o passado.
@TableIndex(name: 'idx_session_exercises_session', columns: {#sessionId})
@TableIndex(name: 'idx_session_exercises_station', columns: {#stationId})
class SessionExercises extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get stationId => text().references(Stations, #id)();
  TextColumn get exerciseId => text().references(Exercises, #id)();
  TextColumn get routineExerciseId => text().nullable().references(
    RoutineExercises,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get position => integer()();
  TextColumn get loadUnit => textEnum<LoadUnit>()();
  TextColumn get loadBasis => textEnum<LoadBasis>()();
  IntColumn get incrementMilli => integer()();
  IntColumn get targetSets => integer().nullable()();
  IntColumn get repMin => integer().nullable()();
  IntColumn get repMax => integer().nullable()();
  IntColumn get restSec => integer()();

  /// "Como foi" — volta em cinza na próxima vez nesta estação.
  TextColumn get howItWent => text().nullable()();
  TextColumn get effortTag => textEnum<EffortTag>().nullable()();
  BoolColumn get pain => boolean().withDefault(const Constant(false))();
  IntColumn get supersetGroup => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@TableIndex(
  name: 'idx_sets_session_exercise',
  columns: {#sessionExerciseId, #position},
)
class WorkoutSets extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get sessionExerciseId =>
      text().references(SessionExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get setType => textEnum<SetType>()();

  /// Valor mostrado na máquina × 1000, na unidade da sessão.
  IntColumn get loadMilli => integer().nullable()();
  IntColumn get reps => integer().nullable()();

  /// Tempo da série em segundos (prancha, esteira) — schema v2.
  IntColumn get durationSec => integer().nullable()();

  /// Distância em metros (esteira, bicicleta) — schema v2.
  IntColumn get distanceM => integer().nullable()();

  /// Repetições na reserva (aceita 0,5). RPE = 10 − RIR.
  RealColumn get rir => real().nullable()();

  /// Nulo = série só planejada; preenchido = concluída.
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// ───────────── Evolução física (schema v3) ─────────────

/// Um check-in do corpo: pesagem, medidas e fotos de um dia.
@TableIndex(name: 'idx_body_checkins_taken', columns: {#takenAt})
class BodyCheckins extends Table {
  TextColumn get id => text().clientDefault(newId)();
  DateTimeColumn get takenAt => dateTime().clientDefault(nowUtc)();
  TextColumn get localDate => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();
  DateTimeColumn get updatedAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Um valor do check-in (peso, cintura, % de gordura da balança...),
/// × 1000 na unidade da medida. No máximo um por medida.
@TableIndex(name: 'idx_body_values_metric', columns: {#metric})
class BodyValues extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get checkinId =>
      text().references(BodyCheckins, #id, onDelete: KeyAction.cascade)();
  TextColumn get metric => textEnum<BodyMetric>()();
  IntColumn get valueMilli => integer()();
  TextColumn get source =>
      textEnum<BodySource>().withDefault(Constant(BodySource.manual.name))();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {checkinId, metric},
  ];
}

/// Foto de progresso, na pasta privada do app (fora da Galeria).
class BodyPhotos extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get checkinId =>
      text().references(BodyCheckins, #id, onDelete: KeyAction.cascade)();
  TextColumn get pose => textEnum<PhotoPose>()();

  /// Relativo à pasta de suporte do app (ex.: "photos/body/abc.jpg"), para
  /// sobreviver ao backup/restauração.
  TextColumn get path => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Preferências simples (chave → valor em texto).
class AppPrefs extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Conta local do app (schema v4, projeto P2 da Fatec).
///
/// A senha nunca é gravada: só o hash PBKDF2-HMAC-SHA256 e o sal aleatório
/// de cada usuário (ver `core/domain/credentials.dart`). O e-mail é salvo
/// normalizado (minúsculas, sem espaços) e é único.
@DataClassName('AppUser')
class Users extends Table {
  TextColumn get id => text().clientDefault(newId)();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get email => text().withLength(min: 3, max: 120).unique()();
  TextColumn get passwordHash => text()();
  TextColumn get passwordSalt => text()();
  DateTimeColumn get createdAt => dateTime().clientDefault(nowUtc)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
