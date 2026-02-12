import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_routes.dart';

class PersonalInfoController extends GetxController {

  RxString name = "".obs;
  RxString fatherName = "".obs;
  RxString motherName = "".obs;
  RxString dob = "".obs;
  RxString age = "".obs;
  RxString mobile = "".obs;
  RxString whatsapp = "".obs;
  RxString bloodGroup = "".obs;
  RxString city = "".obs;
  RxString address = "".obs;
  RxString languages = "".obs;
  RxString emergencyName = "".obs;
  RxString emergencyNumber = "".obs;

  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  RxBool isFetchingLocation = false.obs;

  RxBool profileUploaded = false.obs;
  RxBool aadhaarUploaded = false.obs;
  RxBool panUploaded = false.obs;
  RxBool licenseUploaded = false.obs;
  RxBool bankUploaded = false.obs;

  Future<void> fetchCurrentCity() async {
    try {
      isFetchingLocation(true);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location", "Please enable location service");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission", "Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar("Permission", "Enable location permission from settings");
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city.value = place.locality ?? "";
      }

    } catch (e) {
      Get.snackbar("Error", "Unable to get location");
    } finally {
      isFetchingLocation(false);
    }
  }

  Future<void> createProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");


      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("https://api.rushbaskets.com/api/rider/profile"),
      );

      request.headers["Authorization"] = "Bearer $token";

      request.fields["fullName"] = name.value;
      request.fields["fathersName"] = fatherName.value;
      request.fields["mothersName"] = motherName.value;
      request.fields["dateOfBirth"] = "1999-08-15";
      request.fields["age"] = age.value;
      request.fields["mobileNumber"] = mobile.value;
      request.fields["whatsappNumber"] = whatsapp.value;
      request.fields["bloodGroup"] = bloodGroup.value;
      request.fields["city"] = city.value;

      request.fields["currentAddressLine1"] = address.value;
      request.fields["currentAddressLine2"] = "Near DB Mall";
      request.fields["pinCode"] = "462011";

      request.fields["latitude"] = 23.2599.toString();
      // request.fields["latitude"] = latitude.value.toString();
      request.fields["longitude"] = 77.4126.toString();
      // request.fields["longitude"] = longitude.value.toString();

      request.fields["language"] = jsonEncode(languages.value.split(", "));

      request.fields["emergencyContactPersonName"] = emergencyName.value;
      request.fields["emergencyContactPersonRelation"] = "Brother";
      request.fields["emergencyContactPersonNumber"] = emergencyNumber.value;
      request.fields["emergencyContactNumber"] = emergencyNumber.value;



      final response = await request.send();
      final body = await response.stream.bytesToString();
      final decoded = jsonDecode(body);
      print("PROFILE RESPONSE STATUS: $decoded");

      if (response.statusCode == 200 && decoded["success"] == true) {
        Get.snackbar("Success", "Profile created successfully");
        // Get.toNamed("/success");
        Get.toNamed(AppRoutes.documents);
      } else {
        Get.snackbar("Failed", decoded["message"] ?? "Profile update failed");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

}
