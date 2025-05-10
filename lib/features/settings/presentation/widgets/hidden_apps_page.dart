import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/apps/presentation/apps_controller.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';

class HiddenAppsPage extends StatelessWidget {
  HiddenAppsPage({super.key});
  final controller = Get.find<SettingsController>();
  final appsController = Get.find<AppsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hidden Apps",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: appsController.allApps.length,
        itemBuilder: (context, index) {
          return ListTile(
            trailing: Obx(
              () => Checkbox(
                value: controller.hiddenApps.contains(
                  appsController.allApps[index].packageName,
                ),
                onChanged: (value) {
                  if (value == true) {
                    controller.hiddenApps.add(
                      appsController.allApps[index].packageName,
                    );
                  } else {
                    controller.hiddenApps.remove(
                      appsController.allApps[index].packageName,
                    );
                  }
                  appsController.listedApps.value =
                      appsController.allApps
                          .where(
                            (e) =>
                                !controller.hiddenApps.contains(
                                  e.packageName,
                                ) &&
                                (e.appName.toLowerCase().startsWith(
                                      appsController
                                          .searchEditingController
                                          .text
                                          .trim()
                                          .toLowerCase(),
                                    ) ||
                                    e.appName.toLowerCase().contains(
                                      appsController
                                          .searchEditingController
                                          .text
                                          .trim()
                                          .toLowerCase(),
                                    )),
                          )
                          .toList();
                  controller.hiddenAppChanged();
                },
              ),
            ),
            title: Text(
              appsController.allApps[index].appName,
              style: TextStyle(fontSize: AppFontSizes.appRegularSize),
            ),
            //onTap: () {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppBorderSizes.defaultBordersize,
              ),
            ),
          );
        },
      ),
    );
  }
}
