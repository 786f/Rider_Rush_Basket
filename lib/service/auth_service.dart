import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://46.202.164.93/api";

  /// SEND OTP
  static Future<Map<String, dynamic>> sendOtp(String mobile) async {
    final url = Uri.parse("$baseUrl/rider/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mobileNumber": mobile,
      }),
    );

    return jsonDecode(response.body);
  }

  /// VERIFY OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final url = Uri.parse("$baseUrl/rider/verify-login-otp");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mobileNumber": mobile,
        "otp": otp,
      }),
    );

    return jsonDecode(response.body);
  }
}
