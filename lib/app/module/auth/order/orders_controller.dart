import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../network/api_endpoints.dart';
import '../network/dio_client.dart';

class OrdersController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  RxString error = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeliveredOrders();
  }

  Future<void> fetchDeliveredOrders() async {
    try {
      isLoading.value = true;
      error.value = "";

      final response =
      await DioClient.instance.get(ApiEndpoints.deliveredOrders);

      debugPrint("✅ FULL API RESPONSE:");
      debugPrint(response.data.toString());

      debugPrint("✅ RESPONSE DATA FIELD:");
      debugPrint(response.data['data'].toString());

      if (response.data['data'] == null) {
        error.value = "No data key in response";
        return;
      }

      orders.value =
      List<Map<String, dynamic>>.from(response.data['data']);

      debugPrint("✅ ORDERS LENGTH: ${orders.length}");

    } on DioException catch (e) {
      debugPrint("❌ API ERROR:");
      debugPrint(e.response?.data.toString());

      error.value =
          e.response?.data['message'] ?? "Failed to load orders";
    } catch (e) {
      debugPrint("❌ UNKNOWN ERROR: $e");
      error.value = "Something went wrong";
    } finally {
      isLoading.value = false;
    }
  }

}
