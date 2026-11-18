package dev.joaopedro.nodefit

import android.content.Context
import android.media.RingtoneManager
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "nodefit/alert")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "restEnded" -> {
                        restEnded()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Fim do descanso: vibração longa (perceptível com o celular no bolso)
     * e o som de notificação do sistema, que respeita o modo silencioso.
     * Na Fatia 2 isso passa a vir também de uma notificação, para tocar
     * com a tela bloqueada.
     */
    private fun restEnded() {
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            (getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as VibratorManager)
                .defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(Context.VIBRATOR_SERVICE) as Vibrator
        }
        if (vibrator.hasVibrator()) {
            val pattern = longArrayOf(0, 500, 200, 500, 200, 800)
            vibrator.vibrate(VibrationEffect.createWaveform(pattern, -1))
        }
        try {
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
            RingtoneManager.getRingtone(applicationContext, uri)?.play()
        } catch (e: Exception) {
            // Sem som disponível: a vibração já avisou.
        }
    }
}
