package com.copia.copia

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.UUID

class MainActivity : FlutterActivity() {
    private var pendingPdfPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        capturePdfIntent(intent)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "copia/pdf_intent"
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "consumeInitialPdfPath" -> {
                    result.success(pendingPdfPath)
                    pendingPdfPath = null
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        capturePdfIntent(intent)
    }

    private fun capturePdfIntent(intent: Intent?) {
        if (intent?.action != Intent.ACTION_VIEW) {
            return
        }
        val uri = intent.data ?: return
        val mimeType = contentResolver.getType(uri)?.lowercase().orEmpty()
        val uriText = uri.toString().lowercase()
        val isPdf = mimeType.contains("pdf") || uriText.endsWith(".pdf")
        if (!isPdf) {
            return
        }
        pendingPdfPath = copyUriToCache(uri)
    }

    private fun copyUriToCache(uri: Uri): String? {
        return try {
            val input = contentResolver.openInputStream(uri) ?: return null
            val targetDir = File(cacheDir, "opened_pdfs")
            if (!targetDir.exists()) {
                targetDir.mkdirs()
            }
            val targetFile = File(targetDir, "${UUID.randomUUID()}.pdf")
            FileOutputStream(targetFile).use { output ->
                input.use { it.copyTo(output) }
            }
            targetFile.absolutePath
        } catch (_: Exception) {
            null
        }
    }
}
