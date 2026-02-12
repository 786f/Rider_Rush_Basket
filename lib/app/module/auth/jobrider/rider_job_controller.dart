import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riderrushbasketapp/app/module/auth/jobrider/rider_job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_endpoints.dart';
import '../network/dio_client.dart';

class RiderJobController extends GetxController {

  RxBool isLoading = false.obs;
  RxList<RiderJobModel> jobList = <RiderJobModel>[].obs;

  final String baseUrl =
      "https://api.rushbaskets.com/api/rider-job-post";

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    try {
      isLoading.value = true;

      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      String? token = prefs.getString("auth_token");

      if (token == null) {
        Get.snackbar("Error", "Token not found");
        return;
      }

      final Uri url =
      Uri.parse("$baseUrl?city=siwan");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List data = body['data'];
        print(body);

        jobList.value =
            data.map((e) => RiderJobModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to load jobs");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> applyForJob(String jobPostId) async {
    try {
      isLoading.value = true;

      final response = await DioClient.instance.post(
        ApiEndpoints.applyJob,
        data: {
          "jobPostId": jobPostId,
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Get.snackbar(
          "Success",
          response.data['message'] ??
              "Application submitted",
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
      );

      print("Unexpected Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


}
