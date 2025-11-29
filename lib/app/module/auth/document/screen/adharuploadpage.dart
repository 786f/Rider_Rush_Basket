import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
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
  XFile? pickedImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickAadhaarImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        pickedImage = file;
      });
    }
  }

  bool isValidAadhaar = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      loadExistingAadhaar();
    }
  }

  void loadExistingAadhaar() async {
    final prefs = await SharedPreferences.getInstance();

    aadhaarController.text = prefs.getString("aadhaarNumber") ?? "";

    String? savedImg = prefs.getString("aadhaarImage");

    if (savedImg != null) {
      setState(() {
        pickedImage = XFile(savedImg);
      });
    }
  }


  @override
  void dispose() {
    aadhaarController.dispose();
    super.dispose();
  }


  void showOtpDialog() {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Verify OTP",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter the OTP sent to your Aadhaar linked mobile number"),

              SizedBox(height: 12),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                // TODO: Verify OTP API
                print("Entered OTP: ${otpController.text}");

                Navigator.pop(context);
              },
              child: const Text("Verify"),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveAadhaarDetails(XFile front, XFile back, String aadhaarNumber) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("aadhaarFront", front.path);
    await prefs.setString("aadhaarBack", back.path);
    await prefs.setString("aadhaarNumber", aadhaarNumber);

    UploadStatus.aadhaarUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Aadhaar Card saved successfully!",
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
        elevation: 0,
        backgroundColor: const Color(0xFFFFF7EF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Fill Aadhaar Card Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Aadhaar Logo
            Center(
              child: Image.asset(
                "assets/png/adhar.png",
                height: 80,
              ),
            ),
            SizedBox(height: 20),

            /// Heading
            Text(
              "Fill Aadhaar Card Details",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.verified, color: Colors.green, size: 20),
                SizedBox(width: 4),
                Text(
                  "Instant verification of your Aadhaar number",
                  style: TextStyle(color: Colors.green),
                )
              ],
            ),
            SizedBox(height: 20),

            /// Aadhaar Input Box
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
            SizedBox(height: 10),

            /// Get OTP Button
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: isValidAadhaar ? () {
            //       // SAVE AADHAAR NUMBER
            //       AadhaarData.aadhaarNumber = aadhaarController.text;
            //       print("Saved Aadhaar Number: ${AadhaarData.aadhaarNumber}");
            //
            //       // CALL YOUR OTP API HERE
            //       // await sendOtpApi();
            //
            //       // OPEN OTP POPUP
            //       showOtpDialog();
            //
            //     } : null,
            //
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor:
            //       isValidAadhaar ? const Color(0xFFF28C28) : Colors.grey.shade300,
            //       foregroundColor:
            //       isValidAadhaar ? Colors.white : Colors.black54,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //     ),
            //     child: const Text(
            //       "Get OTP",
            //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),


            SizedBox(height: 30),

            /// Divider
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("OR"),
                ),
                Expanded(child: Divider()),
              ],
            ),
            SizedBox(height: 20),

            /// TAKE PHOTO SECTION
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Take photo of your Aadhaar Card",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          "It will take 1-2 days to verify",
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.camera_alt, size: 30),
                    onPressed: pickAadhaarImage,
                  )
                ],
              ),
            ),

            SizedBox(height: 20),

            if (pickedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(pickedImage!.path),
                  height: 200,
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
                    onPressed: pickAadhaarImage,
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

                      UploadStatus.aadhaarUploaded = true;

                      await prefs.setString('aadhaarNumber', aadhaarController.text);
                      await prefs.setString('aadhaarImage', pickedImage!.path);

                      await UploadStatus.saveStatus();


                      Get.offNamed(AppRoutes.documents);


                      Get.snackbar(
                        "Success",
                        "Aadhaar Card saved successfully!",
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
