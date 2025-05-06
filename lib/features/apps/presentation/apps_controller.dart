import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppsController extends GetxController {
  final TextEditingController searchEditingController = TextEditingController();
  final RxList<Application> allApps = RxList([]);
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

    // Filter out this app
    apps =
        apps.where((e) => e.packageName != "com.fadilfadz.nolauncher").toList();

    // Sort apps alphabetically
    apps.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );

    allApps.value = apps;
    listedApps.value = apps;
  }
}
