import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';
import 'document_upload_status.dart';

class DrivingLicenseUploadPage extends StatefulWidget {
  final bool isEditing;

  const DrivingLicenseUploadPage({super.key, this.isEditing = false});

  @override
  State<DrivingLicenseUploadPage> createState() =>
      _DrivingLicenseUploadPageState();
}

class _DrivingLicenseUploadPageState extends State<DrivingLicenseUploadPage> {
  final TextEditingController licenseController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? frontImage;
  XFile? backImage;

  bool isValidDLNumber = false;
  bool _isFormatting = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) loadExistingLicense();

    licenseController.addListener(() {
      if (!_isFormatting) formatDLNumber();
      setState(() {
        isValidDLNumber = isValidDL(licenseController.text.trim());
      });
    });
  }

  /// Load saved details
  void loadExistingLicense() async {
    final prefs = await SharedPreferences.getInstance();
    licenseController.text = prefs.getString("licenseNumber") ?? "";

    String? savedFront = prefs.getString("licenseFront");
    String? savedBack = prefs.getString("licenseBack");

    if (savedFront != null) frontImage = XFile(savedFront);
    if (savedBack != null) backImage = XFile(savedBack);

    setState(() {});
  }

  /// Correct Indian DL validation regex
  bool isValidDL(String dl) {
    final dlRegex = RegExp(r'^[A-Z]{2}-\d{2}-\d{7,12}$');
    return dlRegex.hasMatch(dl.toUpperCase());
  }

  /// Auto-format: AA-12-1234567
  void formatDLNumber() {
    _isFormatting = true;

    String text = licenseController.text.toUpperCase().replaceAll('-', '');

    String newText = "";

    if (text.length >= 2) {
      newText = text.substring(0, 2); // State code

      if (text.length >= 4) {
        newText += "-${text.substring(2, 4)}"; // RTO code

        if (text.length > 4) {
          newText += "-${text.substring(4)}"; // License number
        }
      } else if (text.length > 2) {
        newText += "-${text.substring(2)}";
      }
    } else {
      newText = text;
    }

    licenseController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    isValidDLNumber = isValidDL(newText);

    _isFormatting = false;
  }

  /// Bottom sheet image picker
  void showImagePicker(Function(XFile?) onPicked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: 160,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const Text("Select Image Source",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        final img = await picker.pickImage(source: ImageSource.camera);
                        onPicked(img);
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.camera_alt, size: 45, color: Colors.orange),
                          SizedBox(height: 8),
                          Text("Camera"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        final img = await picker.pickImage(source: ImageSource.gallery);
                        onPicked(img);
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.photo_library, size: 45, color: Colors.orange),
                          SizedBox(height: 8),
                          Text("Gallery"),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void pickFront() {
    showImagePicker((img) {
      if (img != null) setState(() => frontImage = img);
    });
  }

  void pickBack() {
    showImagePicker((img) {
      if (img != null) setState(() => backImage = img);
    });
  }

  Future<void> saveLicense() async {
    if (frontImage == null || backImage == null || !isValidDLNumber) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("licenseFront", frontImage!.path);
    await prefs.setString("licenseBack", backImage!.path);
    await prefs.setString("licenseNumber", licenseController.text.trim());

    UploadStatus.licenseUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Driving License saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );

    Get.offNamed(AppRoutes.documents);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFF7EF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Fill Driving License Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage("assets/png/driving.jpg"),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Driving License Number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.verified, color: Colors.green, size: 20),
                SizedBox(width: 4),
                Text(
                  "Instant verification of your Driving License\nnumber",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// License TextField
            TextField(
              controller: licenseController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: InputDecoration(
                hintText: "Enter DL number (UP-14-1234567890)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("OR"),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),
            const SizedBox(height: 25),

            /// Front Image
            const Text("Upload License Front Side",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickFront,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: frontImage == null
                    ? const Center(child: Icon(Icons.camera_alt, size: 45))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(frontImage!.path),
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// Back Image
            const Text("Upload License Back Side",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: pickBack,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: backImage == null
                    ? const Center(child: Icon(Icons.camera_alt, size: 45))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(backImage!.path),
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Confirm Button
            if (frontImage != null && backImage != null && isValidDLNumber)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveLicense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Confirm & Upload",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
