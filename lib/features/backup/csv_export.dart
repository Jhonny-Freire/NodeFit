import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/domain/body.dart';
import '../../core/utils/csv.dart';

part 'csv_export.g.dart';

/// Planilhas para abrir no Excel/Google Sheets: uma linha por série feita
/// (treinos.csv) e uma por check-in (corpo.csv). Não substitui o backup:
/// é para olhar e fazer contas, não para restaurar.
class CsvExporter {
  CsvExporter(this._db);
  final AppDatabase _db;

  String _date(DateTime d) {
    final l = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${l.year}-${two(l.month)}-${two(l.day)}';
  }

  String _time(DateTime d) {
    final l = d.toLocal();
    return '${l.hour.toString().padLeft(2, '0')}:'
        '${l.minute.toString().padLeft(2, '0')}';
  }

  Future<String> workoutsCsv() async {
    final rows =
        await (_db.select(_db.workoutSets).join([
                innerJoin(
                  _db.sessionExercises,
                  _db.sessionExercises.id.equalsExp(
                    _db.workoutSets.sessionExerciseId,
                  ),
                ),
                innerJoin(
                  _db.workoutSessions,
                  _db.workoutSessions.id.equalsExp(
                    _db.sessionExercises.sessionId,
                  ),
                ),
                innerJoin(
                  _db.gyms,
                  _db.gyms.id.equalsExp(_db.workoutSessions.gymId),
                ),
                innerJoin(
                  _db.exercises,
                  _db.exercises.id.equalsExp(_db.sessionExercises.exerciseId),
                ),
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
                _db.workoutSets.completedAt.isNotNull() &
                    _db.workoutSessions.endedAt.isNotNull(),
              )
              ..orderBy([
                OrderingTerm.asc(_db.workoutSessions.startedAt),
                OrderingTerm.asc(_db.sessionExercises.position),
                OrderingTerm.asc(_db.workoutSets.position),
              ]))
            .get();
    return toCsv([
      [
        'data',
        'hora',
        'treino',
        'academia',
        'exercício',
        'aparelho',
        'série',
        'tipo',
        'carga',
        'unidade',
        'carga é',
        'reps',
        'RIR',
        'tempo (s)',
        'distância (km)',
        'como foi',
      ],
      for (final r in rows)
        () {
          final set = r.readTable(_db.workoutSets);
          final se = r.readTable(_db.sessionExercises);
          final session = r.readTable(_db.workoutSessions);
          return [
            _date(session.startedAt),
            _time(session.startedAt),
            session.title,
            r.readTable(_db.gyms).name,
            r.readTable(_db.exercises).name,
            r.readTableOrNull(_db.equipment)?.name ?? 'sem aparelho',
            '${set.position}',
            set.setType.label,
            csvNumber(set.loadMilli == null ? null : set.loadMilli! / 1000),
            se.loadUnit.label,
            se.loadBasis.label.toLowerCase(),
            csvNumber(set.reps),
            csvNumber(set.rir),
            csvNumber(set.durationSec),
            csvNumber(set.distanceM == null ? null : set.distanceM! / 1000),
            se.howItWent ?? '',
          ];
        }(),
    ]);
  }

  Future<String> bodyCsv() async {
    final checkins = await (_db.select(
      _db.bodyCheckins,
    )..orderBy([(c) => OrderingTerm.asc(c.takenAt)])).get();
    final values = await _db.select(_db.bodyValues).get();
    // Só as colunas de medidas que você já usou.
    final used = {for (final v in values) v.metric};
    final metrics = [
      for (final m in BodyMetric.values)
        if (used.contains(m)) m,
    ];
    return toCsv([
      ['data', for (final m in metrics) '${m.label} (${m.unit})', 'observação'],
      for (final c in checkins)
        [
          _date(c.takenAt),
          for (final m in metrics)
            csvNumber(
              values
                  .where((v) => v.checkinId == c.id && v.metric == m)
                  .map((v) => v.valueMilli / 1000)
                  .firstOrNull,
            ),
          c.notes ?? '',
        ],
    ]);
  }

  /// Gera os dois arquivos e abre o compartilhamento. True se não cancelou.
  Future<bool> exportAndShare() async {
    final dir = Directory(
      p.join((await getTemporaryDirectory()).path, 'planilhas'),
    );
    await dir.create(recursive: true);
    final workouts = File(p.join(dir.path, 'nodefit-treinos.csv'));
    final body = File(p.join(dir.path, 'nodefit-corpo.csv'));
    await workouts.writeAsString(await workoutsCsv());
    await body.writeAsString(await bodyCsv());
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(workouts.path, mimeType: 'text/csv'),
            XFile(body.path, mimeType: 'text/csv'),
          ],
          subject: 'Planilhas NodeFit',
        ),
      );
      return result.status != ShareResultStatus.dismissed;
    } finally {
      for (final f in [workouts, body]) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
  }
}

@Riverpod(keepAlive: true)
CsvExporter csvExporter(Ref ref) => CsvExporter(ref.watch(appDatabaseProvider));
