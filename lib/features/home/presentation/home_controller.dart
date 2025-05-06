import 'dart:async';

import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nolauncher/core/utils/shared_pref_sercice.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';

class HomeController extends GetxController {
  final _prefs = Get.put(SharedPrefSercice());
  final settingsController = Get.put(SettingsController());

  final RxList<String> pinnedApps = RxList([]);
  final RxString currentTime = ''.obs;
  final RxString currentTimeType = ''.obs;
  final RxString currentDate = ''.obs; // Variable to hold the current date
  late Timer timer;

  @override
  void onInit() async {
    super.onInit();

    await _prefs.init();
    final isStatusbarVisible = _prefs.getValue("statusBarVisibility", true);
    settingsController.setStatusBar(isStatusbarVisible);

    loadPinnedApps();
    loadTheme();

    // Update time every second
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTimeAndDate();
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }

  void updateTimeAndDate() {
    final format = _prefs.getValue('clockFormat', true);
    final now = DateTime.now();
    final timeFormatter = DateFormat(format ? 'HH:mm' : 'hh:mm');
    final timeTypeFormatter = DateFormat(format ? '' : 'a');
    final dateFormatter = DateFormat('EEE, MMM dd'); // Change to this format
    currentTime.value = timeFormatter.format(now);
    currentTimeType.value = timeTypeFormatter.format(now);
    currentDate.value = dateFormatter.format(now); // Update to the new format
  }

  void loadTheme() {
    final themeMode = _prefs.getValue('themeMode', 0);
    Get.changeThemeMode(themeMode == 0 ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> loadPinnedApps() async {
    pinnedApps.value = _prefs.getValue('pinnedApps', <String>[]);
  }

  Future<void> savePinnedApps() async {
    await _prefs.setValue('pinnedApps', pinnedApps.toList());
  }

  void togglePinApp(String packageName) {
    if (pinnedApps.contains(packageName)) {
      pinnedApps.remove(packageName);
    } else {
      if (pinnedApps.length < 6) {
        pinnedApps.add(packageName);
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('You can only pin up to 6 apps.'),
        //     backgroundColor: Colors.red,
        //   ),
        // );
      }
    }
    savePinnedApps();
  }

  Future<bool?> launchApp(packageName) async {
    final isInstalled = await DeviceApps.isAppInstalled(packageName);
    if (isInstalled == true) {
      return await DeviceApps.openApp(packageName);
    }
    return false;
  }
}
