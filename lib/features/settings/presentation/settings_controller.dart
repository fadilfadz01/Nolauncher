import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/utils/shared_pref_sercice.dart';

class SettingsController extends GetxController {
  final _prefs = Get.find<SharedPrefSercice>();

  final themeIcon = Icons.light_mode.obs;
  final isclockFormat24 = true.obs;
  final isStatusbarVisible = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await _prefs.init();
    themeIcon.value = Get.isDarkMode ? Icons.light_mode : Icons.dark_mode;
    final format = _prefs.getValue('clockFormat', true);
    isclockFormat24.value = format;
    SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
      Future.delayed(Duration(seconds: 2), () {
        _prefs.getValue('statusBarVisibility', true)
            ? SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: SystemUiOverlay.values,
            )
            : SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual,
              overlays: [SystemUiOverlay.bottom],
            );
      });
    });
  }

  switchTheme() async {
    if (Get.isDarkMode) {
      Get.changeThemeMode(ThemeMode.light);
      themeIcon.value = Icons.dark_mode;
      await _prefs.setValue('themeMode', 1);
    } else {
      Get.changeThemeMode(ThemeMode.dark);
      themeIcon.value = Icons.light_mode;
      await _prefs.setValue('themeMode', 0);
    }
  }

  setClockFormat(value) async {
    isclockFormat24.value = value;
    await _prefs.setValue('clockFormat', value);
  }

  setStatusBar(value) async {
    isStatusbarVisible.value = value;
    if (value) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom],
      );
    }
    await _prefs.setValue('statusBarVisibility', value);
  }
}
