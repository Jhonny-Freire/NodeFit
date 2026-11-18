import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/router.dart';
import '../../../core/db/app_database.dart';
import '../../../core/platform/rest_alert.dart';
import '../../../core/platform/rest_notifications.dart';
import '../data/workout_repository.dart';

/// Fica na raiz do app e cuida do fim do descanso do treino em andamento,
/// qualquer que seja a tela:
/// - se der, agenda a notificação (contagem na tela bloqueada + alarme);
/// - se não der (sem permissão), alerta dentro do app (vibração + som).
/// A barra de descanso só mostra a contagem.
class RestAlertListener extends ConsumerStatefulWidget {
  const RestAlertListener({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<RestAlertListener> createState() => _RestAlertListenerState();
}

class _RestAlertListenerState extends ConsumerState<RestAlertListener> {
  Timer? _timer;
  DateTime? _scheduledFor;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    RestNotifications.instance.onOpenSession = (id) =>
        ref.read(routerProvider).go(sessionPath(id));
    RestNotifications.instance.onOpenCheckin = () =>
        ref.read(routerProvider).push('/checkin');
    ref.listenManual(
      activeSessionProvider,
      (_, next) => _schedule(next.value),
      fireImmediately: true,
    );
  }

  Future<void> _schedule(WorkoutSession? session) async {
    final endsAt = session?.restEndsAt;
    if (endsAt == _scheduledFor) return;
    _scheduledFor = endsAt;
    final generation = ++_generation;
    _timer?.cancel();
    _timer = null;
    if (session == null || endsAt == null) {
      await RestNotifications.instance.cancel();
      return;
    }
    // Descanso que já tinha acabado (ex.: reabriu o app) não toca de novo.
    if (!endsAt.isAfter(DateTime.now())) return;
    final viaNotification = await RestNotifications.instance.scheduleRest(
      endsAt: endsAt,
      sessionId: session.id,
    );
    // Mudou de novo enquanto agendava: a chamada mais nova manda.
    if (!mounted || generation != _generation || viaNotification) return;
    final remaining = endsAt.difference(DateTime.now());
    if (remaining > Duration.zero) {
      _timer = Timer(remaining, RestAlert.restEnded);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
