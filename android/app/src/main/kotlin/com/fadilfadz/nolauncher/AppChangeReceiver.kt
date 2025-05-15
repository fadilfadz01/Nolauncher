package com.fadilfadz.nolauncher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import io.flutter.plugin.common.EventChannel

// This object holds a reference to the Dart event sink
object AppChangeStreamHandler {
    var eventSink: EventChannel.EventSink? = null
}

class AppChangeReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.action
        val packageName = intent?.data?.schemeSpecificPart

        when (action) {
            Intent.ACTION_PACKAGE_ADDED -> {
                Log.d("AppChangeReceiver", "Installed: $packageName")
                AppChangeStreamHandler.eventSink?.success("installed:$packageName")
            }
            Intent.ACTION_PACKAGE_REMOVED -> {
                Log.d("AppChangeReceiver", "Uninstalled: $packageName")
                AppChangeStreamHandler.eventSink?.success("uninstalled:$packageName")
            }
        }
    }
}
