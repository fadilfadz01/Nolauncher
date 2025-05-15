import 'package:flutter/services.dart';

class AppEventListener {
  static const _eventChannel = EventChannel(
    'com.fadilfadz.nolauncher/app_changes',
  );

  void startListening(Function(String eventType, String packageName) onChange) {
    _eventChannel.receiveBroadcastStream().listen((event) {
      if (event is String) {
        final parts = event.split(':');
        if (parts.length == 2) {
          final eventType = parts[0]; // "installed" or "uninstalled"
          final packageName = parts[1];
          onChange(eventType, packageName);
        }
      }
    });
  }
}
