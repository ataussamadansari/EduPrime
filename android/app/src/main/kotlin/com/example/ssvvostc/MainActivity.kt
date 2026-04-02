package com.example.ssvvostc

import android.app.DownloadManager
import android.content.Context
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Environment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.ssvvostc/media_scan"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    // Scan an already-saved file so it appears in Files app
                    "scan" -> {
                        val path = call.argument<String>("path")
                        if (path != null) {
                            MediaScannerConnection.scanFile(
                                applicationContext,
                                arrayOf(path),
                                null
                            ) { _, _ -> }
                            result.success(null)
                        } else {
                            result.error("INVALID_PATH", "Path is null", null)
                        }
                    }

                    // Download via Android DownloadManager — shows in Files/Downloads
                    "download" -> {
                        val url      = call.argument<String>("url")
                        val fileName = call.argument<String>("fileName")
                        val token    = call.argument<String>("token")

                        if (url == null || fileName == null) {
                            result.error("INVALID_ARGS", "url and fileName required", null)
                            return@setMethodCallHandler
                        }

                        try {
                            val dm = getSystemService(Context.DOWNLOAD_SERVICE)
                                    as DownloadManager

                            val request = DownloadManager.Request(Uri.parse(url))
                                .setTitle(fileName)
                                .setDescription("Downloading certificate...")
                                .setNotificationVisibility(
                                    DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED
                                )
                                .setDestinationInExternalPublicDir(
                                    Environment.DIRECTORY_DOWNLOADS, fileName
                                )
                                .setAllowedOverMetered(true)
                                .setAllowedOverRoaming(true)

                            if (token != null) {
                                request.addRequestHeader("Authorization", "Bearer $token")
                            }

                            val downloadId = dm.enqueue(request)
                            val savePath = Environment
                                .getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
                                .absolutePath + "/$fileName"

                            result.success(mapOf(
                                "downloadId" to downloadId,
                                "savePath"   to savePath
                            ))
                        } catch (e: Exception) {
                            result.error("DOWNLOAD_ERROR", e.message, null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
