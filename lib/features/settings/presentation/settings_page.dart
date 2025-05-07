import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final controller = Get.put(SettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: controller.switchTheme,
            icon: Obx(() => Icon(controller.themeIcon.value)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  spacing: 20,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Status bar visibility"),
                        Obx(
                          () => Switch(
                            value: controller.isStatusbarVisible.value,
                            onChanged: controller.setStatusBar,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("24 hour clock"),
                        Obx(
                          () => Switch(
                            value: controller.isClockFormat24.value,
                            onChanged: controller.setClockFormat,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Double tap to screen lock"),
                        Obx(
                          () => Switch(
                            value: controller.isDoubleTapToLock.value,
                            onChanged: controller.setDoubleTapToLock,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Text(
                  AppConstants.appName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Version ${AppConstants.appVersion}.${AppConstants.appBuildNumber}",
                ),
                Text("Developed by FADIL FADZ"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
