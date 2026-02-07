// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// class AuthService {
//   static const String baseUrl = "http://46.202.164.93/api";
//
//   static Future<Map<String, dynamic>> sendOtp(String mobile) async {
//     final url = Uri.parse("$baseUrl/rider/login");
//
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "mobileNumber": mobile,
//       }),
//     );
//
//     return jsonDecode(response.body);
//   }
//
//   static Future<Map<String, dynamic>> verifyOtp({
//     required String mobile,
//     required String otp,
//   }) async {
//     final url = Uri.parse("$baseUrl/rider/verify-login-otp");
//
//     final response = await http.post(
//       url,
//       headers: {"Content-Type": "application/json"},
//       body: jsonEncode({
//         "mobileNumber": mobile,
//         "otp": otp,
//       }),
//     );
//
//     return jsonDecode(response.body);
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://46.202.164.93/api";

  static Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final url = Uri.parse("$baseUrl/rider/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "mobileNumber": mobile,
      }),
    );

    print("SEND OTP STATUS CODE: ${response.statusCode}");
    print("SEND OTP RESPONSE BODY: ${response.body}");

    if (response.body.isEmpty) {
      throw Exception("Empty response from server");
    }

    final decoded = jsonDecode(response.body);
    return decoded;
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final url = Uri.parse("$baseUrl/rider/verify-login-otp");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "mobileNumber": mobile,
          "otp": otp,
        }),
      );

      print("VERIFY OTP STATUS CODE: ${response.statusCode}");
      print("VERIFY OTP RAW RESPONSE: ${response.body}");

      if (response.body.isEmpty) {
        throw Exception("Empty response from server");
      }

      final decoded = jsonDecode(response.body);
      return decoded;
    } catch (e) {
      print("VERIFY OTP SERVICE ERROR: $e");
      rethrow;
    }
  }
}
