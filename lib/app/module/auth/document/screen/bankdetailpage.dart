import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'document_upload_status.dart';


class BankDetailPage extends StatefulWidget {
  final bool isEditing;

  const BankDetailPage({super.key, required this.isEditing});

  @override
  State<BankDetailPage> createState() => _BankDetailPageState();
}

class _BankDetailPageState extends State<BankDetailPage> {
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController branchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadExistingData();
  }

  Future<void> loadExistingData() async {
    if (widget.isEditing) {
      final prefs = await SharedPreferences.getInstance();

      bankNameController.text = prefs.getString("bankName") ?? "";
      accountController.text = prefs.getString("accountNumber") ?? "";
      ifscController.text = prefs.getString("ifscCode") ?? "";
      branchController.text = prefs.getString("branchName") ?? "";
    }
  }

  Future<void> saveBankDetails() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("bankName", bankNameController.text);
    prefs.setString("accountNumber", accountController.text);
    prefs.setString("ifscCode", ifscController.text);
    prefs.setString("branchName", branchController.text);

    UploadStatus.bankUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Bank details saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );

    Navigator.pop(context); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7EF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.isEditing ? "Edit Bank Details" : "Add Bank Details",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFFF28C28)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildInput("Bank Name", bankNameController),
            const SizedBox(height: 16),
            buildInput("Account Number", accountController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            buildInput("IFSC Code", ifscController),
            const SizedBox(height: 16),
            buildInput("Branch Name", branchController),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveBankDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  widget.isEditing
                      ? "Update Bank Details"
                      : "Save Bank Details",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInput(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF28C28)),
        ),
      ),
    );
  }
}
