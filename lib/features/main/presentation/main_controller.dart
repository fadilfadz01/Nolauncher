import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nolauncher/features/settings/presentation/settings_controller.dart';

class MainController extends GetxController {
  static const lockPlatform = MethodChannel('com.fadilfadz.device_lock');
  static const settingsPlatform = MethodChannel(
    'com.fadilfadz.device_settings',
  );

  final settingsController = Get.put(SettingsController());

  late PageController pageController;
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: 2);
    scrollController = ScrollController();
    scrollController.addListener(() {
      // If user is at the very top and scrolling up
      if (scrollController.position.pixels <= 0 &&
          scrollController.position.userScrollDirection ==
              ScrollDirection.forward) {
        pageController.animateToPage(
          2,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
    scrollController.dispose();
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
}
