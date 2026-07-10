package com.compuhomesoluciones.radiosentimientos

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
  private val CHANNEL = "app/minimizer"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
      .setMethodCallHandler { call, result ->
        when (call.method) {
          "minimizeApp" -> {
            try {
              moveTaskToBack(true)
              result.success(true)
            } catch (e: Exception) {
              result.error("MINIMIZE_ERROR", e.message, null)
            }
          }
          else -> result.notImplemented()
        }
      }
  }
}
