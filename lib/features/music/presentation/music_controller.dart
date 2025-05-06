import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/utils/media_stream_service.dart';
import 'package:nolauncher/features/music/data/music.dart';

enum MusicCommands { play, pause, next, previous }

class MusicController extends GetxController {
  static const platform = MethodChannel('com.example.media_info');
  final isPermissionAllowed = false.obs;
  final isAvailable = false.obs;
  final title = ''.obs;
  final artist = ''.obs;
  final state = ''.obs;
  final thumbnail = ''.obs;
  final isPlaying = false.obs;

  @override
  void onInit() {
    getNowPlaying();
    MediaStreamService.mediaUpdates.listen((event) {
      final mediaInfo = Music.fromMap(event);

      title.value = mediaInfo.title;
      artist.value = mediaInfo.artist;
      thumbnail.value = mediaInfo.thumbnail ?? '';
      state.value = mediaInfo.state;
      isPlaying.value = mediaInfo.isPlaying;
      isAvailable.value = mediaInfo.isAvailable;
    });
    super.onInit();
  }

  Future<void> checkNotificationPermission() async {
    final isEnabled = await platform.invokeMethod<bool>(
      'checkNotificationPermission',
    );
    isPermissionAllowed.value = isEnabled == true ? true : false;
  }

  Future<void> openNotificationSettings() async {
    await platform.invokeMethod('openNotificationSettings');
  }

  Future<void> getNowPlaying() async {
    try {
      final result = await platform.invokeMethod('getNowPlaying');

      if (result != null) {
        final mediaInfo = Music.fromMap(Map<String, dynamic>.from(result));

        title.value = mediaInfo.title;
        artist.value = mediaInfo.artist;
        state.value = mediaInfo.state;
        thumbnail.value = mediaInfo.thumbnail ?? '';
        isPlaying.value = mediaInfo.isPlaying;
        isAvailable.value = mediaInfo.isAvailable;
      } else {
        isAvailable.value = false;
      }
    } catch (e) {
      print('Failed to get media info: $e');
    }
  }

  Future<void> getPlaybackState() async {
    try {
      final String state = await platform.invokeMethod('getPlaybackState');
      if (state == "playing") {
        isPlaying.value = true;
      }
    } catch (e) {
      print('Error getting playback state: $e');
    }
  }

  Future<void> sendMediaCommand(MusicCommands command) async {
    try {
      await platform.invokeMethod('sendCommand', {'command': command.name});
      getNowPlaying();
    } catch (e) {
      isAvailable.value = false;
      print('Failed to send media command: $e');
    }
  }
}
