package com.example.nolauncher

import android.content.ComponentName
import android.content.Intent
import android.graphics.Bitmap
import android.media.session.MediaSessionManager
import android.media.MediaMetadata
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Base64
import android.util.Log
import java.io.ByteArrayOutputStream

class MediaNotificationListener : NotificationListenerService() {
    companion object {
        var currentMetadata: MediaMetadata? = null
    }

    override fun onListenerConnected() {
        Log.d("MediaListener", "Listener connected")
        val mediaSessionManager = getSystemService(MediaSessionManager::class.java)
        val controllers = mediaSessionManager.getActiveSessions(ComponentName(this, MediaNotificationListener::class.java))
        Log.d("MediaListener", "Controllers on connect: ${controllers.size}")
        for (controller in controllers) {
            val metadata = controller.metadata
            val state = controller.playbackState?.state
            if (metadata != null) {
                currentMetadata = metadata
                val title = metadata.getString(MediaMetadata.METADATA_KEY_TITLE)
                val artist = metadata.getString(MediaMetadata.METADATA_KEY_ARTIST)
                val stateStr = getStateString(state)
                Log.d("MediaListener", "Metadata on connect: $title - $artist [$stateStr]")
                sendUpdateToFlutter(title, artist, stateStr, metadata)
            }
        }
    }

    override fun onNotificationPosted(sbn: StatusBarNotification?) {
        Log.d("MediaListener", "Notification posted from: ${sbn?.packageName}")
        val mediaSessionManager = getSystemService(MediaSessionManager::class.java)
        val controllers = mediaSessionManager.getActiveSessions(ComponentName(this, MediaNotificationListener::class.java))
        Log.d("MediaListener", "Controllers: ${controllers.size}")

        for (controller in controllers) {
            val metadata = controller.metadata
            val state = controller.playbackState?.state
            if (metadata != null) {
                currentMetadata = metadata
                val title = metadata.getString(MediaMetadata.METADATA_KEY_TITLE)
                val artist = metadata.getString(MediaMetadata.METADATA_KEY_ARTIST)
                val stateStr = getStateString(state)
                Log.d("MediaListener", "🎵 Now Playing: $title - $artist [$stateStr]")
                sendUpdateToFlutter(title, artist, stateStr, metadata)
            }
        }
    }

    private fun getStateString(state: Int?): String {
        return when (state) {
            android.media.session.PlaybackState.STATE_PLAYING -> "playing"
            android.media.session.PlaybackState.STATE_PAUSED -> "paused"
            android.media.session.PlaybackState.STATE_STOPPED -> "stopped"
            else -> "unknown"
        }
    }

    private fun sendUpdateToFlutter(title: String?, artist: String?, state: String, metadata: MediaMetadata?) {
    val albumArt = metadata?.getBitmap(MediaMetadata.METADATA_KEY_ALBUM_ART)
    val albumUri = metadata?.getString(MediaMetadata.METADATA_KEY_ALBUM_ART_URI)
    val thumbnail: String? = albumArt?.let { bitmapToBase64(it) } ?: albumUri

    val update = mapOf(
        "title" to title,
        "artist" to artist,
        "state" to state,
        "thumbnail" to thumbnail,
    )
    MainActivity.eventSink?.success(update)
}

    private fun bitmapToBase64(bitmap: Bitmap): String {
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        val bytes = stream.toByteArray()
        return Base64.encodeToString(bytes, Base64.DEFAULT)
    }
}
