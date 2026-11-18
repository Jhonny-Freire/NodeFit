import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/enums.dart';
import '../../../core/domain/load.dart';
import '../../../core/utils/ids.dart';

part 'station_repository.g.dart';

/// Estação com o exercício e o aparelho já carregados, para a tela.
class StationView {
  const StationView({
    required this.station,
    required this.exercise,
    this.equipment,
  });
  final Station station;
  final Exercise exercise;
  final EquipmentItem? equipment;

  /// "Leg press 45° · Leg press 45° preto" ou só o exercício.
  String get title => equipment == null
      ? exercise.name
      : '${exercise.name} · ${equipmentDisplayName(equipment)}';
}

/// Nome do aparelho com o número dele na academia, quando houver
/// ("Cadeira extensora · nº 12") — muitas vezes o nome repete o exercício.
String equipmentDisplayName(EquipmentItem? e) {
  if (e == null) return 'Sem aparelho';
  return e.gymLabel == null ? e.name : '${e.name} · nº ${e.gymLabel}';
}

/// Uma mudança de ajuste com o nome do ajuste ("Banco 7 → 8").
class SettingChangeView {
  const SettingChangeView({required this.change, required this.label});
  final StationSettingChange change;
  final String label;
}

/// Texto do valor atual de um ajuste ("7", "3,5", "corda", "—").
String formatSettingValue(StationSetting s) => switch (s.kind) {
  SettingKind.number => s.valueNum == null ? '—' : formatNumber(s.valueNum!),
  SettingKind.text =>
    (s.valueText == null || s.valueText!.isEmpty) ? '—' : s.valueText!,
};

/// Modelos prontos para não digitar o nome do ajuste toda vez.
const settingPresets = <({String label, SettingKind kind})>[
  (label: 'Banco', kind: SettingKind.number),
  (label: 'Encosto', kind: SettingKind.number),
  (label: 'Pino', kind: SettingKind.number),
  (label: 'Altura da polia', kind: SettingKind.number),
  (label: 'Rolo / apoio', kind: SettingKind.number),
  (label: 'Inclinação', kind: SettingKind.number),
  (label: 'Pegada', kind: SettingKind.text),
  (label: 'Pés', kind: SettingKind.text),
];

class StationRepository {
  StationRepository(this._db);
  final AppDatabase _db;

  /// A estação de (exercício, academia, aparelho). Cria se não existir.
  Future<Station> getOrCreate({
    required String exerciseId,
    required String gymId,
    String? equipmentId,
  }) => _db.transaction(() async {
    final existing =
        await (_db.select(_db.stations)
              ..where(
                (s) =>
                    s.exerciseId.equals(exerciseId) &
                    s.gymId.equals(gymId) &
                    (equipmentId == null
                        ? s.equipmentId.isNull()
                        : s.equipmentId.equals(equipmentId)),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing;
    return _db
        .into(_db.stations)
        .insertReturning(
          StationsCompanion.insert(
            exerciseId: exerciseId,
            gymId: gymId,
            equipmentId: Value(equipmentId),
          ),
        );
  });

  JoinedSelectStatement<HasResultSet, dynamic> _viewQuery() =>
      _db.select(_db.stations).join([
        innerJoin(
          _db.exercises,
          _db.exercises.id.equalsExp(_db.stations.exerciseId),
        ),
        leftOuterJoin(
          _db.equipment,
          _db.equipment.id.equalsExp(_db.stations.equipmentId),
        ),
      ]);

  StationView _readView(TypedResult row) => StationView(
    station: row.readTable(_db.stations),
    exercise: row.readTable(_db.exercises),
    equipment: row.readTableOrNull(_db.equipment),
  );

  Stream<StationView?> watchStationView(String stationId) {
    final q = _viewQuery()..where(_db.stations.id.equals(stationId));
    return q.watchSingleOrNull().map((r) => r == null ? null : _readView(r));
  }

  /// Estação com uso real: foi treinada, tem ajuste ou nota. Evita listar
  /// "órfãs" (escolheu o aparelho por engano e trocou).
  Expression<bool> _stationInUse() =>
      existsQuery(
        _db.select(_db.sessionExercises)
          ..where((e) => e.stationId.equalsExp(_db.stations.id)),
      ) |
      existsQuery(
        _db.select(_db.stationSettings)
          ..where((s) => s.stationId.equalsExp(_db.stations.id)),
      ) |
      _db.stations.pinnedNote.isNotNull();

  /// Exercícios já feitos neste aparelho (as estações dele).
  Stream<List<StationView>> watchStationsForEquipment(String equipmentId) {
    final q = _viewQuery()
      ..where(
        _db.stations.equipmentId.equals(equipmentId) &
            _db.stations.archivedAt.isNull() &
            _stationInUse(),
      )
      ..orderBy([OrderingTerm.asc(_db.exercises.name)]);
    return q.watch().map((rows) => rows.map(_readView).toList());
  }

  /// Exercícios feitos SEM aparelho nesta academia (flexão, prancha...).
  Stream<List<StationView>> watchStationsWithoutEquipment(String gymId) {
    final q = _viewQuery()
      ..where(
        _db.stations.gymId.equals(gymId) &
            _db.stations.equipmentId.isNull() &
            _db.stations.archivedAt.isNull() &
            _stationInUse(),
      )
      ..orderBy([OrderingTerm.asc(_db.exercises.name)]);
    return q.watch().map((rows) => rows.map(_readView).toList());
  }

  /// Último aparelho usado neste exercício nesta academia (para sugerir).
  /// Ignora aparelhos arquivados; null se da última vez foi sem aparelho.
  Future<String?> lastEquipmentIdFor({
    required String exerciseId,
    required String gymId,
  }) async {
    final q =
        _db.select(_db.sessionExercises).join([
            innerJoin(
              _db.stations,
              _db.stations.id.equalsExp(_db.sessionExercises.stationId),
            ),
            leftOuterJoin(
              _db.equipment,
              _db.equipment.id.equalsExp(_db.stations.equipmentId),
            ),
          ])
          ..where(
            _db.stations.exerciseId.equals(exerciseId) &
                _db.stations.gymId.equals(gymId) &
                (_db.stations.equipmentId.isNull() |
                    _db.equipment.archivedAt.isNull()),
          )
          ..orderBy([OrderingTerm.desc(_db.sessionExercises.createdAt)])
          ..limit(1);
    final row = await q.getSingleOrNull();
    return row?.readTable(_db.stations).equipmentId;
  }

  /// Como foi da última vez neste exercício nesta academia: [found] diz se
  /// já fez; [equipmentId] é o aparelho (null = sem aparelho). Aparelho
  /// arquivado conta como "não sei" (found = false).
  Future<({bool found, String? equipmentId})> lastUseFor({
    required String exerciseId,
    required String gymId,
  }) async {
    final q =
        _db.select(_db.sessionExercises).join([
            innerJoin(
              _db.stations,
              _db.stations.id.equalsExp(_db.sessionExercises.stationId),
            ),
            leftOuterJoin(
              _db.equipment,
              _db.equipment.id.equalsExp(_db.stations.equipmentId),
            ),
          ])
          ..where(
            _db.stations.exerciseId.equals(exerciseId) &
                _db.stations.gymId.equals(gymId),
          )
          ..orderBy([OrderingTerm.desc(_db.sessionExercises.createdAt)])
          ..limit(1);
    final row = await q.getSingleOrNull();
    if (row == null) return (found: false, equipmentId: null);
    final equipment = row.readTableOrNull(_db.equipment);
    if (equipment != null && equipment.archivedAt != null) {
      return (found: false, equipmentId: null);
    }
    return (found: true, equipmentId: equipment?.id);
  }

  // ───────────────────────── Ajustes ─────────────────────────

  Stream<List<StationSetting>> watchSettings(String stationId) =>
      (_db.select(_db.stationSettings)
            ..where(
              (s) => s.stationId.equals(stationId) & s.archivedAt.isNull(),
            )
            ..orderBy([
              (s) => OrderingTerm.asc(s.sortOrder),
              (s) => OrderingTerm.asc(s.createdAt),
            ]))
          .watch();

  Future<StationSetting> addSetting({
    required String stationId,
    required String label,
    required SettingKind kind,
    double? valueNum,
    String? valueText,
    double step = 1,
    String? sessionId,
  }) => _db.transaction(() async {
    final maxOrder = _db.stationSettings.sortOrder.max();
    final current =
        await (_db.selectOnly(_db.stationSettings)
              ..addColumns([maxOrder])
              ..where(_db.stationSettings.stationId.equals(stationId)))
            .map((r) => r.read(maxOrder))
            .getSingle();
    final setting = await _db
        .into(_db.stationSettings)
        .insertReturning(
          StationSettingsCompanion.insert(
            stationId: stationId,
            label: label.trim(),
            kind: kind,
            valueNum: Value(kind == SettingKind.number ? valueNum : null),
            valueText: Value(kind == SettingKind.text ? valueText : null),
            step: Value(step),
            sortOrder: Value((current ?? -1) + 1),
          ),
        );
    await _logChange(
      settingId: setting.id,
      oldValue: null,
      newValue: formatSettingValue(setting),
      sessionId: sessionId,
    );
    await _touchStation(stationId);
    return setting;
  });

  /// Muda o valor e grava no histórico ("Banco 7 → 8"). Sem mudança real,
  /// não faz nada.
  Future<void> updateSettingValue(
    StationSetting setting, {
    double? valueNum,
    String? valueText,
    String? sessionId,
  }) => _db.transaction(() async {
    final updated = setting.copyWith(
      valueNum: Value(setting.kind == SettingKind.number ? valueNum : null),
      valueText: Value(setting.kind == SettingKind.text ? valueText : null),
    );
    final oldText = formatSettingValue(setting);
    final newText = formatSettingValue(updated);
    if (oldText == newText) return;
    await (_db.update(
      _db.stationSettings,
    )..where((s) => s.id.equals(setting.id))).write(
      StationSettingsCompanion(
        valueNum: Value(updated.valueNum),
        valueText: Value(updated.valueText),
        updatedAt: Value(nowUtc()),
      ),
    );
    await _logChange(
      settingId: setting.id,
      oldValue: oldText,
      newValue: newText,
      sessionId: sessionId,
    );
    await _touchStation(setting.stationId);
  });

  Future<void> updateSettingMeta(
    String settingId, {
    required String label,
    required double step,
  }) => (_db.update(_db.stationSettings)..where((s) => s.id.equals(settingId)))
      .write(
        StationSettingsCompanion(
          label: Value(label.trim()),
          step: Value(step),
          updatedAt: Value(nowUtc()),
        ),
      );

  /// Ajuste com histórico não é apagado: é arquivado, para não perder
  /// o "7 → 8".
  Future<void> archiveSetting(String settingId) =>
      (_db.update(
        _db.stationSettings,
      )..where((s) => s.id.equals(settingId))).write(
        StationSettingsCompanion(
          archivedAt: Value(nowUtc()),
          updatedAt: Value(nowUtc()),
        ),
      );

  /// Histórico de mudanças da estação, do mais recente para o mais antigo.
  Stream<List<SettingChangeView>> watchChanges(String stationId) {
    final q =
        _db.select(_db.stationSettingChanges).join([
            innerJoin(
              _db.stationSettings,
              _db.stationSettings.id.equalsExp(
                _db.stationSettingChanges.settingId,
              ),
            ),
          ])
          ..where(_db.stationSettings.stationId.equals(stationId))
          ..orderBy([OrderingTerm.desc(_db.stationSettingChanges.changedAt)])
          ..limit(100);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          SettingChangeView(
            change: r.readTable(_db.stationSettingChanges),
            label: r.readTable(_db.stationSettings).label,
          ),
      ],
    );
  }

  Future<void> updatePinnedNote(String stationId, String? note) =>
      (_db.update(_db.stations)..where((s) => s.id.equals(stationId))).write(
        StationsCompanion(
          pinnedNote: Value(
            (note == null || note.trim().isEmpty) ? null : note.trim(),
          ),
          updatedAt: Value(nowUtc()),
        ),
      );

  Future<void> _logChange({
    required String settingId,
    required String? oldValue,
    required String? newValue,
    String? sessionId,
  }) => _db
      .into(_db.stationSettingChanges)
      .insert(
        StationSettingChangesCompanion.insert(
          settingId: settingId,
          oldValue: Value(oldValue),
          newValue: Value(newValue),
          sessionId: Value(sessionId),
        ),
      );

  Future<void> _touchStation(String stationId) =>
      (_db.update(_db.stations)..where((s) => s.id.equals(stationId))).write(
        StationsCompanion(updatedAt: Value(nowUtc())),
      );
}

@Riverpod(keepAlive: true)
StationRepository stationRepository(Ref ref) =>
    StationRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<StationView?> stationView(Ref ref, String stationId) =>
    ref.watch(stationRepositoryProvider).watchStationView(stationId);

@riverpod
Stream<List<StationView>> equipmentStations(Ref ref, String equipmentId) =>
    ref.watch(stationRepositoryProvider).watchStationsForEquipment(equipmentId);

@riverpod
Stream<List<StationView>> gymStationsWithoutEquipment(Ref ref, String gymId) =>
    ref.watch(stationRepositoryProvider).watchStationsWithoutEquipment(gymId);

@riverpod
Stream<List<StationSetting>> stationSettings(Ref ref, String stationId) =>
    ref.watch(stationRepositoryProvider).watchSettings(stationId);

@riverpod
Stream<List<SettingChangeView>> stationChanges(Ref ref, String stationId) =>
    ref.watch(stationRepositoryProvider).watchChanges(stationId);
