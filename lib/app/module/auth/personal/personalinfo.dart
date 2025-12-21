import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController(); // Age field
  final TextEditingController primaryMobileController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
 // final TextEditingController secondaryMobileController = TextEditingController();
  final TextEditingController bloodGroupController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController languagesController = TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController(); // New
  final TextEditingController emergencyNumberController = TextEditingController(); // New
  final TextEditingController referralCodeController = TextEditingController();


  final List<String> indianCities = [
    "Agra",
    "Ahmedabad",
    "Aizawl",
    "Ajmer",
    "Aligarh",
    "Allahabad (Prayagraj)",
    "Amravati",
    "Amritsar",
    "Anand",
    "Asansol",
    "Aurangabad",
    "Bareilly",
    "Bengaluru",
    "Belgaum",
    "Bhavnagar",
    "Bhilai",
    "Bhiwandi",
    "Bhopal",
    "Bhubaneswar",
    "Bikaner",
    "Bilaspur",
    "Bokaro Steel City",
    "Chandigarh",
    "Chennai",
    "Coimbatore",
    "Cuttack",
    "Dehradun",
    "Delhi",
    "Dhanbad",
    "Dibrugarh",
    "Durgapur",
    "Erode",
    "Faridabad",
    "Firozabad",
    "Gandhinagar",
    "Gaya",
    "Ghaziabad",
    "Gorakhpur",
    "Gulbarga",
    "Guntur",
    "Guwahati",
    "Gwalior",
    "Haridwar",
    "Hisar",
    "Hubballi-Dharwad",
    "Hyderabad",
    "Indore",
    "Itanagar",
    "Jabalpur",
    "Jaipur",
    "Jalandhar",
    "Jammu",
    "Jamnagar",
    "Jamshedpur",
    "Jhansi",
    "Jodhpur",
    "Junagadh",
    "Kadapa",
    "Kakinada",
    "Kalyan-Dombivli",
    "Kanpur",
    "Karimnagar",
    "Karnal",
    "Khammam",
    "Kochi",
    "Kolhapur",
    "Kolkata",
    "Kollam",
    "Korba",
    "Kota",
    "Kozhikode",
    "Kurnool",
    "Kurukshetra",
    "Latur",
    "Lucknow",
    "Ludhiana",
    "Madurai",
    "Mangalore",
    "Mathura",
    "Meerut",
    "Moradabad",
    "Mumbai",
    "Mysuru",
    "Nagpur",
    "Nanded",
    "Nashik",
    "Navi Mumbai",
    "Noida",
    "Panaji",
    "Panchkula",
    "Patiala",
    "Patna",
    "Pimpri-Chinchwad",
    "Pondicherry (Puducherry)",
    "Prayagraj",
    "Pune",
    "Raipur",
    "Rajahmundry",
    "Rajkot",
    "Ranchi",
    "Ratlam",
    "Rewa",
    "Rohtak",
    "Rourkela",
    "Sagar",
    "Saharanpur",
    "Salem",
    "Sangli",
    "Satna",
    "Shillong",
    "Shimla",
    "Siliguri",
    "Solapur",
    "Sonipat",
    "Srinagar",
    "Surat",
    "Thane",
    "Thiruvananthapuram",
    "Thrissur",
    "Tiruchirappalli",
    "Tirunelveli",
    "Tirupati",
    "Tirupur",
    "Udaipur",
    "Ujjain",
    "Ulhasnagar",
    "Vadodara",
    "Varanasi",
    "Vasai-Virar",
    "Vellore",
    "Vijayawada",
    "Visakhapatnam",
    "Warangal",
    "Yamunanagar",

    // Additional Tier-2/Tier-3 Major Cities (to reach ~200)
    "Balasore",
    "Bathinda",
    "Begusarai",
    "Bhagalpur",
    "Bharatpur",
    "Bulandshahr",
    "Chittoor",
    "Darbhanga",
    "Etawah",
    "Faizabad (Ayodhya)",
    "Ganganagar",
    "Godhra",
    "Gopalpur",
    "Guna",
    "Haldwani",
    "Hassan",
    "Hoshiarpur",
    "Jalgaon",
    "Karaikudi",
    "Kasganj",
    "Katni",
    "Kavaratti",
    "Kharagpur",
    "Koraput",
    "Lakhimpur",
    "Malappuram",
    "Mandya",
    "Nellore",
    "Nizamabad",
    "Palakkad",
    "Pathankot",
    "Porbandar",
    "Raichur",
    "Raisen",
    "Rajsamand",
    "Ratnagiri",
    "Satara",
    "Sambalpur",
    "Siwan",
    "Surendranagar",
    "Thoothukudi",
    "Tumkur",
    "Unnao",
    "Vapi",
    "Vidisha",
    "Wardha",
    "Yavatmal",
  ];

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
                crossAxisAlignment: CrossAxisAlignment.start,   // <<< IMPORTANT
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  _glassTextField(
                    controller: nameController,
                    hint: "Enter your name (Same as PAN Card)",
                    icon: Icons.person,
                    required: true,
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Father's Name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: fatherNameController,
                    hint: "Enter father's name",
                    icon: Icons.person_outline,
                    required: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Mother's Name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: motherNameController,
                    hint: "Enter mother's name",
                    icon: Icons.person_outline,
                    required: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Date Of Birth",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

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

                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFFF28C28),   // 🟧 Orange header & buttons
                                onPrimary: Colors.white,      // White text on orange
                                onSurface: Colors.black,      // Dates text color
                              ),
                              dialogBackgroundColor: Colors.white,
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFFF28C28),
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (picked != null) {
                        dobController.text =
                        "${picked.day.toString().padLeft(2, '0')}-"
                            "${picked.month.toString().padLeft(2, '0')}-"
                            "${picked.year}";

                        ageController.text =
                            _calculateAge(dobController.text).toString();
                      }
                    },
                  ),


                  const SizedBox(height: 10),
                  const Text(
                    "Age",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: ageController,
                    hint: "Age",
                    icon: Icons.cake,
                    readOnly: true,
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "Mobile Number",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: primaryMobileController,
                    hint: "Mobile Number",
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    required: true,
                  ),

                  const SizedBox(height: 10),
                  const Text(
                    "WhatsApp Number",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: whatsappController,
                    hint: "WhatsApp Number",
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    required: true,
                  ),
                  // _buildMobileField(secondaryMobileController, "Secondary Mobile Number", false),
                  const SizedBox(height: 10),
                  const Text(
                    "Blood Group",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _glassContainer(
                    child: DropdownSearch<String>(
                      items: bloodGroups,
                      selectedItem: bloodGroupController.text.isNotEmpty
                          ? bloodGroupController.text
                          : null,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Blood Group",
                        ),
                      ),
                      onChanged: (value) {
                        bloodGroupController.text = value ?? "";
                      },
                    ),
                  ),



                  //_buildTextField(cityController, "Enter your city", true),
                  const SizedBox(height: 10),
                  const Text(
                    "City Name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassContainer(
                    child: DropdownSearch<String>(
                      items: indianCities,
                      selectedItem: cityController.text.isNotEmpty
                          ? cityController.text
                          : null,

                      popupProps: PopupProps.menu(
                        showSearchBox: true,

                        // White popup background
                        containerBuilder: (ctx, popupWidget) {
                          return Container(
                            color: Colors.white,
                            child: popupWidget,
                          );
                        },

                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: "Search city",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select City",
                        ),
                      ),

                      onChanged: (value) {
                        cityController.text = value ?? "";
                      },
                    ),
                  ),


                  const SizedBox(height: 10),
                  const Text(
                    "Current Address",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: addressController,
                    hint: "Current Address",
                    icon: Icons.home_filled,
                    required: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Language",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassContainer(
                    child: DropdownSearch<String>.multiSelection(
                      items: languagesList,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Select Languages",
                        ),
                      ),
                      onChanged: (values) {
                        languagesController.text = values.join(", ");
                      },
                      selectedItems: languagesController.text.isNotEmpty
                          ? languagesController.text.split(", ")
                          : [],
                    ),
                  ),

                  //const SizedBox(height: 12),
                  // Emergency Contact Fields
                  const SizedBox(height: 10),
                  const Text(
                    "Emergency Contact Person Name",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  _glassTextField(
                    controller: emergencyNameController,
                    hint: "Emergency Contact Person Name",
                    icon: Icons.person_outline,
                    required: true,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Emergency Contact Number",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),
                  _glassTextField(
                    controller: emergencyNumberController,
                    hint: "Emergency Contact Number",
                    icon: Icons.phone_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  // _buildProfilePicture(),
                  // const SizedBox(height: 20),
                  // const Text(
                  //   "Referral Code (Optional)",
                  //   style: TextStyle(
                  //     fontSize: 15,
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),

                  // const SizedBox(height: 5),
                  // _buildTextField(referralCodeController, "Enter referral code (Optional)", false),
                  //
                ],
              ),



              // const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Get.toNamed(AppRoutes.onboarding);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF28C28),
                        Color(0xFFE37814),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, bool required,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,

        // FIRST LETTER CAPITAL
        textCapitalization: TextCapitalization.words,

        validator: required
            ? (value) => value == null || value.isEmpty ? "Required" : null
            : null,

        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),

        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownSearch<String>.multiSelection(
        items: languagesList,

        popupProps: PopupPropsMultiSelection.menu(
          showSearchBox: true,

          containerBuilder: (ctx, popupWidget) {
            return Container(
              color: Colors.white, // popup white background
              child: popupWidget,
            );
          },

          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search language",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select Languages",
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        onChanged: (selectedValues) {

          // Save selected languages into your controller
          languagesController.text = selectedValues.join(", ");
        },

        selectedItems: languagesController.text.isNotEmpty
            ? languagesController.text.split(", ")
            : [],
      ),
    );
  }


  Widget _buildMobileField(TextEditingController controller, String hint, bool required) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        maxLength: 10,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) return "Required";
          if (value != null && value.length != 10 && value.isNotEmpty) return "Enter 10 digits";
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          counterText: "",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: dobController,
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) return "Required";
          int age = _calculateAge(value);
          if (age < 18) return "Age must be 18 or above";
          ageController.text = age.toString();
          return null;
        },
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2000),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                      onSurface: Colors.black),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            dobController.text = "${picked.day}-${picked.month}-${picked.year}";
            ageController.text = _calculateAge(dobController.text).toString();
          }
        },
        decoration: InputDecoration(
          hintText: "DD-MM-YYYY",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: const Icon(Icons.calendar_today, color: Colors.orange),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  int _calculateAge(String dob) {
    try {
      List<String> parts = dob.split("-");
      DateTime birthDate = DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      DateTime today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }
  Widget _buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownSearch<String>(
        items: indianCities,
        selectedItem: cityController.text.isNotEmpty ? cityController.text : null,

        popupProps: PopupProps.menu(
          showSearchBox: true,

          // 🔥 Make popup background white
          containerBuilder: (ctx, popupWidget) {
            return Container(
              color: Colors.white,
              child: popupWidget,
            );
          },

          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search city",
              filled: true,
              fillColor: Colors.white,   // search bar BG white
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select your city",
            filled: true,
            fillColor: Colors.white, // dropdown BG white
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        onChanged: (value) {
          cityController.text = value ?? "";
        },
      ),
    );
  }


  Widget _buildBloodGroupDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownSearch<String>(
        items: bloodGroups,
        selectedItem: bloodGroupController.text.isNotEmpty
            ? bloodGroupController.text
            : null,

        popupProps: PopupProps.menu(
          showSearchBox: true,

          // 🔥 White popup background
          containerBuilder: (ctx, popupWidget) {
            return Container(
              color: Colors.white,
              child: popupWidget,
            );
          },

          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search blood group",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
            hintText: "Select Blood Group",
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        onChanged: (value) {
          bloodGroupController.text = value ?? "";
        },
      ),
    );
  }



  Widget _buildProfilePicture() {
    return Row(
      children: [
        const Text("Profile Picture", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () => _showImagePickerDialog(),
          child: Container(

            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: profileImage != null ? DecorationImage(image: FileImage(profileImage!), fit: BoxFit.cover) : null,
              gradient: profileImage == null
                  ? const LinearGradient(colors: [Colors.grey, Colors.grey])
                  : null,
            ),
            child: profileImage == null ? const Center(child: Icon(Icons.camera_alt, color: Colors.white)) : null,
          ),
        ),
      ],
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera, color: Colors.orange),
              title: const Text('Camera'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.orange),
              title: const Text('Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          maxLength: maxLength,
          onTap: onTap,
          textCapitalization: TextCapitalization.words,
          validator: required
              ? (value) => value == null || value.isEmpty ? "Required" : null
              : null,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: "",
            prefixIcon: icon != null
                ? Icon(icon, color: const Color(0xFFF28C28), size: 24)
                : null,
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

}


