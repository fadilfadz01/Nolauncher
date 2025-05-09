package com.fadilfadz.nolauncher

import android.app.admin.DevicePolicyManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.media.MediaMetadata
import android.media.session.MediaSessionManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Base64
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val MEDIA_CHANNEL = "com.fadilfadz.media_info"
    private val LOCK_CHANNEL = "com.fadilfadz.device_lock"
    private val EVENT_CHANNEL = "com.fadilfadz.media_updates"
    private val SETTINGS_CHANNEL = "com.fadilfadz.device_settings"
    private val HOME_CHANNEL = "com.fadilfadz.home_screen"

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MEDIA_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getNowPlaying") {
                val metadata = MediaNotificationListener.currentMetadata
                val mediaSessionManager = getSystemService(MediaSessionManager::class.java)
                val componentName = ComponentName(this, MediaNotificationListener::class.java)
                val controllers = mediaSessionManager.getActiveSessions(componentName)

                if (metadata != null && controllers.isNotEmpty()) {
                    val title = metadata.getString(MediaMetadata.METADATA_KEY_TITLE)
                    val artist = metadata.getString(MediaMetadata.METADATA_KEY_ARTIST)
                    val albumArt = metadata.getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART)
                    val albumUri = metadata.getString(MediaMetadata.METADATA_KEY_ALBUM_ART_URI)
                    val thumbnail: String? = albumArt?.let { bitmapToBase64(it) } ?: albumUri

                    val playbackState = controllers[0].playbackState
                    val state = when (playbackState?.state) {
                        android.media.session.PlaybackState.STATE_PLAYING -> "playing"
                        android.media.session.PlaybackState.STATE_PAUSED -> "paused"
                        android.media.session.PlaybackState.STATE_STOPPED -> "stopped"
                        else -> "unknown"
                    }

                    Log.d("MainActivity", "Returning metadata: $title - $artist [$state]")
                    result.success(mapOf(
                        "title" to title,
                        "artist" to artist,
                        "state" to state,
                        "thumbnail" to thumbnail
                    ))
                } else {
                    Log.d("MainActivity", "No metadata or controller available yet")
                    result.success(null)
                }
            } else if (call.method == "sendCommand") {
                val command = call.argument<String>("command")
                if (command != null) {
                    val mediaSessionManager = getSystemService(MediaSessionManager::class.java)
                    val componentName = ComponentName(this, MediaNotificationListener::class.java)
                    val controllers = mediaSessionManager.getActiveSessions(componentName)

                    if (controllers.isNotEmpty()) {
                        val controller = controllers[0]
                        when (command) {
                            "play" -> controller.transportControls.play()
                            "pause" -> controller.transportControls.pause()
                            "next" -> controller.transportControls.skipToNext()
                            "previous" -> controller.transportControls.skipToPrevious()
                        }
                        Log.d("MainActivity", "Sent command: $command to ${controller.packageName}")
                        result.success("Command sent: $command")
                    } else {
                        Log.d("MainActivity", "No active media controllers")
                        result.error("NO_CONTROLLER", "No active media controllers", null)
                    }
                } else {
                    result.error("INVALID_COMMAND", "Command not provided", null)
                }
            } else if (call.method == "getPlaybackState") {
                val mediaSessionManager = getSystemService(MediaSessionManager::class.java)
                val componentName = ComponentName(this, MediaNotificationListener::class.java)
                val controllers = mediaSessionManager.getActiveSessions(componentName)

                if (controllers.isNotEmpty()) {
                    val controller = controllers[0]
                    val playbackState = controller.playbackState
                    val state = when (playbackState?.state) {
                        android.media.session.PlaybackState.STATE_PLAYING -> "playing"
                        android.media.session.PlaybackState.STATE_PAUSED -> "paused"
                        android.media.session.PlaybackState.STATE_STOPPED -> "stopped"
                        else -> "unknown"
                    }
                    Log.d("MainActivity", "Playback state: $state")
                    result.success(state)
                } else {
                    result.success("no_media")
                }
            }
            else if (call.method == "checkNotificationPermission") {
                val enabledListeners = android.provider.Settings.Secure.getString(
                    contentResolver,
                    "enabled_notification_listeners"
                )
                val packageName = applicationContext.packageName
                val isEnabled = enabledListeners?.contains(packageName) == true
                Log.d("MainActivity", "Notification permission enabled: $isEnabled")
                result.success(isEnabled)
            }
            else if (call.method == "openNotificationSettings") {
                val intent = Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS")
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                result.success(true)
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HOME_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "isDefaultLauncher") {
                val pm = packageManager
                val intent = Intent(Intent.ACTION_MAIN)
                intent.addCategory(Intent.CATEGORY_HOME)
                val resolveInfo = pm.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
                val currentLauncher = resolveInfo?.activityInfo?.packageName
                val isDefault = currentLauncher == packageName
                result.success(isDefault)
            } else if (call.method == "openDefaultLauncherSettings") {
                try {
                    val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        Intent(Settings.ACTION_HOME_SETTINGS)
                    } else {
                        Intent(Intent.ACTION_MAIN).apply {
                            addCategory(Intent.CATEGORY_HOME)
                        }
                    }
                    startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Could not open settings", e.message)
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, LOCK_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "lockScreen") {
                val devicePolicyManager = getSystemService(Context.DEVICE_POLICY_SERVICE) as DevicePolicyManager
                val componentName = ComponentName(this, MyDeviceAdminReceiver::class.java)

                if (devicePolicyManager.isAdminActive(componentName)) {
                    devicePolicyManager.lockNow()
                    result.success(null)
                } else {
                    result.error("NOT_ADMIN", "App is not a device admin", null)
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SETTINGS_CHANNEL)
        .setMethodCallHandler { call, result ->
            if (call.method == "openDeviceAdminSettings") {
                val intent = Intent().setComponent(
                    ComponentName("com.android.settings", "com.android.settings.DeviceAdminSettings")
                )
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                result.success(true)
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    Log.d("MainActivity", "Flutter started listening for updates.")
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    Log.d("MainActivity", "Flutter stopped listening.")
                    eventSink = null
                }
            }
        )
    }

    private fun bitmapToBase64(bitmap: Bitmap): String {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val bytes = stream.toByteArray()
        return Base64.encodeToString(bytes, Base64.DEFAULT)
    }
}
