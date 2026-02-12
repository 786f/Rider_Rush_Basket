import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../paymentoption/proceed_to_pay_screen.dart';
import 'current_order_model.dart';

class CurrentOrderController extends GetxController {
  var isLoading = true.obs;
  var orderData = Rxn<OrderData>();
  var selectedImage = Rxn<File>();

  final String apiUrl = "https://api.rushbaskets.com/api/rider/orders/current";

  final String token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5OGIwMTFkMWI0OWU4OGE5MmI3ZWYxOSIsInJvbGUiOiJyaWRlciIsImlhdCI6MTc3MDcxODAwNiwiZXhwIjoxNzcxMzIyODA2fQ.RQEEziapQBnVtT3LS-3m5slXm1f254YmrurhZJvgaSw";

  @override
  void onInit() {
    fetchCurrentOrder();
    super.onInit();
  }

  Future<void> fetchCurrentOrder() async {
    try {
      isLoading(true);
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      final jsonData = json.decode(response.body);
      print("LALU $jsonData");
      final parsed = CurrentOrderResponse.fromJson(jsonData);
      if (parsed.hasCurrentOrder) {
        orderData.value = parsed.data;
      } else {
        orderData.value = null;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load order");
    } finally {
      isLoading(false);
    }
  }



  Future<void> uploadDeliveryImage(String orderId) async {
    print(orderId);
    try {
      isLoading(true);

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://api.rushbaskets.com/api/rider/orders/$orderId/upload-delivery-image"),
      );

      request.headers['Authorization'] = "Bearer $token";

      request.files.add(
        await http.MultipartFile.fromPath(
          "deliveryImage",
          selectedImage.value!.path,
        ),
      );

      var response = await request.send();

      print(response);
      var responseData = await response.stream.bytesToString();
      print(responseData);
      var data = jsonDecode(responseData);

      print("Current Order Pickup $data");

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          "Success",
          "Image uploaded successfully",
          backgroundColor: const Color(0xff4CAF50),
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Upload failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> uploadDeliveredImage(String orderId) async {
    try {
      isLoading(true);

      var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://api.rushbaskets.com/api/rider/orders/$orderId/delivered-image"),
      );

      request.headers['Authorization'] = "Bearer $token";

      request.files.add(
        await http.MultipartFile.fromPath(
          "deliveryImage",
          selectedImage.value!.path,
        ),
      );

      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      var data = jsonDecode(responseData);

      if (response.statusCode == 200 && data['success'] == true) {

        Get.snackbar(
          "Success",
          "Image uploaded successfully",
          backgroundColor: const Color(0xff4CAF50),
          colorText: Colors.white,
        );

        final currentOrder = orderData.value;

        if (currentOrder != null &&
            currentOrder.paymentMethod.toLowerCase() == "cod") {

          Get.back();

          Get.to(() => ProceedToPayScreen(
            amount: currentOrder.total,
            orderId: currentOrder.id,
          ));

        } else {
          Get.back();
        }

      } else {
        Get.snackbar(
          "Error",
          data['message'] ?? "Upload failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Upload failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }


// Future<void> uploadDeliveredImage(String orderId) async {
  //   try {
  //     isLoading(true);
  //
  //     var request = http.MultipartRequest(
  //       "POST",
  //       Uri.parse(
  //           "https://api.rushbaskets.com/api/rider/orders/$orderId/delivered-image"),
  //     );
  //
  //     request.headers['Authorization'] = "Bearer $token";
  //
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         "deliveryImage",
  //         selectedImage.value!.path,
  //       ),
  //     );
  //
  //     var response = await request.send();
  //     print(response);
  //
  //     var responseData = await response.stream.bytesToString();
  //     print(responseData);
  //
  //     var data = jsonDecode(responseData);
  //     print(data);
  //
  //     if (response.statusCode == 200 && data['success'] == true) {
  //       Get.snackbar(
  //         "Success",
  //         "Image uploaded successfully",
  //         backgroundColor: const Color(0xff4CAF50),
  //         colorText: Colors.white,
  //       );
  //       Get.back();
  //     } else {
  //       Get.snackbar(
  //         "Error",
  //         data['message'] ?? "Upload failed",
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Error",
  //       "Upload failed",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}
