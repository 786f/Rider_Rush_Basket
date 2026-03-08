// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../../routes/app_routes.dart';
//
// class DocumentsController extends GetxController {
//   var isUploading = false.obs;
//
//   Future<void> uploadDocuments() async {
//     try {
//       isUploading(true);
//
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("auth_token");
//
//       final profilePath = prefs.getString("profile");
//       final aadhaarPath = prefs.getString("aadhaarCardPhoto");
//       final panFrontPath = prefs.getString("panCardFront");
//       final panBackPath = prefs.getString("panCardBack");
//       final licenseFrontPath = prefs.getString("drivingLicenseFront");
//       final licenseBackPath = prefs.getString("drivingLicenseBack");
//       final chequePath = prefs.getString("cancelCheque");
//
//       var request = http.MultipartRequest(
//         "PUT",
//         Uri.parse("https://api.rushbaskets.com/api/rider/profile"),
//       );
//
//       request.headers["Authorization"] = "Bearer $token";
//
//       request.fields["aadhaarId"] = "123456789012";
//       request.fields["accountNumber"] = "123456789012";
//       request.fields["ifsc"] = "SBIN0000456";
//       request.fields["bankName"] = "State Bank of India";
//       request.fields["branchName"] = "MP Nagar";
//       request.fields["accountHolderName"] = "Rahul Kumar";
//
//       if (profilePath != null) {
//         request.files.add(await http.MultipartFile.fromPath("profile", profilePath));
//       }
//
//       if (aadhaarPath != null) {
//         request.files.add(await http.MultipartFile.fromPath("aadhaarCardPhoto", aadhaarPath));
//       }
//
//       if (panFrontPath != null) {
//         request.files.add(await http.MultipartFile.fromPath("panCardFront", panFrontPath));
//       }
//
//       if (panBackPath != null) {
//         request.files.add(await http.MultipartFile.fromPath("panCardBack", panBackPath));
//       }
//
//       if (licenseFrontPath != null) {
//         request.files.add(await http.MultipartFile.fromPath("drivingLicenseFront", licenseFrontPath));
//       }
//
//       if (licenseBackPath != null) {
//         request.files.add(await http.MultipartFile.fromPath("drivingLicenseBack", licenseBackPath));
//       }
//
//       if (chequePath != null) {
//         request.files.add(await http.MultipartFile.fromPath("cancelCheque", chequePath));
//       }
//
//       final response = await request.send();
//       final body = await response.stream.bytesToString();
//       final decoded = jsonDecode(body);
//
//       print("  DOCUMENT UPLOAD RESPONSE: $decoded");
//
//       if (response.statusCode == 200 && decoded["success"] == true) {
//         Get.snackbar("Success", "Documents uploaded successfully");
//         Get.toNamed(AppRoutes.workDetails);
//       } else {
//         Get.snackbar("Failed", decoded["message"] ?? "Upload failed");
//       }
//
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isUploading(false);
//     }
//   }
// }



import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';

class DocumentsController extends GetxController {

  var isUploading = false.obs;

  Future<void> uploadDocuments() async {

    try {

      isUploading(true);

      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");

      /// FILE PATHS
      final profile = prefs.getString("profileImage");
      final aadhaar = prefs.getString("aadhaarFront");
      final panFront = prefs.getString("panFront");
      final panBack = prefs.getString("panBack");
      final licenseFront = prefs.getString("licenseFront");
      final licenseBack = prefs.getString("licenseBack");

      /// BANK DETAILS
      final accountNumber = prefs.getString("accountNumber");
      final ifsc = prefs.getString("ifscCode");
      final bankName = prefs.getString("bankName");
      final branchName = prefs.getString("branchName");

      final aadhaarNumber = prefs.getString("aadhaarNumber");

      print("========= DOCUMENT DEBUG =========");

      print("PROFILE : $profile");
      print("AADHAAR : $aadhaar");
      print("PAN FRONT : $panFront");
      print("PAN BACK : $panBack");
      print("LICENSE FRONT : $licenseFront");
      print("LICENSE BACK : $licenseBack");

      print("BANK NAME : $bankName");
      print("ACCOUNT NUMBER : $accountNumber");
      print("IFSC : $ifsc");
      print("BRANCH : $branchName");

      print("===================================");

      var request = http.MultipartRequest(
        "PUT",
        Uri.parse("https://api.rushbaskets.com/api/rider/profile"),
      );

      request.headers["Authorization"] = "Bearer $token";

      /// TEXT FIELDS
      request.fields["aadharId"] = aadhaarNumber ?? "";
      request.fields["accountNumber"] = accountNumber ?? "";
      request.fields["ifsc"] = ifsc ?? "";
      request.fields["bankName"] = bankName ?? "";
      request.fields["branchName"] = branchName ?? "";
      request.fields["accountHolderName"] = "Rider";

      /// PROFILE IMAGE
      if (profile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "profile",
            profile,
          ),
        );
      }

      /// AADHAAR PHOTO
      if (aadhaar != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "aadharCardPhoto",
            aadhaar,
          ),
        );
      }

      /// PAN FRONT
      if (panFront != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "panCardFront",
            panFront,
          ),
        );
      }

      /// PAN BACK
      if (panBack != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "panCardBack",
            panBack,
          ),
        );
      }

      /// LICENSE FRONT
      if (licenseFront != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "drivingLicenseFront",
            licenseFront,
          ),
        );
      }

      /// LICENSE BACK
      if (licenseBack != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "drivingLicenseBack",
            licenseBack,
          ),
        );
      }

      final response = await request.send();

      final body = await response.stream.bytesToString();

      final decoded = jsonDecode(body);

      print("DOCUMENT RESPONSE : $decoded");

      if (response.statusCode == 200 && decoded["success"] == true) {

        Get.snackbar("Success", "Documents uploaded successfully");

        Get.toNamed(AppRoutes.workDetails);

      } else {

        Get.snackbar(
          "Failed",
          decoded["error"] ?? "Upload failed",
        );

      }

    } catch (e) {

      print("UPLOAD ERROR : $e");

      Get.snackbar("Error", e.toString());

    } finally {

      isUploading(false);

    }

  }

}