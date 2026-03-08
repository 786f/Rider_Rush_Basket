import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SupportController extends GetxController {


  final String baseUrl = "https://api.rushbaskets.com/api/";

  TextEditingController complaintController = TextEditingController();

  var selectedCategory = "general_queries".obs;

  var isLoading = false.obs;

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");
    return token;
  }

  Future createTicket() async {

    String complaint = complaintController.text.trim();

    if (complaint.length < 10) {
      Get.snackbar(
        "Error",
        "Complaint must be at least 10 characters",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {

      isLoading(true);

      String? token = await getToken();

      Map<String, dynamic> body = {
        "complaint": complaint,
        "category": selectedCategory.value
      };

      print("Request Body: $body");

      final response = await http.post(
        Uri.parse("${baseUrl}rider/tickets"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(body),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {

        Get.snackbar(
          "Success",
          "Ticket submitted successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );


        complaintController.clear();
        selectedCategory.value = "general_queries";

      } else {

        Get.snackbar(
          "Error",
          "Failed to submit ticket",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

      }

    } catch (e) {

      print("Error: $e");

      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

    }

    isLoading(false);
  }
}