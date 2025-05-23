import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';
import 'package:preload_page_view/preload_page_view.dart';

class MainController extends GetxController {
  static const lockPlatform = MethodChannel(
    'com.fadilfadz.nolauncher/device_lock',
  );
  static const homeplatform = MethodChannel(
    'com.fadilfadz.nolauncher/home_screen',
  );
  static const settingsPlatform = MethodChannel(
    'com.fadilfadz.nolauncher/device_settings',
  );

  final settingsController = Get.put(SettingsController());

  final scrollController = ScrollController();
  static const defaultPage = 2;
  final pageController = PreloadPageController(initialPage: defaultPage);
  final currentPageIndex = defaultPage.obs;
  final showPageIndicator = false.obs;
  final initialDragX = 0.0.obs;
  bool isLauncherAlertShown = false;
  Timer? _indicatorTimer;

  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener(() {
      // If user is at the very top and scrolling up
      if (scrollController.position.pixels <= 0 &&
          scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        switchPageToDefault();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    scrollController.dispose();
    _indicatorTimer?.cancel();
  }

  switchPageToDefault() {
    pageController.animateToPage(
      defaultPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  displayPageIndicator() async {
    showPageIndicator.value = true;
    _indicatorTimer?.cancel(); // cancel previous timer
    _indicatorTimer = Timer(Duration(seconds: 2), () {
      showPageIndicator.value = false;
    });
  }

  Future<void> lockScreen() async {
    try {
      await lockPlatform.invokeMethod('lockScreen');
    } on PlatformException catch (e) {
      print("Failed to lock screen: ${e.message}");
      _openDeviceAdminSettings();
    }
  }

  static Future<void> _openDeviceAdminSettings() async {
    try {
      await settingsPlatform.invokeMethod('openDeviceAdminSettings');
    } on PlatformException catch (e) {
      print('Failed to open settings: ${e.message}');
    }
  }

  static Future<bool> _isDefaultLauncher() async {
    try {
      final bool result = await homeplatform.invokeMethod('isDefaultLauncher');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check default launcher: '${e.message}'.");
      return false;
    }
  }

  static Future<void> _openDefaultLauncherSettings() async {
    try {
      await homeplatform.invokeMethod('openDefaultLauncherSettings');
    } on PlatformException catch (e) {
      print("Failed to open settings: '${e.message}'.");
    }
  }

  Future<void> checkLauncherAndPrompt(BuildContext context) async {
    bool isDefault = await _isDefaultLauncher();

    if (!isDefault && !isLauncherAlertShown) {
      Get.dialog(
        barrierColor: AppColors.tertiary.withValues(alpha: 0.5),
        AlertDialog(
          title: Center(
            child: const Text(
              AppConstants.appName,
              style: TextStyle(fontSize: AppFontSizes.appTitleSize),
            ),
          ),
          content: const Text('The app is not set as the default home screen.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Get.back(); // Closes the dialog
                _openDefaultLauncherSettings(); // Opens settings
              },
              child: const Text('Open Settings'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      );

      isLauncherAlertShown = true;
    }
  }
}
