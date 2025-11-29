import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../routes/app_routes.dart';
import 'document_upload_status.dart';

class PanUploadPage extends StatefulWidget {
  final bool isEditing;

  const PanUploadPage({super.key, this.isEditing = false});

  @override
  State<PanUploadPage> createState() => _PanUploadPageState();
}

class _PanUploadPageState extends State<PanUploadPage> {
  final TextEditingController panController = TextEditingController();
  XFile? pickedImage;

  final ImagePicker picker = ImagePicker();

  bool isValidPan = false;

  @override
  void initState() {
    super.initState();
    loadSavedPan();

    // PAN Number Validation
    panController.addListener(() {
      setState(() {
        isValidPan = panController.text.length == 10;
      });
    });
  }

  /// Load previously saved PAN details (for Editing)
  Future<void> loadSavedPan() async {
    final prefs = await SharedPreferences.getInstance();

    panController.text = prefs.getString('panNumber') ?? "";

    String? savedImage = prefs.getString('panImage');
    if (savedImage != null) {
      setState(() {
        pickedImage = XFile(savedImage);
      });
    }
  }

  Future<void> pickPanImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() => pickedImage = file);
    }
  }

  @override
  void dispose() {
    panController.dispose();
    super.dispose();
  }


  Future<void> savePanCard(XFile panImage, String panNumber) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("panImage", panImage.path);
    await prefs.setString("panNumber", panNumber);

    UploadStatus.panUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "PAN Card saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );


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
          "Fill PAN Card Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Logo
            Center(
              child: Image.asset("assets/png/pan.jpg", height: 90),
            ),

            const SizedBox(height: 20),

            Text(
              "Fill PAN Card Details",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Row(
              children: const [
                Icon(Icons.verified, color: Colors.green, size: 20),
                SizedBox(width: 6),
                Text(
                  "Instant verification of your PAN number",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Input PAN Number
            TextField(
              controller: panController,
              keyboardType: TextInputType.text,
              maxLength: 10,
              decoration: InputDecoration(
                hintText: "PAN Card Number",
                counterText: "",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

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

            const SizedBox(height: 20),

            /// TAKE PHOTO
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("Take photo of your PAN Card",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          "It will take 1–2 days to verify",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.camera_alt, size: 32),
                    onPressed: pickPanImage,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Preview & Buttons
            if (pickedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(pickedImage!.path),
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// RETAKE
                  ElevatedButton(
                    onPressed: pickPanImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade100,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Retake"),
                  ),

                  /// CONFIRM
                  ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      // Save status
                      UploadStatus.panUploaded = true;

                      await prefs.setString('panNumber', panController.text);
                      await prefs.setString('panImage', pickedImage!.path);

                      await UploadStatus.saveStatus();

                      // 🔥 instantly refresh document page
                      Get.offNamed(AppRoutes.documents);

                      Get.snackbar(
                        "Success",
                        "PAN Card saved successfully!",
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        colorText: Colors.black,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF28C28),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Confirm & Upload"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
