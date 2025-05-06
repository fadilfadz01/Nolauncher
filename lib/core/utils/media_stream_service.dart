import 'package:flutter/services.dart';

class MediaStreamService {
  static const _mediaUpdates = EventChannel('com.example.media_updates');

  static Stream<Map<String, dynamic>> get mediaUpdates {
    return _mediaUpdates.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event);
    });
  }
}
