import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';
import 'document_upload_status.dart';

class AadhaarUploadPage extends StatefulWidget {
  final bool isEditing;

  const AadhaarUploadPage({super.key, this.isEditing = false});

  @override
  State<AadhaarUploadPage> createState() => _AadhaarUploadPageState();
}

class _AadhaarUploadPageState extends State<AadhaarUploadPage> {
  final TextEditingController aadhaarController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? frontImage;
  XFile? backImage;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      loadExistingAadhaar();
    }
  }

  /// Load saved data
  void loadExistingAadhaar() async {
    final prefs = await SharedPreferences.getInstance();

    aadhaarController.text = prefs.getString("aadhaarNumber") ?? "";

    String? savedFront = prefs.getString("aadhaarFront");
    String? savedBack = prefs.getString("aadhaarBack");

    if (savedFront != null) frontImage = XFile(savedFront);
    if (savedBack != null) backImage = XFile(savedBack);
    setState(() {});
  }

  /// Show bottom sheet camera / gallery
  void showImagePicker(Function(XFile?) onImagePicked) {
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // CAMERA
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        final picked =
                        await picker.pickImage(source: ImageSource.camera);
                        onImagePicked(picked);
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.camera_alt, size: 45, color: Colors.orange),
                          SizedBox(height: 8),
                          Text("Camera"),
                        ],
                      ),
                    ),

                    // GALLERY
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        final picked =
                        await picker.pickImage(source: ImageSource.gallery);
                        onImagePicked(picked);
                      },
                      child: Column(
                        children: const [
                          Icon(Icons.photo_library,
                              size: 45, color: Colors.orange),
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

  /// FRONT image selection
  void pickFrontImage() {
    showImagePicker((picked) {
      if (picked != null) {
        setState(() => frontImage = picked);
      }
    });
  }

  /// BACK image selection
  void pickBackImage() {
    showImagePicker((picked) {
      if (picked != null) {
        setState(() => backImage = picked);
      }
    });
  }

  /// Save all Aadhaar details locally
  Future<void> saveAadhaarDetails() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("aadhaarFront", frontImage!.path);
    await prefs.setString("aadhaarBack", backImage!.path);
    await prefs.setString("aadhaarNumber", aadhaarController.text);

    UploadStatus.aadhaarUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Aadhaar details saved!",
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
          "Fill Aadhaar Card Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/png/adhar.png",
                height: 80,
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Fill Aadhaar Card Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.verified, color: Colors.green, size: 20),
                SizedBox(width: 4),
                Text(
                  "Instant verification of your Aadhaar number",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
            const SizedBox(height: 20),

            /// Aadhaar Number Input
            TextField(
              controller: aadhaarController,
              keyboardType: TextInputType.number,
              maxLength: 12,
              decoration: InputDecoration(
                hintText: "Aadhaar Card Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Row(
              children: const [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("OR"),
                ),
                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 25),

            /// FRONT IMAGE
            const Text("Upload Aadhaar Front Side",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickFrontImage,
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

            /// BACK IMAGE
            const Text("Upload Aadhaar Back Side",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickBackImage,
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

            if (frontImage != null && backImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveAadhaarDetails,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
