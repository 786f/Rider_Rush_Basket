import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: "https://api.rushbaskets.com/api",
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            // 🔐 Attach token automatically
            SharedPreferences prefs =
            await SharedPreferences.getInstance();
            String? token = prefs.getString("auth_token");

            if (token != null) {
              options.headers["Authorization"] =
              // "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NmZhNjNkZTU1YzFmY2IyYTA1NzY1YiIsInJvbGUiOiJyaWRlciIsImlhdCI6MTc3MDQ1MDgwMSwiZXhwIjoxNzcxMDU1NjAxfQ.FUTHJr4dxnjnjdfbH5oNIZ9H04bfw2NvZiD6I2EqgqU";
              "Bearer $token";
            }

            print("➡️ ${options.method} ${options.path}");
            print("Headers: ${options.headers}");
            print("Body: ${options.data}");

            return handler.next(options);
          },
          onResponse: (response, handler) {
            print("✅ Response: ${response.statusCode}");
            print("Data: ${response.data}");
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print("❌ Error: ${e.message}");

            Get.snackbar(
              "Error",
              e.response?.data['message'] ??
                  "Server error",
            );

            return handler.next(e);
          },
        ),
      );
    }

    return _dio!;
  }
}
