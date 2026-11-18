import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nodefit/app/startup.dart';
import 'package:nodefit/core/db/app_database.dart';
import 'package:nodefit/core/db/database_provider.dart';
import 'package:nodefit/features/auth/data/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  // O main() espera este provider antes da primeira tela. Se ele travar
  // (ex.: esperar um provider pausado do Riverpod 3), o app fica em branco.
  for (final loggedIn in [false, true]) {
    test(
      'inicialização termina (${loggedIn ? 'com' : 'sem'} sessão)',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        if (loggedIn) {
          await AuthService(db)
              .register(name: 'Ana', email: 'ana@b.com', password: 'senha123');
        }
        final container = ProviderContainer(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          retry: (_, _) => null,
        );
        addTearDown(container.dispose);

        await container
            .read(appStartupProvider.future)
            .timeout(const Duration(seconds: 10));

        // A sessão já está pronta para o roteador, sem esperar.
        final user = container.read(currentUserProvider).value;
        expect(user?.email, loggedIn ? 'ana@b.com' : isNull);
      },
    );
  }
}
