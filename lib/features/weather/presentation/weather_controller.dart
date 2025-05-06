import 'dart:async';
import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nolauncher/core/network/api_client.dart';
import 'package:nolauncher/features/weather/data/weather.dart';

class WeatherController extends GetxController {
  final api = Get.put(ApiClient());

  final weatherData = Rx<WeatherResponse?>(null);
  final isLoading = true.obs;
  late Timer timer;

  @override
  void onInit() {
    super.onInit();
    getWeatherInfo();

    timer = Timer.periodic(const Duration(hours: 1), (timer) {
      getWeatherInfo();
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
  }

  void getWeatherInfo() async {
    final location = await _getCityNameFromLocation();
    final response = await api.request("https://wttr.in/$location?format=j1");
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      weatherData.value = WeatherResponse.fromJson(body);
      isLoading.value = false;
    } else {
      print("Error response");
    }
  }

  Future<String> _getCityNameFromLocation() async {
    // Check and request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return 'New York';
      }
    }
    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      // Reverse geocode to get placemarks
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        return place.locality ??
            place.subAdministrativeArea ??
            place.name ??
            'New York';
      }
    } catch (_) {}

    return 'New York';
  }
}
