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

class _ProfileUploadPageState extends State<ProfileUploadPage>
    with SingleTickerProviderStateMixin {
  XFile? pickedImage;
  final ImagePicker picker = ImagePicker();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    UploadStatus.loadStatus().then((_) {
      loadSavedProfile();
      setState(() {});
    });

    // Animation controller for pulsing circle
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? profileImagePath;

  /// Load already saved selfie from local storage
  void loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedImg = prefs.getString("profileImage");
    profileImagePath = savedImg;
    if (savedImg != null) {
      setState(() {
        pickedImage = XFile(savedImg);
      });
    }
  }

  /// Pick image using camera only
  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      setState(() {
        pickedImage = file;
      });
    }
  }

  /// Save profile image locally
  Future<void> saveProfile() async {
    if (pickedImage == null) {
      Get.snackbar("Error", "Please take a selfie before saving",
          backgroundColor: Colors.red.shade100);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("profileImage", pickedImage!.path);

    UploadStatus.profileUploaded = true;
    await UploadStatus.saveStatus();
    Get.offNamed(AppRoutes.documents);

    Get.snackbar(
      "Success",
      "Profile Picture saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );
  }

  /// Modern Preview Dialog
  void showPreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Preview Selfie",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(pickedImage!.path),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await pickImage(); // Retake selfie
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "Retake",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF28C28), Color(0xFFFFB347)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          "OK",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build profile selfie widget
  Widget _buildProfileAvatar() {
    if (pickedImage != null) {
      return ClipOval(
        child: Image.file(
          File(pickedImage!.path),
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      );
    } else {
      // Pulsating placeholder
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          double scale = 1 + (_controller.value * 0.1);
          return Container(
            width: 150 * scale,
            height: 150 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.orange, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 10 * _controller.value,
                  spreadRadius: 2 * _controller.value,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.camera_alt, size: 50, color: Color(0xFFF28C28)),
                SizedBox(height: 10),
                Text("Tap to Take Selfie"),
              ],
            ),
          );
        },
      );
    }
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
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
            const SizedBox(height: 80),

            // Tap to pick image
            InkWell(
              onTap: pickImage,
              child: _buildProfileAvatar(),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
