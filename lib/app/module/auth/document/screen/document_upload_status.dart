

library document_upload_status;
import 'package:shared_preferences/shared_preferences.dart';

bool isAadhaarUploaded = false;
bool isPanUploaded = false;

String? aadhaarImagePath;
String? panImagePath;
class UploadStatus {
  static bool aadhaarUploaded = false;
  static bool panUploaded = false;
  static bool profileUploaded = false;
  static bool licenseUploaded = false;
  static bool bankUploaded = false;
  static bool workDetailsCompleted = false;
  static bool documentDetailsCompleted = false;


  static Future<void> loadStatus() async {
    final prefs = await SharedPreferences.getInstance();

    aadhaarUploaded = prefs.getBool('aadhaarUploaded') ?? false;
    panUploaded = prefs.getBool('panUploaded') ?? false;
    profileUploaded = prefs.getBool('profileUploaded') ?? false;
    licenseUploaded = prefs.getBool('licenseUploaded') ?? false;
    bankUploaded = prefs.getBool('bankUploaded') ?? false;

  }

  static Future<void> saveStatus() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setBool('aadhaarUploaded', aadhaarUploaded);
    prefs.setBool('panUploaded', panUploaded);
    prefs.setBool('profileUploaded', profileUploaded);
    prefs.setBool('licenseUploaded', licenseUploaded);

    await prefs.setBool('bankUploaded', bankUploaded);
  }
}


class AadhaarData {
  static String aadhaarNumber = "";
  static String aadhaarImagePath = "";
}



