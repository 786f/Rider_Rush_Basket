import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../routes/app_routes.dart';
import '../citypage/screen/selectcitypage.dart';

class WorkDetailsPage extends StatefulWidget {
  const WorkDetailsPage({super.key});

  @override
  State<WorkDetailsPage> createState() => _WorkDetailsPageState();
}

class _WorkDetailsPageState extends State<WorkDetailsPage> {
  String selectedVehicle = "";

  Widget vehicleTile({
    required String id,
    required String title,
    required String subtitle,
    required String image,
  }) {
    bool isSelected = selectedVehicle == id;
    bool hasImage = image.isNotEmpty;

    return GestureDetector(
      onTap: () => setState(() => selectedVehicle = id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E5) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFFF28C28) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // -------- Radio --------
                Radio(
                  value: id,
                  groupValue: selectedVehicle,
                  activeColor: const Color(0xFFF28C28),
                  onChanged: (value) {
                    setState(() => selectedVehicle = value!);
                  },
                ),

                // Small gap
                const SizedBox(width: 6),

                // -------- Title (in same line) --------
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // -------- Image (right side) --------
                if (hasImage)
                  Image.asset(
                    image,
                    width: 110,
                  ),
              ],
            ),


            const SizedBox(height: 10),

            Divider(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.info_outline,
                    size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ==================== APP BAR =====================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        // -------- BACK BUTTON --------
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),

        // -------- TITLE --------
        title: const Text(
          "Select Vehicle for Delivery",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            color: Color(0xFFF28C28),
            fontSize: 16,
          ),
        ),

        // -------- HELP BUTTON --------
        actions: [
          GestureDetector(

            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: const [
                  Icon(Icons.help_outline, color: Colors.black),
                  SizedBox(width: 4),
                  Text(
                    "Help",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),


      body: Column(
        children: [
          const SizedBox(height: 10),

          // -------------------------- BIKE --------------------------
          vehicleTile(
            id: "bike",
            title: "Bike",
            subtitle: "License & RC documents required",
            image: "assets/png/bike.png",
          ),

          // ---------------------- ELECTRIC BIKE ----------------------
          vehicleTile(
            id: "electric",
            title: "Electric bike",
            subtitle: "No License required",
            image: "assets/png/electricbike.png",
          ),

          // ------------------ NO VEHICLE OPTION --------------------
          vehicleTile(
            id: "no_vehicle",
            title: "I don't have a Vehicle",
            subtitle: "Rush Basket will help you get a vehicle", image: '',

          ),

          const Spacer(),

          // =================== CONTINUE BUTTON =====================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: GestureDetector(
              onTap: () => Get.to(() => SelectCityPage()),
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
                    "Continue",
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
          ),

        ],
      ),
    );
  }
}
