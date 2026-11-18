import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/features/auth/data/auth_service.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late AuthService auth;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    auth = AuthService(db);
  });
  tearDown(() => db.close());

  test('cadastro grava hash (nunca a senha) e já deixa logado', () async {
    final user = await auth.register(
      name: ' João ',
      email: ' Joao@Email.com ',
      password: 'senha123',
    );
    expect(user.name, 'João');
    expect(user.email, 'joao@email.com');
    expect(user.passwordHash, isNot('senha123'));
    expect((await auth.watchCurrentUser().first)?.id, user.id);
  });

  test('e-mail já cadastrado (sem diferenciar maiúsculas)', () async {
    await auth.register(name: 'A', email: 'a@b.com', password: 'senha123');
    expect(
      () => auth.register(name: 'B', email: 'A@B.COM', password: 'outra123'),
      throwsA(
        isA<AuthException>().having(
          (e) => e.message,
          'message',
          'Este e-mail já está cadastrado.',
        ),
      ),
    );
  });

  test('login inválido: mesma mensagem para e-mail ou senha errados', () async {
    await auth.register(name: 'A', email: 'a@b.com', password: 'senha123');
    await auth.logout();
    for (final (email, password) in [
      ('a@b.com', 'errada1'),
      ('nao@existe.com', 'senha123'),
    ]) {
      await expectLater(
        auth.login(email: email, password: password),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            'E-mail ou senha incorretos.',
          ),
        ),
      );
    }
    await expectLater(
      auth.login(email: '', password: ''),
      throwsA(isA<AuthException>()),
    );
    expect(await auth.watchCurrentUser().first, isNull);
  });

  test('login certo abre a sessão e logout fecha', () async {
    await auth.register(name: 'A', email: 'a@b.com', password: 'senha123');
    await auth.logout();
    expect(await auth.watchCurrentUser().first, isNull);

    final user = await auth.login(email: 'A@b.com ', password: 'senha123');
    expect((await auth.watchCurrentUser().first)?.id, user.id);

    await auth.logout();
    expect(await auth.watchCurrentUser().first, isNull);
  });
}
