import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riderrushbasketapp/app/module/auth/personal/personal_info_controller.dart';
import '../../../routes/app_routes.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? profileImage;

  final PersonalInfoController infoController =
  Get.put(PersonalInfoController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController primaryMobileController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController languagesController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyNumberController = TextEditingController();

  final List<String> languagesList = [
    "Hindi",
    "English",
    "Kannada",
    "Tamil",
    "Telugu",
    "Malayalam",
    "Marathi",
    "Gujarati",
    "Bengali",
    "Punjabi",
    "Odia",
    "Urdu",
    "Assamese",
    "Konkani",
    "Manipuri",
    "Sanskrit",
  ];

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7EF),
        elevation: 0,
        title: const Text(
          "Personal Information",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: nameController, hint: "Enter your name (Same as PAN Card)", icon: Icons.person, required: true),

                  const SizedBox(height: 10),
                  const Text("Father's Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: fatherNameController, hint: "Enter father's name", icon: Icons.person_outline, required: true),

                  const SizedBox(height: 10),
                  const Text("Mother's Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: motherNameController, hint: "Enter mother's name", icon: Icons.person_outline, required: true),

                  const SizedBox(height: 10),
                  const Text("Date Of Birth", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: dobController,
                    hint: "DD-MM-YYYY",
                    icon: Icons.calendar_today,
                    readOnly: true,
                    required: true,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        dobController.text =
                        "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                        ageController.text = _calculateAge(dobController.text).toString();
                      }
                    },
                  ),

                  const SizedBox(height: 10),
                  const Text("Age", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: ageController, hint: "Age", icon: Icons.cake, readOnly: true),

                  const SizedBox(height: 10),
                  const Text("Mobile Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: primaryMobileController, hint: "Mobile Number", icon: Icons.phone_rounded, keyboardType: TextInputType.number, maxLength: 10, required: true),

                  const SizedBox(height: 10),
                  const Text("WhatsApp Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: whatsappController, hint: "WhatsApp Number", icon: Icons.phone_rounded, keyboardType: TextInputType.number, maxLength: 10, required: true),

                  const SizedBox(height: 10),
                  const Text("Blood Group", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassContainer(
                    child: DropdownSearch<String>(
                      items: bloodGroups,
                      onChanged: (value) {
                        bloodGroupController.text = value ?? "";
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text("City Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),

                  Obx(() {
                    cityController.text = infoController.city.value;
                    return GestureDetector(
                      onTap: () async {
                        await infoController.fetchCurrentCity();
                      },
                      child: AbsorbPointer(
                        child: _glassTextField(
                          controller: cityController,
                          hint: infoController.isFetchingLocation.value
                              ? "Fetching location..."
                              : "Tap to detect city",
                          icon: Icons.location_on,
                          required: true,
                          readOnly: true,
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 10),
                  const Text("Current Address", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: addressController, hint: "Current Address", icon: Icons.home_filled, required: true),

                  const SizedBox(height: 10),
                  const Text("Language", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassContainer(
                    child: DropdownSearch<String>.multiSelection(
                      items: languagesList,
                      onChanged: (values) {
                        languagesController.text = values.join(", ");
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text("Emergency Contact Person Name", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: emergencyNameController, hint: "Emergency Contact Person Name", icon: Icons.person_outline, required: true),

                  const SizedBox(height: 10),
                  const Text("Emergency Contact Number", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 5),
                  _glassTextField(controller: emergencyNumberController, hint: "Emergency Contact Number", icon: Icons.phone_rounded, keyboardType: TextInputType.number, maxLength: 10, required: true),
                ],
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    infoController.name.value = nameController.text;
                    infoController.fatherName.value = fatherNameController.text;
                    infoController.motherName.value = motherNameController.text;
                    infoController.dob.value = dobController.text;
                    infoController.age.value = ageController.text;
                    infoController.mobile.value = primaryMobileController.text;
                    infoController.whatsapp.value = whatsappController.text;
                    infoController.bloodGroup.value = bloodGroupController.text;
                    infoController.city.value = cityController.text;
                    infoController.address.value = addressController.text;
                    infoController.languages.value = languagesController.text;
                    infoController.emergencyName.value = emergencyNameController.text;
                    infoController.emergencyNumber.value = emergencyNumberController.text;


                    print("========== PERSONAL INFORMATION DATA ==========");
                    print("Name: ${infoController.name.value}");
                    print("Father Name: ${infoController.fatherName.value}");
                    print("Mother Name: ${infoController.motherName.value}");
                    print("DOB: ${infoController.dob.value}");
                    print("Age: ${infoController.age.value}");
                    print("Mobile: ${infoController.mobile.value}");
                    print("WhatsApp: ${infoController.whatsapp.value}");
                    print("Blood Group: ${infoController.bloodGroup.value}");
                    print("City: ${infoController.city.value}");
                    print("Address: ${infoController.address.value}");
                    print("Languages: ${infoController.languages.value}");
                    print("Emergency Name: ${infoController.emergencyName.value}");
                    print("Emergency Number: ${infoController.emergencyNumber.value}");
                    print("Latitude: ${infoController.latitude.value}");
                    print("Longitude: ${infoController.longitude.value}");
                    print("==============================================");

                    infoController.createProfile();

                    // Get.toNamed(AppRoutes.onboarding);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF28C28), Color(0xFFE37814)],
                    ),
                  ),
                  child: const Center(
                    child: Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateAge(String dob) {
    List<String> parts = dob.split("-");
    DateTime birthDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget _glassTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool required = false,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.95),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          onTap: onTap,
          validator: required ? (value) => value == null || value.isEmpty ? "Required" : null : null,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "",
            prefixIcon: icon != null ? Icon(icon, color: const Color(0xFFF28C28)) : null,
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.95),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 6))],
        ),
        child: child,
      ),
    );
  }
}
