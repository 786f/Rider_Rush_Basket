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
  final ImagePicker picker = ImagePicker();

  XFile? frontImage;
  XFile? backImage;

  bool isValidPan = false;

  @override
  void initState() {
    super.initState();
    loadSavedPan();

    /// PAN VALIDATION + AUTO-UPPERCASE
    panController.addListener(() {
      String formatted = panController.text.toUpperCase();

      if (formatted != panController.text) {
        panController.value = panController.value.copyWith(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }

      setState(() {
        isValidPan = validatePan(formatted);
      });
    });
  }

  /// PAN FORMAT VALIDATION
  bool validatePan(String pan) {
    final RegExp pattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
    return pattern.hasMatch(pan);
  }

  /// LOAD SAVED DATA
  Future<void> loadSavedPan() async {
    final prefs = await SharedPreferences.getInstance();

    panController.text = prefs.getString('panNumber') ?? "";
    String? savedFront = prefs.getString('panFront');
    String? savedBack = prefs.getString('panBack');

    if (savedFront != null) frontImage = XFile(savedFront);
    if (savedBack != null) backImage = XFile(savedBack);

    setState(() {});
  }

  /// CAMERA OR GALLERY SELECTOR POPUP
  void showImagePicker(Function(XFile?) onPicked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 165,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                "Select Image Source",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      onPicked(
                        await picker.pickImage(source: ImageSource.camera),
                      );
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
                      onPicked(
                        await picker.pickImage(source: ImageSource.gallery),
                      );
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
        );
      },
    );
  }

  void pickFrontPhoto() {
    showImagePicker((file) {
      if (file != null) setState(() => frontImage = file);
    });
  }

  void pickBackPhoto() {
    showImagePicker((file) {
      if (file != null) setState(() => backImage = file);
    });
  }

  /// SAVE TO STORAGE
  Future<void> savePanCard() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("panNumber", panController.text);
    await prefs.setString("panFront", frontImage!.path);
    await prefs.setString("panBack", backImage!.path);

    UploadStatus.panUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "PAN Card details saved!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );

    Get.offNamed(AppRoutes.documents);
  }

  @override
  void dispose() {
    panController.dispose();
    super.dispose();
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

            Center(child: Image.asset("assets/png/pan.jpg", height: 90)),
            const SizedBox(height: 20),

            const Text(
              "Fill PAN Card Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.verified, color: Colors.green, size: 20),
                SizedBox(width: 4),
                Text(
                  "Instant verification of your PAN number",
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// PAN INPUT
            TextField(
              controller: panController,
              maxLength: 10,
              textCapitalization: TextCapitalization.characters, // 🔥 AUTO CAPITAL KEYBOARD
              decoration: InputDecoration(
                hintText: "Enter PAN Number",
                counterText: "",
                errorText: panController.text.isEmpty || isValidPan
                    ? null
                    : "Invalid PAN Format",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
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

            /// FRONT PHOTO
            const Text(
              "Upload PAN Card Front",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickFrontPhoto,
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
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// BACK PHOTO
            const Text(
              "Upload PAN Card Back",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pickBackPhoto,
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
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// UPLOAD BUTTON
            if (isValidPan && frontImage != null && backImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: savePanCard,
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
