import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/dio_client.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxMap<String, dynamic> profile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response =
      await DioClient.instance.get("/rider/profile");

      print("PROFILE RESPONSE => ${response.data}");

      profile.value = response.data['data'];

    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data['message'] ?? "Failed to load profile",
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    try {
      await DioClient.instance.post("/rider/logout");

      SharedPreferences prefs =
      await SharedPreferences.getInstance();
      await prefs.clear();

      Get.offAllNamed("/login");

    } catch (e) {
      Get.snackbar("Error", "Logout failed");
    }
  }
}
