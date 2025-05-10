import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/apps/presentation/apps_controller.dart';
import 'package:nolauncher/features/home/presentation/home_controller.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';

class PinnedAppsPage extends StatelessWidget {
  PinnedAppsPage({super.key});
  final controller = Get.find<SettingsController>();
  final appsController = Get.find<AppsController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final pinnedApps =
        homeController.pinnedApps
            .map(
              (packageName) => appsController.allApps.firstWhere(
                (app) => app.packageName == packageName,
              ),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pinned Apps",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:
          pinnedApps.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.all(20),
                child: ReorderableListView.builder(
                  onReorderStart:
                      (index) => controller.holdingPinnedAppIndex.value = index,
                  onReorderEnd:
                      (index) => controller.holdingPinnedAppIndex.value = null,
                  itemBuilder: (context, index) {
                    return Obx(
                      key: ValueKey(index),
                      () => ListTile(
                        trailing: Icon(Icons.drag_handle),
                        title: Text(
                          pinnedApps[index].appName,
                          style: TextStyle(
                            fontSize: AppFontSizes.appRegularSize,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppBorderSizes.defaultBordersize,
                          ),
                        ),
                        tileColor:
                            controller.holdingPinnedAppIndex.value == index
                                ? AppColors.tertiary
                                : null,
                      ),
                    );
                  },
                  itemCount: pinnedApps.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final packageName = pinnedApps.removeAt(oldIndex);
                    pinnedApps.insert(newIndex, packageName);
                    homeController.pinnedApps.value =
                        pinnedApps.map((e) => e.packageName).toList();
                    controller.pinnedAppReorder(
                      homeController.pinnedApps.toList(),
                    );
                  },
                ),
              )
              : Center(
                child: Text(
                  "No pinned apps",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.tertiary,
                  ),
                ),
              ),
    );
  }
}
