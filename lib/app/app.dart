import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/workout/presentation/rest_alert_listener.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class NodeFitApp extends ConsumerWidget {
  const NodeFitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'NodeFit',
      debugShowCheckedModeBanner: false,
      // v0.1: só tema escuro (docs/PLANO.md, 6.4). O claro vem depois.
      theme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
      // Alerta de fim do descanso vale em qualquer tela.
      builder: (context, child) =>
          RestAlertListener(child: child ?? const SizedBox.shrink()),
    );
  }
}

/// Se a inicialização falhar (banco ou catálogo), mostra o erro em vez de
/// fechar o app sem explicação.
class StartupErrorApp extends StatelessWidget {
  const StartupErrorApp({super.key, required this.error});
  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: buildDarkTheme(),
    home: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Não consegui abrir o NodeFit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text('$error'),
            ],
          ),
        ),
      ),
    ),
  );
}
