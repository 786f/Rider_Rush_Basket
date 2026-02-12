import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class WorkDetailsController extends GetxController {
  RxString vehicleType = "".obs;
  RxString experience = "2 years".obs;
  RxString shift = "Day".obs;
  RxBool isSubmitting = false.obs;

  Future<void> submitWorkDetails() async {
    try {
      isSubmitting(true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("https://api.rushbaskets.com/api/rider/profile"),
      );

      request.headers["Authorization"] = "Bearer $token";

      Map<String, dynamic> workDetails = {
        "vehicleType": vehicleType.value,
        "experience": experience.value,
        "shift": shift.value,
      };

      request.fields["workDetails"] = jsonEncode(workDetails);

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final decoded = jsonDecode(body);

      print("WORK DETAILS RESPONSE: $decoded");

      if (response.statusCode == 200 && decoded["success"] == true) {
        Get.snackbar("Success", "Work details saved");
        Get.toNamed("/success");
      } else {
        Get.snackbar("Failed", decoded["message"] ?? "Work details failed");
      }

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting(false);
    }
  }
}
