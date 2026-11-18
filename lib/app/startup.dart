import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/db/database_provider.dart';
import '../core/prefs/prefs_repository.dart';
import '../features/auth/data/auth_service.dart';
import '../features/backup/restore_service.dart';
import '../features/catalog/data/catalog_repository.dart';

part 'startup.g.dart';

const exerciseSeedAsset = 'assets/seed/exercicios_pt_br.json';

/// Roda uma vez antes da primeira tela: abre o banco e aplica o catálogo
/// embarcado (só grava se a versão do arquivo for nova).
@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  // Antes de abrir o banco: cópia diária de segurança (as 3 últimas).
  // Na web não há pasta de arquivos: o banco fica no armazenamento do
  // navegador e a cópia não se aplica.
  if (!kIsWeb) {
    try {
      await RestoreService.dailyAutoCopy();
    } catch (_) {
      // A cópia é rede de segurança; nunca impede o app de abrir.
    }
  }
  final db = ref.watch(appDatabaseProvider);
  final prefs = ref.watch(prefsRepositoryProvider);
  final json = await rootBundle.loadString(exerciseSeedAsset);
  await CatalogSeeder(db, prefs).run(json);
  // Lê a sessão antes da primeira tela, para o roteador já saber se manda
  // para o login ou direto para o app (sem "piscar" a tela de login).
  // Riverpod 3 pausa provider sem ouvinte: só `read(.future)` esperaria
  // para sempre. O `listen` mantém o stream ativo até a 1ª resposta.
  final session = ref.listen(currentUserProvider, (_, _) {});
  try {
    await ref.read(currentUserProvider.future);
  } finally {
    session.close();
  }
}
