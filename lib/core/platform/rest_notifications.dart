import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Timer de descanso na tela bloqueada (docs/PLANO.md, 6.5):
/// 1. notificação fixa com contagem regressiva (o próprio Android conta);
/// 2. alerta de fim agendado com `alarmClock` no MESMO id, que substitui a
///    contagem — toca e vibra pelo canal, mesmo com o app fechado.
/// Tocar na notificação abre o treino ([onOpenSession]).
class RestNotifications {
  RestNotifications._();
  static final instance = RestNotifications._();

  static const _id = 7001;
  static const _checkinId = 7002;
  static const _checkinPayload = 'checkin';
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  /// Chamado com o id do treino quando a pessoa toca na notificação.
  void Function(String sessionId)? onOpenSession;

  /// Tocou no lembrete de check-in.
  void Function()? onOpenCheckin;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<bool> _init() async {
    if (_ready) return true;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }
    try {
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        ),
        onDidReceiveNotificationResponse: (response) {
          final id = response.payload;
          if (id == _checkinPayload) {
            onOpenCheckin?.call();
          } else if (id != null) {
            onOpenSession?.call(id);
          }
        },
      );
      _ready = true;
    } catch (_) {
      return false; // sem plugin (testes): o alerta dentro do app cobre
    }
    return true;
  }

  /// Pede a permissão de notificação (Android 13+), uma vez, em contexto.
  Future<bool> ensurePermission() async {
    if (!await _init()) return false;
    try {
      if (await _android?.areNotificationsEnabled() ?? false) return true;
      return await _android?.requestNotificationsPermission() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Mostra a contagem e agenda o alerta de fim. Devolve true se o alerta
  /// ficou agendado (aí o app não precisa alertar sozinho).
  Future<bool> scheduleRest({
    required DateTime endsAt,
    required String sessionId,
  }) async {
    if (!await _init()) return false;
    try {
      final android = _android;
      if (android == null ||
          !(await android.areNotificationsEnabled() ?? false)) {
        return false;
      }
      final remaining = endsAt.difference(DateTime.now());
      if (remaining <= Duration.zero) {
        await cancel();
        return false;
      }
      await _plugin.show(
        id: _id,
        title: 'Descanso',
        body: 'Toque para voltar ao treino',
        payload: sessionId,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'descanso_contagem',
            'Descanso (contagem)',
            channelDescription: 'Contagem regressiva do descanso',
            importance: Importance.low,
            priority: Priority.low,
            playSound: false,
            enableVibration: false,
            ongoing: true,
            autoCancel: false,
            onlyAlertOnce: true,
            showWhen: true,
            when: endsAt.millisecondsSinceEpoch,
            usesChronometer: true,
            chronometerCountDown: true,
            // Some no fim, para nunca mostrar tempo negativo.
            timeoutAfter: remaining.inMilliseconds,
            visibility: NotificationVisibility.public,
            category: AndroidNotificationCategory.stopwatch,
          ),
        ),
      );
      if (!(await android.canScheduleExactNotifications() ?? false)) {
        return false; // sem alarme exato: o app alerta enquanto estiver vivo
      }
      await _plugin.zonedSchedule(
        id: _id,
        scheduledDate: tz.TZDateTime.from(endsAt, tz.UTC),
        title: 'Descanso acabou',
        body: 'Bora para a próxima série 💪',
        payload: sessionId,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'descanso_fim_v1',
            'Fim do descanso',
            channelDescription: 'Toca e vibra quando o descanso termina',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 800]),
            visibility: NotificationVisibility.public,
            category: AndroidNotificationCategory.alarm,
          ),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Lembrete semanal de check-in ([weekday]: 1 = segunda ... 7 = domingo;
  /// [minutes] desde a meia-noite). Inexato de propósito (PLANO, v0.2):
  /// atrasar uns minutos não importa e dispensa a permissão de alarme.
  Future<bool> scheduleWeeklyCheckin({
    required int weekday,
    required int minutes,
  }) async {
    if (!await ensurePermission()) return false;
    try {
      await _plugin.cancel(id: _checkinId);
      final now = DateTime.now();
      var next = DateTime(
        now.year,
        now.month,
        now.day,
        minutes ~/ 60,
        minutes % 60,
      ).add(Duration(days: (weekday - now.weekday) % 7));
      if (!next.isAfter(now)) next = next.add(const Duration(days: 7));
      // O fuso do Brasil não tem horário de verão: o mesmo instante em UTC
      // repete toda semana no mesmo horário local.
      await _plugin.zonedSchedule(
        id: _checkinId,
        scheduledDate: tz.TZDateTime.from(next, tz.UTC),
        title: 'Check-in da semana',
        body: 'Peso, medidas e fotos: 2 minutos 📏',
        payload: _checkinPayload,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'checkin_semanal',
            'Lembrete de check-in',
            channelDescription: 'Lembrete semanal para pesar e medir',
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> cancelWeeklyCheckin() async {
    if (!await _init()) return;
    try {
      await _plugin.cancel(id: _checkinId);
    } catch (_) {}
  }

  /// Pulou o descanso / terminou o treino: tira a contagem e o alarme.
  Future<void> cancel() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: _id);
    } catch (_) {}
  }
}
