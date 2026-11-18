import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/body.dart';
import '../../../core/domain/reports.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../auth/data/auth_service.dart';
import '../../body/data/body_repository.dart';

part 'report_repository.g.dart';

/// Lê do banco o que os relatórios precisam (treinos finalizados, fichas,
/// check-ins e perfil) e entrega um [ReportData] já filtrado pelo período.
/// O texto em si é montado em `core/domain/reports.dart`.
class ReportRepository {
  ReportRepository(this._db);
  final AppDatabase _db;

  Future<ReportData> load({
    required String studentName,
    required int weeks,
    DateTime? now,
  }) async {
    final to = (now ?? DateTime.now()).toUtc();
    final from = to.subtract(Duration(days: weeks * 7));
    final profile = await BodyRepository(
      _db,
      PrefsRepository(_db),
    ).watchProfile().first;
    return ReportData(
      studentName: studentName,
      from: from,
      to: to,
      sessions: await _sessions(from, to),
      routines: await _routines(),
      checkins: await _checkins(from, to),
      sex: profile.sex,
      heightCm: profile.heightCm,
      birthYear: profile.birthYear,
    );
  }

  /// Treinos finalizados no período, com exercícios e séries concluídas.
  Future<List<ReportSession>> _sessions(DateTime from, DateTime to) async {
    final sessions =
        await (_db.select(_db.workoutSessions)
              ..where(
                (s) =>
                    s.endedAt.isNotNull() &
                    s.startedAt.isBiggerOrEqualValue(from) &
                    s.startedAt.isSmallerOrEqualValue(to),
              )
              ..orderBy([(s) => OrderingTerm.asc(s.startedAt)]))
            .get();
    if (sessions.isEmpty) return const [];

    final rows =
        await (_db.select(_db.sessionExercises).join([
                innerJoin(
                  _db.exercises,
                  _db.exercises.id.equalsExp(_db.sessionExercises.exerciseId),
                ),
              ])
              ..where(
                _db.sessionExercises.sessionId.isIn(sessions.map((s) => s.id)),
              )
              ..orderBy([OrderingTerm.asc(_db.sessionExercises.position)]))
            .get();
    final seIds = rows.map((r) => r.readTable(_db.sessionExercises).id);
    final sets =
        await (_db.select(_db.workoutSets)
              ..where(
                (w) =>
                    w.sessionExerciseId.isIn(seIds) & w.completedAt.isNotNull(),
              )
              ..orderBy([(w) => OrderingTerm.asc(w.position)]))
            .get();
    final setsBySe = <String, List<ReportSet>>{};
    for (final w in sets) {
      (setsBySe[w.sessionExerciseId] ??= []).add(
        ReportSet(
          type: w.setType,
          loadMilli: w.loadMilli,
          reps: w.reps,
          durationSec: w.durationSec,
          distanceM: w.distanceM,
        ),
      );
    }

    final bySession = <String, List<ReportExercise>>{};
    for (final r in rows) {
      final se = r.readTable(_db.sessionExercises);
      final ex = r.readTable(_db.exercises);
      final done = setsBySe[se.id] ?? const [];
      // Exercício sem nenhuma série concluída não entra (foi pulado),
      // a não ser que a pessoa tenha marcado dor nele.
      if (done.isEmpty && !se.pain) continue;
      (bySession[se.sessionId] ??= []).add(
        ReportExercise(
          name: ex.name,
          tracking: ex.tracking,
          unit: se.loadUnit,
          sets: done,
          pain: se.pain,
          effort: se.effortTag,
          howItWent: se.howItWent,
        ),
      );
    }
    return [
      for (final s in sessions)
        ReportSession(
          startedAt: s.startedAt,
          endedAt: s.endedAt!,
          title: s.title,
          exercises: bySession[s.id] ?? const [],
        ),
    ];
  }

  /// Fichas ativas (não arquivadas), na ordem da tela.
  Future<List<ReportRoutine>> _routines() async {
    final rows =
        await (_db.select(_db.routines)
              ..where((r) => r.archivedAt.isNull())
              ..orderBy([(r) => OrderingTerm.asc(r.sortOrder)]))
            .get();
    return [
      for (final r in rows)
        ReportRoutine(
          name: r.name,
          trainer: r.trainer,
          expiresOn: r.expiresOn == null
              ? null
              : DateTime.tryParse(r.expiresOn!),
        ),
    ];
  }

  /// Check-ins do período, com as medidas em unidades normais (kg, cm, %).
  Future<List<ReportCheckin>> _checkins(DateTime from, DateTime to) async {
    final checkins =
        await (_db.select(_db.bodyCheckins)
              ..where(
                (c) =>
                    c.takenAt.isBiggerOrEqualValue(from) &
                    c.takenAt.isSmallerOrEqualValue(to),
              )
              ..orderBy([(c) => OrderingTerm.asc(c.takenAt)]))
            .get();
    if (checkins.isEmpty) return const [];
    final values = await (_db.select(
      _db.bodyValues,
    )..where((v) => v.checkinId.isIn(checkins.map((c) => c.id)))).get();
    return [
      for (final c in checkins)
        ReportCheckin(
          day: c.takenAt,
          values: <BodyMetric, double>{
            for (final v in values)
              if (v.checkinId == c.id) v.metric: v.valueMilli / 1000,
          },
        ),
    ];
  }
}

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) =>
    ReportRepository(ref.watch(appDatabaseProvider));

/// Texto pronto do relatório para [audience] nas últimas [weeks] semanas.
@riverpod
Future<String> reportText(Ref ref, ReportAudience audience, int weeks) async {
  final user = await ref.watch(currentUserProvider.future);
  final data = await ref
      .watch(reportRepositoryProvider)
      .load(studentName: user?.name ?? 'Aluno(a)', weeks: weeks);
  return switch (audience) {
    ReportAudience.trainer => trainerReport(data, today: DateTime.now()),
    ReportAudience.doctor => doctorReport(data),
  };
}
