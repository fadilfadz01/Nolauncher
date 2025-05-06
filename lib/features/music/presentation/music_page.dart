import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/features/music/presentation/music_controller.dart';

class MusicPage extends StatelessWidget {
  MusicPage({super.key});
  final controller = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    controller.checkNotificationPermission();

    return controller.isPermissionAllowed.value
        ? controller.isAvailable.value
            ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Now Playing', style: TextStyle(fontSize: 30)),

                Column(
                  spacing: 20,
                  children: [
                    // Music Thumbnail
                    _buildThumbnail(),

                    Column(
                      children: [
                        // Song Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            controller.title.value,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Artist Name
                        Text(
                          controller.artist.value,
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),

                // Playback Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 40,
                  children: [
                    // Previous Button
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 40),
                      onPressed:
                          () => controller.sendMediaCommand(
                            MusicCommands.previous,
                          ),
                    ),

                    // Play/Pause Button
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 25,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 42,
                        ),
                        onPressed: () {
                          controller.sendMediaCommand(
                            controller.isPlaying.value
                                ? MusicCommands.pause
                                : MusicCommands.play,
                          );
                          controller.isPlaying.value =
                              !controller.isPlaying.value;
                        },
                      ),
                    ),

                    // Next Button
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 40),
                      onPressed:
                          () => controller.sendMediaCommand(MusicCommands.next),
                    ),
                  ],
                ),
              ],
            )
            : Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 12,
                children: [
                  Icon(Icons.music_off, size: 60, color: Colors.grey),
                  Text(
                    "No media playing",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
        : Center(
          child: Column(
            spacing: 20,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const Text(
                    "Enable Notification Access",
                    style: TextStyle(fontSize: 26),
                  ),
                  const Text("To show media info, enable notification access."),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.openNotificationSettings();
                  Get.back();
                },
                child: const Text(
                  "Open Settings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildThumbnail() {
    final String raw = controller.thumbnail.value.trim();

    // Show fallback if the value is empty
    if (raw.isEmpty) {
      return _fallbackThumbnail();
    }

    try {
      // Check if it's a URL
      if (raw.toLowerCase().startsWith('http')) {
        return _buildImageContainer(image: NetworkImage(raw));
      } else {
        // Assume it's Base64
        final sanitized = raw.replaceAll(RegExp(r'\s+'), '');
        final padded = sanitized.padRight((sanitized.length + 3) ~/ 4 * 4, '=');
        final bytes = base64Decode(padded);
        return _buildImageContainer(image: MemoryImage(bytes));
      }
    } catch (e) {
      debugPrint("Thumbnail decode/load failed: $e");
      return _fallbackThumbnail();
    }
  }

  Widget _buildImageContainer({required ImageProvider image}) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 15, spreadRadius: 1),
        ],
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
    );
  }

  Widget _fallbackThumbnail() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 15, spreadRadius: 1),
        ],
      ),
      child: Center(
        child: Icon(Icons.music_note, size: 120, color: Colors.grey),
      ),
    );
  }
}
