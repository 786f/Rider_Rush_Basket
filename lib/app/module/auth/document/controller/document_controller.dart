import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DocumentsController extends GetxController {
  Rx<File?> aadhaarFront = Rx<File?>(null);
  Rx<File?> aadhaarBack = Rx<File?>(null);
  Rx<File?> panCard = Rx<File?>(null);
  Rx<File?> selfie = Rx<File?>(null);

  RxBool uploading = false.obs;

  final ImagePicker _picker = ImagePicker();

  // -------------------------- PICK GALLERY DOCUMENT --------------------------
  Future<void> pickImageFor(String key) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked == null) return;

    final file = File(picked.path);

    switch (key) {
      case 'aadhaar_front':
        aadhaarFront.value = file;
        break;
      case 'aadhaar_back':
        aadhaarBack.value = file;
        break;
      case 'pan':
        panCard.value = file;
        break;
    }
  }

  // -------------------------- CAMERA SELFIE --------------------------
  Future<void> captureSelfie() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked == null) return;

    selfie.value = File(picked.path);
  }

  // -------------------------- UPLOAD ALL FILES (DUMMY API) --------------------------
  Future<void> uploadAll(Map<String, String> fields) async {
    try {
      uploading.value = true;

      final files = <String, File>{};
      if (aadhaarFront.value != null) files['aadhaar_front'] = aadhaarFront.value!;
      if (aadhaarBack.value != null) files['aadhaar_back'] = aadhaarBack.value!;
      if (panCard.value != null) files['pan'] = panCard.value!;
      if (selfie.value != null) files['selfie'] = selfie.value!;

      // 🔥 Dummy API
      print("---- UPLOAD START ----");
      print("Fields: $fields");
      print("Files: ${files.keys.toList()}");

      await Future.delayed(const Duration(seconds: 2));

      print("---- UPLOAD SUCCESS ----");

    } catch (e) {
      print("Upload Error : $e");
      rethrow;
    } finally {
      uploading.value = false;
    }
  }
}
