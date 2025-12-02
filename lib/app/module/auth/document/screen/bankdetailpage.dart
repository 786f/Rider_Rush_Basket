import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

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

    String accountNumber = accountController.text.replaceAll(' ', '');

    await prefs.setString("bankName", bankNameController.text);
    await prefs.setString("accountNumber", accountNumber);
    await prefs.setString("ifscCode", ifscController.text.toUpperCase());
    await prefs.setString("branchName", branchController.text);

    UploadStatus.bankUploaded = true;
    await UploadStatus.saveStatus();

    Get.snackbar(
      "Success",
      "Bank details saved successfully!",
      backgroundColor: Colors.orange.withOpacity(0.2),
      colorText: Colors.black,
    );

    Navigator.pop(context, true); // 🔥 return true to refresh parent
  }


  void skipBankDetails() {
    Navigator.pop(context); // Simply go back to previous page
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
        actions: [
          TextButton(
            onPressed: skipBankDetails,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabeledInput(
              "Bank Name",
              bankNameController,
              hintText: "Enter your bank name",
            ),
            const SizedBox(height: 16),
            buildLabeledInput(
              "Account Number",
              accountController,
              keyboardType: TextInputType.number,
              hintText: "Enter your account number",
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                AccountNumberFormatter(),
              ],
            ),
            const SizedBox(height: 16),
            buildLabeledInput(
              "IFSC Code",
              ifscController,
              textCapitalization: TextCapitalization.characters,
              hintText: "Enter IFSC code (e.g., ABCD0123456)",
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(11),
                UpperCaseTextFormatter(),
              ],
            ),
            const SizedBox(height: 16),
            buildLabeledInput(
              "Branch Name",
              branchController,
              hintText: "Enter branch name",
            ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabeledInput(
      String label,
      TextEditingController controller, {
        TextInputType keyboardType = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
        TextCapitalization textCapitalization = TextCapitalization.none,
        String? hintText,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
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
        ),
      ],
    );
  }
}

// Forces IFSC code to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

// Formats account number with spaces every 4 digits
class AccountNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digitsOnly = newValue.text.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i != 0 && i % 4 == 0) formatted += ' ';
      formatted += digitsOnly[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
