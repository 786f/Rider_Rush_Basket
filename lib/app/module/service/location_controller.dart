import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'location_service.dart';

class LocationController extends GetxController {
  var isLoading = false.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = "".obs;

  Future<void> askLocationPermissionAndFetch() async {
    try {
      isLoading(true);

      final position = await LocationService.getCurrentLocation();

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      final addr = await LocationService.getAddress(
        position.latitude,
        position.longitude,
      );

      address.value = addr;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble("lat", latitude.value);
      await prefs.setDouble("lng", longitude.value);
      await prefs.setString("address", address.value);

      print("LOCATION SAVED:");
      print("LAT: ${latitude.value}");
      print("LNG: ${longitude.value}");
      print("ADDRESS: ${address.value}");

      Get.offAllNamed("/home");
    } catch (e) {
      print("LOCATION ERROR: $e");
      Get.snackbar("Location Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
