import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riderrushbasketapp/app/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'document_upload_status.dart';

class DrivingLicenseUploadPage extends StatefulWidget {
  final bool isEditing;

  const DrivingLicenseUploadPage({super.key,  this.isEditing= false});

  @override
  State<DrivingLicenseUploadPage> createState() => _DrivingLicenseUploadPageState();
}

class _DrivingLicenseUploadPageState extends State<DrivingLicenseUploadPage> {
  XFile? frontImage;
  XFile? backImage;

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadSavedLicense();
  }

  Future<void> loadSavedLicense() async {
    final prefs = await SharedPreferences.getInstance();

    String? savedFront = prefs.getString('licenseFront');
    String? savedBack = prefs.getString('licenseBack');

    if (savedFront != null) {
      frontImage = XFile(savedFront);
    }
    if (savedBack != null) {
      backImage = XFile(savedBack);
    }

    setState(() {});
  }

  Future<void> pickFrontImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => frontImage = file);
    }
  }

  Future<void> pickBackImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => backImage = file);
    }
  }

  Future<void> saveLicense() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('licenseFront', frontImage!.path);
    await prefs.setString('licenseBack', backImage!.path);

    UploadStatus.licenseUploaded = true;
    await UploadStatus.saveStatus();
    Get.offNamed(AppRoutes.documents);

    Get.snackbar(
      "Success",
      "Driving License saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );


    // Navigator.pop(context);
  }

  Future<void> saveDrivingLicense(XFile front, XFile back, String licenseNumber) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("licenseFront", front.path);
    await prefs.setString("licenseBack", back.path);
    await prefs.setString("licenseNumber", licenseNumber);

    UploadStatus.licenseUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Driving License saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7EF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Upload Driving License",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Upload Front & Back Side of Driving License",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // FRONT IMAGE PICKER
            Text("Front Side", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            InkWell(
              onTap: pickFrontImage,
              child: Container(
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: frontImage == null
                    ? Center(child: Icon(Icons.camera_alt, size: 40))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(frontImage!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            SizedBox(height: 25),

            // BACK IMAGE PICKER
            Text("Back Side", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),

            InkWell(
              onTap: pickBackImage,
              child: Container(
                height: 170,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: backImage == null
                    ? Center(child: Icon(Icons.camera_alt, size: 40))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(backImage!.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Confirm button visible only when both images uploaded
            if (frontImage != null && backImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveLicense,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Confirm & Upload",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
