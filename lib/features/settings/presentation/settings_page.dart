import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';
import 'package:nolauncher/features/settings/presentation/widgets/hidden_apps_page.dart';
import 'package:nolauncher/features/settings/presentation/widgets/pinned_apps_page.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  final controller = Get.find<SettingsController>();

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status bar visibility",
                          style: TextStyle(fontSize: 18),
                        ),
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
                        Text(
                          "Double tap to screen lock",
                          style: TextStyle(fontSize: 18),
                        ),
                        Obx(
                          () => Switch(
                            value: controller.isDoubleTapToLock.value,
                            onChanged: controller.setDoubleTapToLock,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Page indicator", style: TextStyle(fontSize: 18)),
                        Obx(
                          () => Switch(
                            value: controller.isIndicatorVisible.value,
                            onChanged: controller.setPageIndicator,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("24 hour clock", style: TextStyle(fontSize: 18)),
                        Obx(
                          () => Switch(
                            value: controller.isClockFormat24.value,
                            onChanged: controller.setClockFormat,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => Get.to(() => PinnedAppsPage()),
                      child: Text(
                        "Pinned Apps",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.to(() => HiddenAppsPage()),
                      child: Text(
                        "Hidden Apps",
                        style: TextStyle(fontSize: 18),
                      ),
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
