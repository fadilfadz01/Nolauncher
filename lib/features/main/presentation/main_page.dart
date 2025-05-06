import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/features/apps/presentation/apps_page.dart';
import 'package:nolauncher/features/home/presentation/home_page.dart';
import 'package:nolauncher/features/main/presentation/main_controller.dart';
import 'package:nolauncher/features/music/presentation/music_page.dart';
import 'package:nolauncher/features/settings/presentation/settings_page.dart';
import 'package:nolauncher/features/weather/presentation/weather_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final controller = Get.put(MainController());

  final pages = [MusicPage(), WeatherPage(), HomePage(), AppsPage()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        controller.pageController.animateToPage(
          2,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onLongPress: () => Get.to(() => SettingsPage()),
            child: PageView.builder(
              controller: controller.pageController,
              scrollDirection: Axis.vertical,
              itemCount: pages.length,
              onPageChanged: (index) {
                // Hide the keyboard when the page changes
                FocusManager.instance.primaryFocus?.unfocus();
              },
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: controller.pageController,
                  builder: (context, child) {
                    double position =
                        index - (controller.pageController.page ?? 0.0);
                    double opacity = 1.0 - position.abs().clamp(0.0, 1.0);

                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: opacity,
                      child: child,
                    );
                  },
                  child: pages[index],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
