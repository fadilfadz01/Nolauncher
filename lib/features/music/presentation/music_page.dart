import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/features/music/presentation/music_controller.dart';

class MusicPage extends StatelessWidget {
  MusicPage({super.key});
  final controller = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    controller.checkNotificationPermission();
    final thumbnailWidget = Obx(() => controller.buildThumbnail());

    return Obx(() {
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
                      thumbnailWidget,

                      Column(
                        children: [
                          // Song Title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
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
                            () =>
                                controller.sendMediaCommand(MusicCommands.next),
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
                    const Text(
                      "To show media info, enable notification access.",
                    ),
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
    });
  }
}
