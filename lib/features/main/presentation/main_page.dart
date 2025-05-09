import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/utils/custom_scroll_physics.dart';
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
    controller.checkLauncherAndPrompt(context);

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
          child: Stack(
            children: [
              GestureDetector(
                onLongPress: () => Get.to(() => SettingsPage()),
                onDoubleTap: () {
                  controller.settingsController.isDoubleTapToLock.value
                      ? controller.lockScreen()
                      : null;
                },
                child: PageView.builder(
                  controller: controller.pageController,
                  scrollDirection: Axis.vertical,
                  itemCount: pages.length,
                  physics: const FastScrollPhysics(),
                  onPageChanged: (index) {
                    // Hide the keyboard when the page changes
                    FocusManager.instance.primaryFocus?.unfocus();
                    controller.displayPageIndicator();
                    controller.currentPageIndex.value = index;
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

              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (details) {
                      controller.initialDragX.value = details.globalPosition.dx;
                    },
                    onHorizontalDragUpdate: (details) {
                      final dragDistance =
                          details.globalPosition.dx -
                          controller.initialDragX.value;

                      // Trigger only if drag is from right edge and moving left enough
                      if (controller.initialDragX.value >
                              MediaQuery.of(context).size.width - 20 &&
                          dragDistance < -10) {
                        controller.displayPageIndicator();
                      }
                    },
                    child: Container(
                      width: 20, // right-edge swipe zone width
                      color:
                          Colors.transparent, // invisible but captures gestures
                    ),
                  ),
                ),
              ),

              Obx(
                () => Visibility(
                  visible:
                      controller.settingsController.isIndicatorVisible.value,
                  child: AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    right:
                        controller.showPageIndicator.value
                            ? 20
                            : -100, // Moves off-screen when hidden
                    top:
                        MediaQuery.of(context).size.height / 2 -
                        (pages.length * 20),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 15,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final iconsList = [
                          Icons.music_note,
                          Icons.cloud,
                          Icons.home,
                          Icons.apps,
                        ];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(pages.length, (index) {
                            bool isActive =
                                controller.currentPageIndex.value == index;
                            return GestureDetector(
                              onTap: () {
                                controller.pageController.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: Icon(
                                  iconsList[index],
                                  size:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color:
                                      isActive
                                          ? Theme.of(context).primaryColor
                                          : Colors.grey.withValues(alpha: 0.5),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
