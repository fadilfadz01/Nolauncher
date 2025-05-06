import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
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
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  @override
  void onInit() {
    super.onInit();
    getWeatherInfo();

    timer = Timer.periodic(const Duration(hours: 1), (timer) {
      getWeatherInfo();
    });

    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        getWeatherInfo();
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    timer.cancel();
    _subscription.cancel();
  }

  void getWeatherInfo() async {
    final location = await _getCityNameFromLocation();
    final response = await api.request("https://wttr.in/$location?format=j1");
    if (response != null && response.statusCode == 200) {
      final body = json.decode(response.body);
      weatherData.value = WeatherResponse.fromJson(body);
    } else {
      print("Error response");
    }
    isLoading.value = false;
  }

  Future<String> _getCityNameFromLocation() async {
    const fallbackCity = 'New York';

    try {
      // Check and request location permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return fallbackCity;
        }
      }

      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return fallbackCity;

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      // Reverse geocode to get city/placemark
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return place.locality?.isNotEmpty == true
            ? place.locality!
            : (place.subAdministrativeArea?.isNotEmpty == true
                ? place.subAdministrativeArea!
                : (place.name?.isNotEmpty == true
                    ? place.name!
                    : fallbackCity));
      }
    } catch (e) {
      print('Location fetch error: $e');
    }

    return fallbackCity;
  }
}
