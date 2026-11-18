import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/domain/body.dart';
import 'package:nodefit/core/prefs/prefs_repository.dart';
import 'package:nodefit/features/body/data/body_repository.dart';

void main() {
  late AppDatabase db;
  late BodyRepository body;

  setUpAll(() => driftRuntimeOptions.dontWarnAboutMultipleDatabases = true);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    body = BodyRepository(db, PrefsRepository(db));
  });

  tearDown(() => db.close());

  test('perfil: salvar e ler', () async {
    expect((await body.watchProfile().first).complete, isFalse);
    await body.saveProfile(sex: Sex.male, heightCm: 178, birthYear: 1998);
    final p = await body.watchProfile().first;
    expect((p.sex, p.heightCm, p.birthYear), (Sex.male, 178.0, 1998));
    expect(p.ageAt(DateTime(2026, 10, 26)), 28);
  });

  test('check-in: criar, editar (tirar medida) e série por medida', () async {
    final d1 = DateTime.utc(2026, 10, 5, 10);
    final d2 = DateTime.utc(2026, 10, 12, 10);
    final a = await body.saveCheckin(
      takenAt: d1,
      values: {BodyMetric.weight: 81200, BodyMetric.abdomen: 88000},
    );
    final b = await body.saveCheckin(
      takenAt: d2,
      values: {BodyMetric.weight: 80400, BodyMetric.bodyFat: 19500},
      source: BodySource.scale,
      notes: ' de manhã, em jejum ',
    );

    var list = await body.watchCheckins().first;
    expect(list.map((c) => c.checkin.id), [b, a], reason: 'mais novo primeiro');
    expect(list.first.value(BodyMetric.weight), 80.4);
    expect(list.first.checkin.notes, 'de manhã, em jejum');
    expect(await body.watchSeries(BodyMetric.weight).first, [
      (day: d1, value: 81.2),
      (day: d2, value: 80.4),
    ]);

    // Editar: troca o peso e tira o abdômen.
    await body.saveCheckin(
      id: a,
      takenAt: d1,
      values: {BodyMetric.weight: 81000},
    );
    list = await body.watchCheckins().first;
    expect(list.last.values, {BodyMetric.weight: 81000});

    final last = await body.lastValues();
    expect(last[BodyMetric.weight], 80400);
    expect(last[BodyMetric.bodyFat], 19500);
    expect(
      (await body.lastValues(excludeCheckinId: b))[BodyMetric.weight],
      81000,
    );
  });

  test('fotos: uma por pose; a anterior serve de guia', () async {
    final a = await body.saveCheckin(
      takenAt: DateTime.utc(2026, 10, 5),
      values: {BodyMetric.weight: 81000},
    );
    final b = await body.saveCheckin(
      takenAt: DateTime.utc(2026, 10, 19),
      values: {BodyMetric.weight: 80000},
    );
    await body.setPhoto(checkinId: a, pose: PhotoPose.front, path: 'p/a1.jpg');
    final replaced = await body.setPhoto(
      checkinId: a,
      pose: PhotoPose.front,
      path: 'p/a2.jpg',
    );
    expect(replaced, 'p/a1.jpg');
    await body.setPhoto(checkinId: b, pose: PhotoPose.front, path: 'p/b.jpg');

    final guide = await body.previousPhoto(
      PhotoPose.front,
      before: DateTime.utc(2026, 10, 19),
    );
    expect(guide!.path, 'p/a2.jpg');
    expect((await body.previousPhoto(PhotoPose.front))!.path, 'p/b.jpg');
    expect(await body.previousPhoto(PhotoPose.back), isNull);

    expect(await body.deleteCheckin(a), ['p/a2.jpg']);
    expect((await body.watchCheckins().first).single.checkin.id, b);
  });
}
