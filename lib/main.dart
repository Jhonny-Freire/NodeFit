import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app.dart';
import 'app/startup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';
  await initializeDateFormatting('pt_BR');

  // Erro de banco local não melhora tentando de novo: sem retry automático.
  final container = ProviderContainer(retry: (_, _) => null);
  try {
    await container.read(appStartupProvider.future);
  } catch (error) {
    runApp(StartupErrorApp(error: error));
    return;
  }
  runApp(
    UncontrolledProviderScope(container: container, child: const NodeFitApp()),
  );
}
