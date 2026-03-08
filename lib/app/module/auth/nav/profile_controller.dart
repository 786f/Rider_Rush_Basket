import 'dart:ui';

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

  Future<void> withdrawAmount({
    required double amount,
    required String description,
  }) async {
    try {
      isLoading.value = true;

      final response = await DioClient.instance.post(
        "/rider/wallet/earning/send",
        data: {
          "amount": amount.toInt(),
          "description": description,
        },
      );

      Get.back();

      print("withdraw amount $response");

      Get.snackbar(
        "Success",
        "Withdrawal request sent successfully",
        backgroundColor: const Color(0xffF57C00),
        colorText: const Color(0xffffffff),
      );

      fetchProfile();

    }

    on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data['message'] ?? "Withdrawal failed",
      );
    }

    finally {
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
