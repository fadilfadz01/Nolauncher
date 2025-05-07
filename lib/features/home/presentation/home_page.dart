import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/apps/presentation/apps_controller.dart';
import 'package:nolauncher/features/home/presentation/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final controller = Get.put(HomeController());
  final appsController = Get.put(AppsController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Clock
        GestureDetector(
          onTap: () async {
            const clockPackages = [
              'com.android.deskclock',
              'com.android.alarmclock',
              'com.google.android.deskclock',
              'com.htc.android.worldclock',
              'com.sec.android.app.clockpackage',
              'com.motorola.blur.alarmclock',
              'com.lge.clock',
              'com.sonyericsson.alarm',
              'zte.com.cn.alarmclock',
              'com.oneplus.deskclock',
              'com.coloros.alarmclock',
              'com.vivo.alarmclock',
              'com.huawei.deskclock',
              'com.miui.clock',
              'com.realme.clock',
              'com.lenovo.alarmclock',
              'com.oppo.alarmclock',
              'com.asus.deskclock',
              'com.evenwell.AlarmClock',
            ];
            final clocks = appsController.allApps.where(
              (e) =>
                  e.appName.toLowerCase() == "clock" ||
                  e.appName.toLowerCase() == "alarm",
            );
            for (final clock in clocks) {
              if (clockPackages.contains(clock.packageName)) {
                controller.launchApp(clock.packageName);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Obx(
              () => Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.currentTime.value,
                        style: const TextStyle(
                          fontSize: AppFontSizes.clockTimeSize,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                          controller.currentTimeType.value,
                          style: const TextStyle(
                            fontSize: AppFontSizes.smallSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    controller.currentDate.value,
                    style: const TextStyle(
                      fontSize: AppFontSizes.clockDateSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Pinned apps
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    controller.pinnedApps.map((packageName) {
                      // Find the app with this package name
                      final appList =
                          appsController.allApps
                              .where((app) => app.packageName == packageName)
                              .toList();
                      if (appList.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      final app = appList.first;

                      return GestureDetector(
                        onTap: () {
                          controller.launchApp(packageName);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: Text(
                            app.appName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: AppFontSizes.pinnedAppsSize,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),
        ),

        // Buttons
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () async {
                  // Try common dialer package names
                  const dialerPackages = [
                    'com.google.android.dialer',
                    'com.samsung.android.dialer',
                    'com.oneplus.dialer',
                    'com.miui.contacts',
                    'com.coloros.dialer',
                    'com.vivo.dialer',
                    'com.android.incallui',
                    'com.huawei.contacts',
                    'com.android.dialer',
                    'com.realme.dialer',
                    'com.asus.dialer',
                    'com.motorola.dialer',
                    'com.sonyericsson.android.socialphonebook',
                    'com.lge.contacts',
                    'com.htc.contacts',
                    'com.lenovo.dialer',
                    'com.evenwell.Dialer',
                  ];
                  final phones = appsController.allApps.where(
                    (e) => e.appName.toLowerCase() == "phone",
                  );
                  for (final phone in phones) {
                    if (dialerPackages.contains(phone.packageName)) {
                      controller.launchApp(phone.packageName);
                    }
                  }
                },
                icon: const Icon(Icons.phone, size: 28),
              ),
              IconButton(
                onPressed: () async {
                  const cameraPackages = [
                    'com.google.android.GoogleCamera',
                    'com.sec.android.app.camera',
                    'com.oneplus.camera',
                    'com.android.camera',
                    'com.miui.camera',
                    'com.coloros.camera',
                    'com.vivo.camera',
                    'com.huawei.camera',
                    'com.oppo.camera',
                    'com.asus.camera',
                    'com.motorola.camera',
                    'com.sonyericsson.android.camera',
                    'com.lge.camera',
                    'com.htc.camera',
                    'com.lenovo.camera',
                    'com.evenwell.Camera2',
                    'com.android.camera2',
                  ];
                  final cameras = appsController.allApps.where(
                    (e) => e.appName.toLowerCase() == "camera",
                  );
                  for (final camera in cameras) {
                    if (cameraPackages.contains(camera.packageName)) {
                      controller.launchApp(camera.packageName);
                    }
                  }
                },
                icon: const Icon(Icons.camera_alt, size: 28),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
