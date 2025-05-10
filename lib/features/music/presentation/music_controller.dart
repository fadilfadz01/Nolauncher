import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/core/utils/media_stream_service.dart';
import 'package:nolauncher/features/music/data/music.dart';

enum MusicCommands { play, pause, next, previous }

class MusicController extends GetxController with WidgetsBindingObserver {
  static const platform = MethodChannel('com.fadilfadz.media_info');

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
    checkNotificationPermission();
    WidgetsBinding.instance.addObserver(this);
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

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
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

  Widget buildThumbnail({required BuildContext context}) {
    final String raw = thumbnail.value.trim();

    // Show fallback if the value is empty
    if (raw.isEmpty) {
      return _fallbackThumbnail(context: context);
    }

    try {
      // Check if it's a URL
      if (raw.toLowerCase().startsWith('http')) {
        return _buildImageContainer(context: context, image: NetworkImage(raw));
      } else {
        // Assume it's Base64
        final sanitized = raw.replaceAll(RegExp(r'\s+'), '');
        final padded = sanitized.padRight((sanitized.length + 3) ~/ 4 * 4, '=');
        final bytes = base64Decode(padded);
        return _buildImageContainer(
          context: context,
          image: MemoryImage(bytes),
        );
      }
    } catch (e) {
      debugPrint("Thumbnail decode/load failed: $e");
      return _fallbackThumbnail(context: context);
    }
  }

  Widget _buildImageContainer({
    required BuildContext context,
    required ImageProvider image,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      height: MediaQuery.of(context).size.width / 1.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppBorderSizes.defaultBordersize),
        boxShadow: [
          BoxShadow(color: AppColors.tertiary, blurRadius: 15, spreadRadius: 1),
        ],
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
    );
  }

  Widget _fallbackThumbnail({required BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      height: MediaQuery.of(context).size.width / 1.6,
      decoration: BoxDecoration(
        color: AppColors.tertiary[900],
        borderRadius: BorderRadius.circular(AppBorderSizes.defaultBordersize),
        boxShadow: [
          BoxShadow(color: AppColors.tertiary, blurRadius: 15, spreadRadius: 1),
        ],
      ),
      child: Center(
        child: Icon(Icons.music_note, size: 120, color: AppColors.tertiary),
      ),
    );
  }
}
