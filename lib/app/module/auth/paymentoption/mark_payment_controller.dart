import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MarkPaymentController extends GetxController {
  var isLoading = false.obs;

  Future<void> markCashPayment({
    required String orderId,
    required String token,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(
          "https://api.rushbaskets.com/api/rider/order/$orderId/mark-payment-cash");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Payment Cash ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "Cash payment marked successfully",
          backgroundColor: const Color(0xffF57C00),
          colorText: const Color(0xffffffff),
        );

        Get.back(); // go back after success
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar(
          "Error",
          data["message"] ?? "Something went wrong",
          backgroundColor: const Color(0xffff0000),
          colorText: const Color(0xffffffff),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: const Color(0xffff0000),
        colorText: const Color(0xffffffff),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
