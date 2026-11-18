import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/app/app.dart';
import 'package:nodefit/app/router.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/db/database_provider.dart';
import 'package:nodefit/features/auth/data/auth_service.dart';

void main() {
  setUpAll(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  group('proteção de telas (regra do redirect)', () {
    Uri u(String s) => Uri.parse(s);

    test('sem login: qualquer tela vai para o login, guardando a origem', () {
      expect(authRedirect(loggedIn: false, uri: u('/treinar')), '/login');
      expect(
        authRedirect(loggedIn: false, uri: u('/sessao/abc')),
        '/login?from=%2Fsessao%2Fabc',
      );
      expect(authRedirect(loggedIn: false, uri: u('/login')), isNull);
      expect(authRedirect(loggedIn: false, uri: u('/cadastro')), isNull);
    });

    test('logado: login/cadastro voltam para o app (só destino interno)', () {
      expect(authRedirect(loggedIn: true, uri: u('/treinar')), isNull);
      expect(authRedirect(loggedIn: true, uri: u('/login')), '/treinar');
      expect(
        authRedirect(loggedIn: true, uri: u('/login?from=/sessao/abc')),
        '/sessao/abc',
      );
      expect(
        authRedirect(loggedIn: true, uri: u('/login?from=https://x.com')),
        '/treinar',
      );
    });
  });

  testWidgets('login: campos vazios, senha errada, entrar e sair', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.runAsync(() async {
      final auth = AuthService(db);
      await auth.register(
        name: 'Ana',
        email: 'ana@b.com',
        password: 'senha123',
      );
      await auth.logout();
    });
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        retry: (_, _) => null,
        child: const NodeFitApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Entrar no NodeFit'), findsOneWidget);

    // Campos vazios: validação do formulário, sem ir ao banco.
    await tester.tap(find.text('ENTRAR'));
    await tester.pump();
    expect(find.text('Informe o e-mail.'), findsOneWidget);
    expect(find.text('Informe a senha.'), findsOneWidget);

    // Senha errada: erro vindo do serviço.
    final email = find.widgetWithText(TextFormField, 'E-mail');
    final password = find.widgetWithText(TextFormField, 'Senha');
    await tester.enterText(email, 'ana@b.com');
    await tester.enterText(password, 'errada1');
    await tester.pump();
    await tester.tap(find.text('ENTRAR'));
    await tester.pumpAndSettle();
    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);

    // Senha certa: o roteador leva para o app.
    await tester.enterText(password, 'senha123');
    await tester.pump();
    await tester.tap(find.text('ENTRAR'));
    await tester.pumpAndSettle();
    expect(find.text('Entrar no NodeFit'), findsNothing);
    expect(find.text('Seu caderno de treino'), findsOneWidget);

    // Logout pela aba Mais (com confirmação) → volta ao login.
    await tester.tap(find.text('Mais'));
    await tester.pumpAndSettle();
    expect(find.text('ana@b.com'), findsOneWidget);
    await tester.tap(find.text('Sair').first);
    await tester.pumpAndSettle();
    expect(find.text('Sair da conta?'), findsOneWidget);
    await tester.tap(find.text('Sair').last);
    await tester.pumpAndSettle();
    expect(find.text('Entrar no NodeFit'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
}
