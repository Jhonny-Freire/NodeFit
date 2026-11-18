import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/db/app_database.dart';
import '../../../core/db/database_provider.dart';
import '../../../core/domain/body.dart';
import '../../../core/prefs/prefs_repository.dart';
import '../../../core/utils/ids.dart';

part 'body_repository.g.dart';

/// Dados fixos da pessoa, usados no IMC e no % de gordura da Marinha.
class BodyProfile {
  const BodyProfile({this.sex, this.heightCm, this.birthYear});
  final Sex? sex;
  final double? heightCm;
  final int? birthYear;

  bool get complete => sex != null && heightCm != null;

  int? ageAt(DateTime day) => birthYear == null ? null : day.year - birthYear!;
}

/// Um check-in com os valores e as fotos.
class CheckinView {
  const CheckinView({
    required this.checkin,
    required this.values,
    required this.photos,
  });
  final BodyCheckin checkin;

  /// Medida → valor × 1000.
  final Map<BodyMetric, int> values;
  final List<BodyPhoto> photos;

  double? value(BodyMetric m) => values[m] == null ? null : values[m]! / 1000;
}

/// Um ponto da série de uma medida.
typedef BodyPoint = ({DateTime day, double value});

abstract final class BodyPrefKeys {
  static const sex = 'profile.sex';
  static const heightCm = 'profile.height_cm';
  static const birthYear = 'profile.birth_year';
  static const reminderWeekday = 'checkin.reminder_weekday';
  static const reminderMinutes = 'checkin.reminder_minutes';
}

class BodyRepository {
  BodyRepository(this._db, this._prefs);
  final AppDatabase _db;
  final PrefsRepository _prefs;

  // ───────────────────────── Perfil ─────────────────────────

  Stream<BodyProfile> watchProfile() {
    // Três chaves: relê tudo quando qualquer uma muda.
    final q = _db.select(_db.appPrefs)
      ..where(
        (p) => p.key.isIn([
          BodyPrefKeys.sex,
          BodyPrefKeys.heightCm,
          BodyPrefKeys.birthYear,
        ]),
      );
    return q.watch().map((rows) {
      final m = {for (final r in rows) r.key: r.value};
      return BodyProfile(
        sex: Sex.values.where((s) => s.name == m[BodyPrefKeys.sex]).firstOrNull,
        heightCm: double.tryParse(m[BodyPrefKeys.heightCm] ?? ''),
        birthYear: int.tryParse(m[BodyPrefKeys.birthYear] ?? ''),
      );
    });
  }

  Future<void> saveProfile({
    required Sex? sex,
    required double? heightCm,
    required int? birthYear,
  }) => _db.transaction(() async {
    await _prefs.set(BodyPrefKeys.sex, sex?.name);
    await _prefs.set(BodyPrefKeys.heightCm, heightCm?.toString());
    await _prefs.set(BodyPrefKeys.birthYear, birthYear?.toString());
  });

  // ───────────────────────── Check-ins ─────────────────────────

  /// Todos os check-ins, do mais novo para o mais antigo.
  Stream<List<CheckinView>> watchCheckins() {
    final checkins = _db.select(_db.bodyCheckins)
      ..orderBy([(c) => OrderingTerm.desc(c.takenAt)]);
    // Qualquer mudança em valores ou fotos também redesenha.
    return checkins.watch().asyncMap((list) async {
      final values = await _db.select(_db.bodyValues).get();
      final photos = await (_db.select(
        _db.bodyPhotos,
      )..orderBy([(p) => OrderingTerm.asc(p.createdAt)])).get();
      return [
        for (final c in list)
          CheckinView(
            checkin: c,
            values: {
              for (final v in values)
                if (v.checkinId == c.id) v.metric: v.valueMilli,
            },
            photos: [
              for (final p in photos)
                if (p.checkinId == c.id) p,
            ],
          ),
      ];
    });
  }

  Future<CheckinView?> getCheckin(String id) async =>
      (await watchCheckins().first)
          .where((c) => c.checkin.id == id)
          .firstOrNull;

  /// Cria (sem [id]) ou atualiza o check-in com exatamente estes [values]
  /// (o que ficou de fora é apagado). Devolve o id.
  Future<String> saveCheckin({
    String? id,
    required DateTime takenAt,
    required Map<BodyMetric, int> values,
    String? notes,
    BodySource source = BodySource.manual,
  }) => _db.transaction(() async {
    final cleanNotes = (notes == null || notes.trim().isEmpty)
        ? null
        : notes.trim();
    final String checkinId;
    if (id == null) {
      final row = await _db
          .into(_db.bodyCheckins)
          .insertReturning(
            BodyCheckinsCompanion.insert(
              takenAt: Value(takenAt),
              localDate: localDateOf(takenAt),
              notes: Value(cleanNotes),
            ),
          );
      checkinId = row.id;
    } else {
      checkinId = id;
      await (_db.update(_db.bodyCheckins)..where((c) => c.id.equals(id))).write(
        BodyCheckinsCompanion(
          takenAt: Value(takenAt),
          localDate: Value(localDateOf(takenAt)),
          notes: Value(cleanNotes),
          updatedAt: Value(nowUtc()),
        ),
      );
      await (_db.delete(_db.bodyValues)..where(
            (v) =>
                v.checkinId.equals(id) &
                v.metric.isNotIn([for (final m in values.keys) m.name]),
          ))
          .go();
    }
    for (final e in values.entries) {
      await _db
          .into(_db.bodyValues)
          .insert(
            BodyValuesCompanion.insert(
              checkinId: checkinId,
              metric: e.key,
              valueMilli: e.value,
              source: Value(source),
            ),
            onConflict: DoUpdate(
              (_) => BodyValuesCompanion(
                valueMilli: Value(e.value),
                source: Value(source),
              ),
              target: [_db.bodyValues.checkinId, _db.bodyValues.metric],
            ),
          );
    }
    return checkinId;
  });

  /// Apaga o check-in e devolve os caminhos das fotos (quem chama apaga os
  /// arquivos).
  Future<List<String>> deleteCheckin(String id) => _db.transaction(() async {
    final photos = await (_db.select(
      _db.bodyPhotos,
    )..where((p) => p.checkinId.equals(id))).get();
    await (_db.delete(_db.bodyCheckins)..where((c) => c.id.equals(id))).go();
    return [for (final p in photos) p.path];
  });

  /// Série de uma medida, do mais antigo ao mais novo.
  Stream<List<BodyPoint>> watchSeries(BodyMetric metric) {
    final q =
        _db.select(_db.bodyValues).join([
            innerJoin(
              _db.bodyCheckins,
              _db.bodyCheckins.id.equalsExp(_db.bodyValues.checkinId),
            ),
          ])
          ..where(_db.bodyValues.metric.equalsValue(metric))
          ..orderBy([OrderingTerm.asc(_db.bodyCheckins.takenAt)]);
    return q.watch().map(
      (rows) => [
        for (final r in rows)
          (
            day: r.readTable(_db.bodyCheckins).takenAt,
            value: r.readTable(_db.bodyValues).valueMilli / 1000,
          ),
      ],
    );
  }

  /// Último valor de cada medida (para mostrar "última: 85,5" no formulário).
  Future<Map<BodyMetric, int>> lastValues({String? excludeCheckinId}) async {
    final rows =
        await (_db.select(_db.bodyValues).join([
                innerJoin(
                  _db.bodyCheckins,
                  _db.bodyCheckins.id.equalsExp(_db.bodyValues.checkinId),
                ),
              ])
              ..where(
                excludeCheckinId == null
                    ? const Constant(true)
                    : _db.bodyValues.checkinId.equals(excludeCheckinId).not(),
              )
              ..orderBy([OrderingTerm.asc(_db.bodyCheckins.takenAt)]))
            .get();
    return {
      for (final r in rows)
        r.readTable(_db.bodyValues).metric: r
            .readTable(_db.bodyValues)
            .valueMilli,
    };
  }

  // ───────────────────────── Fotos ─────────────────────────

  /// [path] relativo à pasta de suporte do app. Uma foto por pose no
  /// check-in: a nova substitui (devolve o caminho da antiga, para apagar).
  Future<String?> setPhoto({
    required String checkinId,
    required PhotoPose pose,
    required String path,
  }) => _db.transaction(() async {
    final old =
        await (_db.select(_db.bodyPhotos)..where(
              (p) => p.checkinId.equals(checkinId) & p.pose.equalsValue(pose),
            ))
            .getSingleOrNull();
    if (old != null) {
      await (_db.delete(
        _db.bodyPhotos,
      )..where((p) => p.id.equals(old.id))).go();
    }
    await _db
        .into(_db.bodyPhotos)
        .insert(
          BodyPhotosCompanion.insert(
            checkinId: checkinId,
            pose: pose,
            path: path,
          ),
        );
    // A lista de check-ins observa a tabela de check-ins: avisa a tela.
    await (_db.update(_db.bodyCheckins)..where((c) => c.id.equals(checkinId)))
        .write(BodyCheckinsCompanion(updatedAt: Value(nowUtc())));
    return old?.path;
  });

  /// A foto mais recente desta pose antes de [before] (para a transparência
  /// que ajuda a repetir a pose).
  Future<BodyPhoto?> previousPhoto(PhotoPose pose, {DateTime? before}) {
    final q =
        _db.select(_db.bodyPhotos).join([
            innerJoin(
              _db.bodyCheckins,
              _db.bodyCheckins.id.equalsExp(_db.bodyPhotos.checkinId),
            ),
          ])
          ..where(
            _db.bodyPhotos.pose.equalsValue(pose) &
                (before == null
                    ? const Constant(true)
                    : _db.bodyCheckins.takenAt.isSmallerThanValue(before)),
          )
          ..orderBy([OrderingTerm.desc(_db.bodyCheckins.takenAt)])
          ..limit(1);
    return q.map((r) => r.readTable(_db.bodyPhotos)).getSingleOrNull();
  }
}

@Riverpod(keepAlive: true)
BodyRepository bodyRepository(Ref ref) => BodyRepository(
  ref.watch(appDatabaseProvider),
  ref.watch(prefsRepositoryProvider),
);

@riverpod
Stream<BodyProfile> bodyProfile(Ref ref) =>
    ref.watch(bodyRepositoryProvider).watchProfile();

@riverpod
Stream<List<CheckinView>> checkins(Ref ref) =>
    ref.watch(bodyRepositoryProvider).watchCheckins();

@riverpod
Stream<List<BodyPoint>> bodySeries(Ref ref, BodyMetric metric) =>
    ref.watch(bodyRepositoryProvider).watchSeries(metric);
