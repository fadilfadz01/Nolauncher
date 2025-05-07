import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/utils/shared_pref_sercice.dart';

class SettingsController extends GetxController {
  final _prefs = Get.put(SharedPrefSercice());

  final themeIcon = Icons.light_mode.obs;
  final isStatusbarVisible = true.obs;
  final isClockFormat24 = true.obs;
  final isDoubleTapToLock = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await _prefs.init();
    themeIcon.value = Get.isDarkMode ? Icons.light_mode : Icons.dark_mode;
    isClockFormat24.value = _prefs.getValue('clockFormat', true);
    isDoubleTapToLock.value = _prefs.getValue('doubleTapToLock', true);
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

  setClockFormat(value) async {
    isClockFormat24.value = value;
    await _prefs.setValue('clockFormat', value);
  }

  setDoubleTapToLock(value) async {
    isDoubleTapToLock.value = value;
    await _prefs.setValue('doubleTapToLock', value);
  }
}
