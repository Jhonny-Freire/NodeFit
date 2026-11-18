import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../domain/body.dart';
import '../domain/enums.dart';
import '../utils/ids.dart';
import 'app_database.steps.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Gyms,
    Equipment,
    Exercises,
    Stations,
    StationSettings,
    StationSettingChanges,
    Routines,
    RoutineExercises,
    WorkoutSessions,
    SessionExercises,
    WorkoutSets,
    BodyCheckins,
    BodyValues,
    BodyPhotos,
    AppPrefs,
    Users,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Sem argumento abre o arquivo do app. Nos testes, passe
  /// `NativeDatabase.memory()`.
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Nome do arquivo (sem extensão) dentro da pasta privada do app.
  static const fileName = 'nodefit';

  // Ao mudar o schema: suba este número, rode
  // `dart run drift_dev make-migrations` e escreva o passo em `onUpgrade`.
  @override
  int get schemaVersion => 4;

  bool _closed = false;

  /// Fechar duas vezes não faz nada (a restauração fecha o banco antes de o
  /// provider ser descartado).
  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await super.close();
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: stepByStep(
      // v2: cardio e exercícios por tempo.
      from1To2: (m, schema) async {
        await m.addColumn(schema.exercises, schema.exercises.tracking);
        await m.addColumn(schema.workoutSets, schema.workoutSets.durationSec);
        await m.addColumn(schema.workoutSets, schema.workoutSets.distanceM);
      },
      // v3: evolução física (check-ins, medidas e fotos).
      from2To3: (m, schema) async {
        await m.createTable(schema.bodyCheckins);
        await m.createTable(schema.bodyValues);
        await m.createTable(schema.bodyPhotos);
        await m.createIndex(schema.idxBodyCheckinsTaken);
        await m.createIndex(schema.idxBodyValuesMetric);
      },
      // v4: contas locais (login/cadastro). Só cria a tabela nova: nenhum
      // treino existente é tocado.
      from3To4: (m, schema) async {
        await m.createTable(schema.users);
      },
    ),
    beforeOpen: (details) async {
      // O SQLite vem com chaves estrangeiras desligadas por padrão.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(
    name: fileName,
    // Pasta privada do app (Context.filesDir no Android): fora da Galeria,
    // apagada ao desinstalar — por isso o backup ZIP existe.
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
    // Versão web (demonstração no navegador): o mesmo SQLite compilado para
    // WebAssembly, gravado no armazenamento do navegador (OPFS/IndexedDB).
    // Os dois arquivos ficam em web/ (copiados do pacote drift).
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
