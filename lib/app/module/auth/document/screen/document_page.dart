import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../workdetail/citypage/screen/successcompletedpage.dart';
import 'adharuploadpage.dart';
import 'bankdetailpage.dart';
import 'panuploadpage.dart';
import 'drivinglicense.dart';
import 'profileuploadpage.dart';
import 'document_upload_status.dart';


class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await UploadStatus.loadStatus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFFFF7EF),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Upload Documents",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFFF28C28),
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.help_outline, color: Colors.black),
            label: const Text(
              "Help",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Please submit the below documents for verification & upload originals to avoid rejection.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'PENDING',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  if (!UploadStatus.profileUploaded)
                    const DocumentTile(title: 'Profile Picture (Selfie)', icon: 'assets/png/person.png'),

                  if (!UploadStatus.aadhaarUploaded)
                    const DocumentTile(title: 'Aadhar Card', icon: 'assets/png/adhar.png'),

                  if (!UploadStatus.panUploaded)
                    const DocumentTile(title: 'PAN Card', icon: 'assets/png/pan.jpg'),

                  if (!UploadStatus.licenseUploaded)
                    const DocumentTile(title: 'Driving License', icon: 'assets/png/driving.jpg'),

                  if (!UploadStatus.bankUploaded)
                    const DocumentTile(title: 'Bank Details', icon: 'assets/png/bank.png'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'COMPLETED DOCUMENTS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            const DocumentCompletedList(),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => SuccessCompletedPage(message: "Documents Details Completed!"));
                  UploadStatus.documentDetailsCompleted = true;
                  UploadStatus.saveStatus();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Continue',
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

// ============================================================================
// PENDING TILE
// ============================================================================
class DocumentTile extends StatefulWidget {
  final String title;
  final String icon;

  const DocumentTile({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  State<DocumentTile> createState() => _DocumentTileState();
}

class _DocumentTileState extends State<DocumentTile> {
  XFile? selectedFile;
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF28C28).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),
            ),

            child: InkWell(
              onTap: () {
                if (widget.title == "Profile Picture (Selfie)") {
                  Get.to(() => const ProfileUploadPage(isEditing: false));
                } else if (widget.title == "Aadhar Card") {
                  Get.to(() => const AadhaarUploadPage(isEditing: false));
                } else if (widget.title == "PAN Card") {
                  Get.to(() => const PanUploadPage(isEditing: false));
                } else if (widget.title == "Driving License") {
                  Get.to(() => const DrivingLicenseUploadPage(isEditing: false));
                } else if (widget.title == "Bank Details") {
                  Get.to(() => const BankDetailPage(isEditing: false));
                }
              },

              child: ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(widget.icon),
                  ),
                ),
                title: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF28C28),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFF28C28)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// COMPLETED LIST
// ============================================================================
class DocumentCompletedList extends StatelessWidget {
  const DocumentCompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (UploadStatus.profileUploaded)
          const CompletedTile(title: "Profile Picture"),

        if (UploadStatus.aadhaarUploaded)
          const CompletedTile(title: "Aadhaar Card"),

        if (UploadStatus.panUploaded)
          const CompletedTile(title: "PAN Card"),

        if (UploadStatus.licenseUploaded)
          const CompletedTile(title: "Driving License"),

        if (UploadStatus.bankUploaded)
          const CompletedTile(title: "Bank Details"),
      ],
    );
  }
}

// ============================================================================
// COMPLETED TILE
// ============================================================================
class CompletedTile extends StatelessWidget {
  final String title;

  const CompletedTile({super.key, required this.title});

  Future<void> handleDelete(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 25,
                    offset: const Offset(0, 15),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // 🔥 Top Icon
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.15),
                    ),
                    child: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 40),
                  ),

                  const SizedBox(height: 18),

                  // 🔥 Title
                  const Text(
                    "Remove Document?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 🔥 Subtitle
                  const Text(
                    "Are you sure you want to delete this document?\nYou can re-upload anytime.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 🔥 Buttons Row
                  Row(
                    children: [
                      // ❌ Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFFF28C28)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Color(0xFFF28C28),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // 🧨 Delete Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF28C28),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (confirm != true) return;

    final prefs = await SharedPreferences.getInstance();

    if (title == "Profile Picture") {
      UploadStatus.profileUploaded = false;
      prefs.remove("profileImage");
    } else if (title == "Aadhaar Card") {
      UploadStatus.aadhaarUploaded = false;
      prefs.remove("aadhaarFront");
      prefs.remove("aadhaarBack");
    } else if (title == "PAN Card") {
      UploadStatus.panUploaded = false;
      prefs.remove("panImage");
    } else if (title == "Driving License") {
      UploadStatus.licenseUploaded = false;
      prefs.remove("licenseFront");
      prefs.remove("licenseBack");
    } else if (title == "Bank Details") {
      UploadStatus.bankUploaded = false;
      prefs.remove("bankName");
      prefs.remove("accountNumber");
      prefs.remove("ifscCode");
      prefs.remove("branchName");
    }

    await UploadStatus.saveStatus();
    Get.to(() => const DocumentsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                if (title == "Profile Picture") {
                  Get.to(() => const ProfileUploadPage(isEditing: true));
                } else if (title == "Aadhaar Card") {
                  Get.to(() => const AadhaarUploadPage(isEditing: true));
                } else if (title == "PAN Card") {
                  Get.to(() => const PanUploadPage(isEditing: true));
                } else if (title == "Driving License") {
                  Get.to(() => const DrivingLicenseUploadPage(isEditing: true));
                } else if (title == "Bank Details") {
                  Get.to(() => const BankDetailPage(isEditing: true));
                }
              },
              child: Icon(Icons.edit, color: Colors.orange),
            ),
            SizedBox(width: 12),
            InkWell(
              onTap: () => handleDelete(context),
              child: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
