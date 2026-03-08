import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:riderrushbasketapp/app/module/auth/paymentoption/payment_webview_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarkPaymentController extends GetxController {
  var isLoading = false.obs;

  Future<void> markCashPayment({
    required String orderId,

  }) async {
    try {
      SharedPreferences prefs =
      await SharedPreferences.getInstance();

      String? token = prefs.getString("auth_token");
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

        Get.back();
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


  Future<void> createOnlinePayment(  {required String orderId}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      final paymentResponse = await http.post(
        Uri.parse("https://api.rushbaskets.com/api/payment/create-payment-link"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "amount": "50",
          "name": "Customer Name",
          "email": "customer@email.com",
          "contact": "9334917021",
          "description": "RushBaskets Order Payment",
          "callbackUrl": "https://grocery.rushbaskets.com/payment-success"
        }),
      );

      final paymentDecoded = jsonDecode(paymentResponse.body);

      print("Final Payment$paymentDecoded");

      if (paymentResponse.statusCode == 200 &&
          paymentDecoded['success'] == true) {

        final paymentUrl = paymentDecoded['payment_url'];

        if (paymentUrl != null) {
          Get.to(
                () => PaymentWebViewPage(
              paymentUrl: paymentUrl,
              orderId: orderId,
            ),
          );
        }
      } else {
        Get.snackbar(
            "Payment Error",
            paymentDecoded['message'] ?? "Failed");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }


}
