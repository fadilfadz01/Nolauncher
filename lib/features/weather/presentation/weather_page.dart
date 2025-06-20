import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nolauncher/core/config/constants.dart';
import 'package:nolauncher/features/weather/presentation/weather_controller.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherPage extends StatelessWidget {
  WeatherPage({super.key});
  final controller = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    final currentWeatherWidget = _buildCurrentWeather();
    final hourlyForecastWidget = _buildHourlyForecast();
    final dailyForecastWidget = _buildDailyForecast();
    final additionalInfoWidget = _buildAdditionalInfo();

    return Obx(
      () =>
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.weatherData.value == null
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    Icon(
                      Icons.signal_wifi_off,
                      size: 60,
                      color: AppColors.tertiary,
                    ),
                    Text(
                      "No internet connection",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 24,
                      children: [
                        currentWeatherWidget,
                        hourlyForecastWidget,
                        dailyForecastWidget,
                        additionalInfoWidget,
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _buildCurrentWeather() {
    return Obx(() {
      final currentCondition =
          controller.weatherData.value?.currentCondition[0];
      final location = controller.weatherData.value?.nearestArea[0];
      final locationName = location?.areaName[0].value;
      final country = location?.country[0].value;
      final region = location?.region[0].value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationName ?? "",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$region, $country',
                    style: const TextStyle(
                      color: AppColors.tertiary,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Last updated ${DateFormat(controller.settingsController.isClockFormat24.value ? "dd/MM/yyy HH:mm" : "dd/MM/yyy hh:mm aa").format(controller.lastUpdated.value ?? DateTime.now())}",
                        style: const TextStyle(
                          color: AppColors.tertiary,
                          fontSize: 14,
                        ),
                      ),
                      IconButton(
                        onPressed: controller.getWeatherInfo,
                        icon: Icon(Icons.replay_outlined),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: _buildWeatherIcon(
                  currentCondition?.weatherDesc[0].value ?? "",
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text(
                '${currentCondition?.tempC}°',
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      currentCondition?.weatherDesc[0].value ?? "",
                      style: const TextStyle(
                        fontSize: AppFontSizes.appRegularSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Feels like ${currentCondition?.feelsLikeC}°',
                      style: const TextStyle(
                        color: AppColors.tertiary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildHourlyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'HOURLY FORECAST',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Obx(
            () => Row(
              children:
                  controller.weatherData.value?.weather[0].hourly.map((hourly) {
                    final time = int.parse(hourly.time) ~/ 100;
                    final timeString =
                        time == 0
                            ? '12 AM'
                            : time == 12
                            ? '12 PM'
                            : time > 12
                            ? '${time - 12} PM'
                            : '$time AM';

                    return Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.tertiary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(
                          AppBorderSizes.defaultBordersize,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          Text(
                            timeString,
                            style: const TextStyle(fontSize: 14),
                          ),
                          _buildWeatherIcon(
                            hourly.weatherDesc[0].value,
                            size: 24,
                          ),
                          Text(
                            '${hourly.tempC}°',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'FORECAST',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Obx(
          () => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.weatherData.value?.weather.length,
            itemBuilder: (context, index) {
              final daily = controller.weatherData.value?.weather[index];
              final date = DateTime.parse(daily?.date ?? "");
              final dayName = DateFormat('EEEE').format(date);
              final isToday = index == 0;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(
                    AppBorderSizes.defaultBordersize,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isToday ? 'Today' : dayName,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Row(
                      children: [
                        _buildWeatherIcon(
                          daily?.hourly[4].weatherDesc[0].value ?? "",
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${daily?.maxtempC}° / ${daily?.mintempC}°',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        const Text(
          'DETAILS',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Obx(() {
          final currentCondition =
              controller.weatherData.value?.currentCondition[0];
          final astronomy =
              controller.weatherData.value?.weather[0].astronomy[0];

          final data = [
            {
              'label': 'Humidity',
              'value':
                  currentCondition != null
                      ? '${currentCondition.humidity}%'
                      : '--',
              'icon': Icons.water_drop_outlined,
            },
            {
              'label': 'Wind',
              'value':
                  currentCondition != null
                      ? '${currentCondition.windspeedKmph} km/h'
                      : '--',
              'icon': Icons.air,
            },
            {
              'label': 'UV Index',
              'value': currentCondition?.uvIndex ?? '--',
              'icon': Icons.wb_sunny_outlined,
            },
            {
              'label': 'Visibility',
              'value':
                  currentCondition != null
                      ? '${currentCondition.visibility} km'
                      : '--',
              'icon': Icons.visibility_outlined,
            },
            {
              'label': 'Sunrise',
              'value': astronomy?.sunrise ?? '--',
              'icon': Icons.wb_twilight,
            },
            {
              'label': 'Sunset',
              'value': astronomy?.sunset ?? '--',
              'icon': Icons.nightlight_round,
            },
          ];

          return SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final item = data[index];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildInfoCard(
                    item['label'] as String,
                    item['value'].toString(),
                    item['icon'] as IconData,
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppBorderSizes.defaultBordersize),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontSize: 14)),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: AppFontSizes.appRegularSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherIcon(String condition, {double size = 40}) {
    IconData icon;

    final lower = condition.toLowerCase();

    if (lower.contains('clear') || lower.contains('sunny')) {
      icon = WeatherIcons.day_sunny;
    } else if (lower.contains('overcast')) {
      icon = WeatherIcons.day_sunny_overcast;
    } else if (lower.contains('partly') || lower.contains('partly cloudy')) {
      icon = WeatherIcons.day_cloudy;
    } else if (lower.contains('cloud')) {
      icon = WeatherIcons.cloudy;
    } else if (lower.contains('rain') || lower.contains('drizzle')) {
      icon = WeatherIcons.rain;
    } else if (lower.contains('thunder')) {
      icon = WeatherIcons.thunderstorm;
    } else if (lower.contains('snow')) {
      icon = WeatherIcons.snow;
    } else if (lower.contains('fog') || lower.contains('mist')) {
      icon = WeatherIcons.fog;
    } else if (lower.contains('haze')) {
      icon = WeatherIcons.day_haze;
    } else if (lower.contains('wind')) {
      icon = WeatherIcons.strong_wind;
    } else {
      icon = WeatherIcons.na;
    }

    return Icon(icon, size: size);
  }
}
