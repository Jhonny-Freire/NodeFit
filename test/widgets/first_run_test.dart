import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:nodefit/app/app.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/db/database_provider.dart';

void main() {
  setUpAll(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    Intl.defaultLocale = 'pt_BR';
    await initializeDateFormatting('pt_BR');
  });

  testWidgets('primeiro uso: cadastro → nome da academia → treino livre', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        retry: (_, _) => null,
        child: const NodeFitApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Telas protegidas: sem sessão, o app abre no login.
    expect(find.text('Entrar no NodeFit'), findsOneWidget);
    await tester.tap(find.text('Não tem conta? Criar conta'));
    await tester.pumpAndSettle();

    // Cadastro → já entra logado.
    await tester.enterText(find.widgetWithText(TextFormField, 'Nome'), 'João');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'joao@nodefit.app',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Senha (mín. 6 caracteres)'),
      'senha123',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Confirmar senha'),
      'senha123',
    );
    await tester.tap(find.text('CRIAR CONTA'));
    await tester.pumpAndSettle();

    // Primeiro uso: só o nome da academia.
    expect(find.text('Seu caderno de treino'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Academia do bairro');
    await tester.pump(); // o botão só habilita depois do redesenho
    await tester.tap(find.text('COMEÇAR'));
    await tester.pumpAndSettle();

    expect(find.text('INICIAR TREINO'), findsOneWidget);
    expect(find.text('Academia do bairro'), findsWidgets);

    await tester.tap(find.text('INICIAR TREINO'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Tela cheia do treino, pronta para o primeiro exercício.
    expect(find.text('Treino livre'), findsWidgets);
    expect(find.text('Adicionar exercício'), findsOneWidget);

    // Desmonta antes de fechar o banco (streams e timers do Drift).
    await tester.pumpWidget(const SizedBox.shrink());
    // Avança o relógio falso para o Drift terminar o que agendou ao fechar
    // os streams; só então fecha o banco, em tempo real.
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
}
