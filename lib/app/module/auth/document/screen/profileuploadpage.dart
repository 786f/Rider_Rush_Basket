import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riderrushbasketapp/app/module/auth/document/screen/document_upload_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';

class ProfileUploadPage extends StatefulWidget {
  final bool isEditing;

  const ProfileUploadPage({super.key, this.isEditing = false});

  @override
  State<ProfileUploadPage> createState() => _ProfileUploadPageState();
}

class _ProfileUploadPageState extends State<ProfileUploadPage> {
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    UploadStatus.loadStatus().then((_) {
      loadSavedProfile();
      setState(() {});
    });
  }

  String? profileImagePath;
  /// 🔹 Load already saved selfie from local storage
  void loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedImg = prefs.getString("profileImage");
    profileImagePath = prefs.getString("profileImage");
    if (savedImg != null) {
      setState(() {
        pickedImage = XFile(savedImg);
      });
    }
  }

  /// 🔹 Pick image using camera only
  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.camera);

    if (file != null) {
      setState(() {
        pickedImage = file;
      });
    }
  }

  /// 🔹 Save profile image locally
  Future<void> saveProfile() async {
    if (pickedImage == null) {
      Get.snackbar("Error", "Please take a selfie before saving",
          backgroundColor: Colors.red.shade100);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage", pickedImage!.path);

    /// ⭐ Mark as uploaded
    UploadStatus.profileUploaded = true;
    await UploadStatus.saveStatus();
    Get.offNamed(AppRoutes.documents);
    // Navigator.pop(context); // Return to previous page → triggers rebuild

    Get.snackbar(
      "Success",
      "Profile Picture saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );


  }



  /// 🔹 Preview dialog with Retake + OK
  void showPreviewDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: EdgeInsets.all(12),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(pickedImage!.path),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await pickImage(); // retake selfie
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade100,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Retake"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("OK"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void> saveProfilePicture(XFile image) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("profileImage", image.path);

    UploadStatus.profileUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Profile Picture saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7EF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Upload Profile Selfie",
          style: TextStyle(
            color: Color(0xFFF28C28),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      backgroundColor: const Color(0xFFFFF7EF),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Please upload a clear front-facing selfie",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 80),

            InkWell(
              onTap: () {
                if (pickedImage == null) {
                  pickImage();
                } else {
                  showPreviewDialog();
                }
              },
              child: pickedImage == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.camera_alt,
                      size: 50, color: Color(0xFFF28C28)),
                  SizedBox(height: 10),
                  Text("Tap to Take Selfie"),
                ],
              )
                  : ClipOval(
                child: Image.file(
                  File(pickedImage!.path),
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ),


            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}
