import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/domain/reports.dart';
import '../features/auth/data/auth_service.dart';
import '../features/auth/presentation/auth_widgets.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/body/presentation/checkin_screen.dart';
import '../features/catalog/presentation/exercise_list_screen.dart';
import '../features/gyms/presentation/equipment_detail_screen.dart';
import '../features/gyms/presentation/notebook_screen.dart';
import '../features/gyms/presentation/station_detail_screen.dart';
import '../features/history/presentation/history_screen.dart';
import '../features/history/presentation/session_detail_screen.dart';
import '../features/routines/presentation/routine_editor_screen.dart';
import '../features/reports/presentation/report_screen.dart';
import '../features/settings/presentation/more_screen.dart';
import '../features/workout/presentation/active_session_screen.dart';
import '../features/workout/presentation/train_home_screen.dart';
import 'shell.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Caminho estável do treino em andamento (também servirá para a
/// notificação do timer na Fatia 2).
String sessionPath(String sessionId) => '/sessao/$sessionId';

/// Telas abertas sem login. Todas as outras exigem um usuário logado.
const publicPaths = {'/login', '/cadastro'};

/// Proteção de telas: decide para onde ir conforme o usuário está ou não
/// logado. Retornar `null` = pode abrir a tela pedida.
String? authRedirect({required bool loggedIn, required Uri uri}) {
  final isPublic = publicPaths.contains(uri.path);
  if (!loggedIn) {
    if (isPublic) return null;
    // Guarda a tela pedida (ex.: o treino aberto pela notificação do timer)
    // para voltar a ela depois do login.
    final from = uri.toString();
    return Uri(
      path: '/login',
      queryParameters: from == '/treinar' ? null : {'from': from},
    ).toString();
  }
  // Logado não precisa ver login/cadastro.
  if (isPublic) return safeRedirect(uri.queryParameters['from']) ?? '/treinar';
  return null;
}

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // Avisa o go_router para reavaliar o `redirect` sempre que a sessão muda
  // (login, cadastro, logout ou backup restaurado).
  final authChanges = ValueNotifier<int>(0);
  ref.listen(currentUserProvider, (_, _) => authChanges.value++);
  ref.onDispose(authChanges.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/treinar',
    refreshListenable: authChanges,
    redirect: (context, state) => authRedirect(
      loggedIn: ref.read(currentUserProvider).value != null,
      uri: state.uri,
    ),
    routes: [
      // Autenticação: fora das abas, no navegador raiz.
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            LoginScreen(from: state.uri.queryParameters['from']),
      ),
      GoRoute(
        path: '/cadastro',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            RegisterScreen(from: state.uri.queryParameters['from']),
      ),
      // Abas: Treinar · Caderno · Progresso · Mais (cada uma guarda sua pilha).
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/treinar',
                builder: (context, state) => const TrainHomeScreen(),
                routes: [
                  GoRoute(
                    path: 'ficha/:routineId',
                    builder: (context, state) => RoutineEditorScreen(
                      routineId: state.pathParameters['routineId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/caderno',
                builder: (context, state) => const NotebookScreen(),
                routes: [
                  GoRoute(
                    path: 'exercicios',
                    builder: (context, state) => const ExerciseListScreen(),
                  ),
                  GoRoute(
                    path: 'aparelho/:equipmentId',
                    builder: (context, state) => EquipmentDetailScreen(
                      equipmentId: state.pathParameters['equipmentId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'estacao/:stationId',
                    builder: (context, state) => StationDetailScreen(
                      stationId: state.pathParameters['stationId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/progresso',
                builder: (context, state) => const HistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'sessao/:sessionId',
                    builder: (context, state) => SessionDetailScreen(
                      sessionId: state.pathParameters['sessionId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mais',
                builder: (context, state) => const MoreScreen(),
                routes: [
                  // Relatórios para o professor e o médico
                  // (docs/PERSONAS.md). Tipo desconhecido volta para Mais.
                  GoRoute(
                    path: 'relatorio/:tipo',
                    redirect: (context, state) =>
                        ReportAudience.fromSlug(
                              state.pathParameters['tipo']!,
                            ) ==
                            null
                        ? '/mais'
                        : null,
                    builder: (context, state) => ReportScreen(
                      audience: ReportAudience.fromSlug(
                        state.pathParameters['tipo']!,
                      )!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Check-in do corpo: tela cheia (teclado e câmera), fora das abas.
      GoRoute(
        path: '/checkin',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CheckinScreen(),
        routes: [
          GoRoute(
            path: ':checkinId',
            parentNavigatorKey: rootNavigatorKey,
            builder: (context, state) =>
                CheckinScreen(checkinId: state.pathParameters['checkinId']),
          ),
        ],
      ),
      // Treino em andamento: tela cheia, fora das abas (navegador raiz).
      GoRoute(
        path: '/sessao/:sessionId',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) =>
            ActiveSessionScreen(sessionId: state.pathParameters['sessionId']!),
      ),
    ],
  );
}
