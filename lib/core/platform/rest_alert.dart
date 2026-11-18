import 'package:flutter/services.dart';

/// Alerta de fim do descanso. No Android vibra forte e toca o som de
/// notificação do sistema (canal nativo em MainActivity.kt). Onde o canal
/// não existe (testes, outras plataformas), cai para uma vibração simples.
abstract final class RestAlert {
  static const _channel = MethodChannel('nodefit/alert');

  static Future<void> restEnded() async {
    try {
      await _channel.invokeMethod<void>('restEnded');
    } catch (_) {
      await HapticFeedback.heavyImpact();
    }
  }
}
