import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/features/home/presentation/home_controller.dart';

class AppsController extends GetxController {
  final homeController = Get.find<HomeController>();

  final TextEditingController searchEditingController = TextEditingController();
  final RxList<Application> listedApps = RxList([]);
  final searchText = ''.obs;

  @override
  void onInit() {
    searchEditingController.addListener(() {
      searchText.value = searchEditingController.text;
    });
    loadApps();
    super.onInit();
  }

  Future<void> loadApps() async {
    //List<AppInfo> apps = await InstalledApps.getInstalledApps();
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    // Sort apps alphabetically
    apps.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );

    homeController.allApps.value = apps;
    listedApps.value = apps;
  }
}
