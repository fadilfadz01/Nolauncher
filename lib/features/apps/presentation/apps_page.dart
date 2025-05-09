import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/core/utils/custom_scroll_physics.dart';
import 'package:nolauncher/features/apps/presentation/apps_controller.dart';
import 'package:nolauncher/features/home/presentation/home_controller.dart';
import 'package:nolauncher/features/main/presentation/main_controller.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';

class AppsPage extends StatelessWidget {
  AppsPage({super.key});
  final controller = Get.find<AppsController>();
  final mainController = Get.find<MainController>();
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: TextField(
            controller: controller.searchEditingController,
            style: TextStyle(fontSize: AppFontSizes.smallSize),
            decoration: InputDecoration(
              hintText: "Search apps",
              hintStyle: TextStyle(
                fontSize: AppFontSizes.smallSize,
                color: Colors.grey,
              ),
              suffixIcon: Obx(() {
                return controller.searchText.value.isNotEmpty
                    ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        controller.searchEditingController.clear();
                        controller.searchText.value =
                            ''; // Reset the observable text
                        controller.listedApps.value = controller.allApps;
                      },
                    )
                    : const SizedBox.shrink();
              }),
            ),
            onChanged: (value) async {
              final settingsController = Get.find<SettingsController>();
              controller.listedApps.value =
                  controller.allApps
                      .where(
                        (e) =>
                            !settingsController.hiddenApps.contains(
                              e.packageName,
                            ) &&
                            (e.appName.toLowerCase().startsWith(
                                  controller.searchEditingController.text
                                      .trim()
                                      .toLowerCase(),
                                ) ||
                                e.appName.toLowerCase().contains(
                                  controller.searchEditingController.text
                                      .trim()
                                      .toLowerCase(),
                                )),
                      )
                      .toList();
            },
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              controller: mainController.scrollController,
              physics: const FastBouncingScrollPhysics(),
              itemCount: controller.listedApps.length,
              itemBuilder: (context, index) {
                final app = controller.listedApps[index];
                return Obx(
                  () => ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Text(
                      app.appName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: AppFontSizes.allAppsSize,
                      ),
                    ),
                    onTap: () => homeController.launchApp(app.packageName),
                    onLongPress: () async {
                      homeController.togglePinApp(app.packageName);
                    },
                    trailing:
                        homeController.pinnedApps.contains(app.packageName)
                            ? const Icon(Icons.push_pin)
                            : null,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
