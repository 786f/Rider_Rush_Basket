import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../login/controller/documents_controller.dart';
import '../../personal/personal_info_controller.dart';
import '../../workdetail/citypage/screen/successcompletedpage.dart';
import 'adharuploadpage.dart';
import 'bankdetailpage.dart';
import 'panuploadpage.dart';
import 'drivinglicense.dart';
import 'profileuploadpage.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final PersonalInfoController controller = Get.find<PersonalInfoController>();
  final DocumentsController docsController = Get.put(DocumentsController());

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
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF28C28), fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please submit the below documents for verification & upload originals to avoid rejection.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text('PENDING', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                return ListView(
                  children: [
                    if (!controller.profileUploaded.value)
                      const DocumentTile(title: 'Profile Picture (Selfie)', icon: 'assets/png/person.png'),
                    if (!controller.aadhaarUploaded.value)
                      const DocumentTile(title: 'Aadhar Card', icon: 'assets/png/adhar.png'),
                    if (!controller.panUploaded.value)
                      const DocumentTile(title: 'PAN Card', icon: 'assets/png/pan.jpg'),
                    if (!controller.licenseUploaded.value)
                      const DocumentTile(title: 'Driving License', icon: 'assets/png/driving.jpg'),
                    if (!controller.bankUploaded.value)
                      const DocumentTile(title: 'Bank Details', icon: 'assets/png/bank.png'),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('COMPLETED DOCUMENTS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 10),
            const DocumentCompletedList(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Obx(() {
                return ElevatedButton(
                  onPressed: docsController.isUploading.value
                      ? null
                      : () async {
                    await docsController.uploadDocuments();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: docsController.isUploading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentTile extends StatelessWidget {
  final String title;
  final String icon;

  const DocumentTile({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final PersonalInfoController controller = Get.find<PersonalInfoController>();

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
            ),
            child: InkWell(
              onTap: () {
                if (title == "Profile Picture (Selfie)") {
                  controller.profileUploaded.value = true;
                  Get.to(() => const ProfileUploadPage(isEditing: false));
                } else if (title == "Aadhar Card") {
                  controller.aadhaarUploaded.value = true;
                  Get.to(() => const AadhaarUploadPage(isEditing: false));
                } else if (title == "PAN Card") {
                  controller.panUploaded.value = true;
                  Get.to(() => const PanUploadPage(isEditing: false));
                } else if (title == "Driving License") {
                  controller.licenseUploaded.value = true;
                  Get.to(() => const DrivingLicenseUploadPage(isEditing: false));
                } else if (title == "Bank Details") {
                  controller.bankUploaded.value = true;
                  Get.to(() => const BankDetailPage(isEditing: false));
                }
              },
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.white, child: Image.asset(icon)),
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFF28C28))),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFF28C28)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentCompletedList extends StatelessWidget {
  const DocumentCompletedList({super.key});

  @override
  Widget build(BuildContext context) {
    final PersonalInfoController controller = Get.find<PersonalInfoController>();

    return Obx(() {
      return Column(
        children: [
          if (controller.profileUploaded.value) const CompletedTile(title: "Profile Picture"),
          if (controller.aadhaarUploaded.value) const CompletedTile(title: "Aadhaar Card"),
          if (controller.panUploaded.value) const CompletedTile(title: "PAN Card"),
          if (controller.licenseUploaded.value) const CompletedTile(title: "Driving License"),
          if (controller.bankUploaded.value) const CompletedTile(title: "Bank Details"),
        ],
      );
    });
  }
}

class CompletedTile extends StatelessWidget {
  final String title;

  const CompletedTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final PersonalInfoController controller = Get.find<PersonalInfoController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: const Icon(Icons.check_circle, color: Colors.green),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: InkWell(
          onTap: () {
            if (title == "Profile Picture") controller.profileUploaded.value = false;
            if (title == "Aadhaar Card") controller.aadhaarUploaded.value = false;
            if (title == "PAN Card") controller.panUploaded.value = false;
            if (title == "Driving License") controller.licenseUploaded.value = false;
            if (title == "Bank Details") controller.bankUploaded.value = false;
          },
          child: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    );
  }
}
