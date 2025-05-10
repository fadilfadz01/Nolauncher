import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/music/presentation/music_controller.dart';

class MusicPage extends StatelessWidget {
  MusicPage({super.key});
  final controller = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    final thumbnailWidget = Obx(
      () => controller.buildThumbnail(context: context),
    );

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

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            // Song Title
                            Text(
                              controller.title.value,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Artist Name
                            Text(
                              controller.artist.value,
                              style: TextStyle(
                                color: AppColors.tertiary,
                                fontSize: AppFontSizes.appRegularSize,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
                              color: AppColors.tertiary,
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
                    Icon(Icons.music_off, size: 60, color: AppColors.tertiary),
                    Text(
                      "No media playing",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.tertiary,
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
                      style: TextStyle(fontSize: AppFontSizes.appTitleSize),
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
                  child: const Text("Open Settings"),
                ),
              ],
            ),
          );
    });
  }
}
