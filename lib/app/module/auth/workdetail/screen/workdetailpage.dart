import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../login/controller/work_details_controller.dart';

class WorkDetailsPage extends StatefulWidget {
  const WorkDetailsPage({super.key});

  @override
  State<WorkDetailsPage> createState() => _WorkDetailsPageState();
}

class _WorkDetailsPageState extends State<WorkDetailsPage> {
  String selectedVehicle = "";

  final WorkDetailsController controller = Get.put(WorkDetailsController());

  Widget vehicleTile({
    required String id,
    required String title,
    required String subtitle,
    required String image,
  }) {
    bool isSelected = selectedVehicle == id;
    bool hasImage = image.isNotEmpty;

    return GestureDetector(
      onTap: () {
        setState(() => selectedVehicle = id);

        if (id == "bike") controller.vehicleType.value = "Bike";
        if (id == "electric") controller.vehicleType.value = "Electric Bike";
        if (id == "no_vehicle") controller.vehicleType.value = "No Vehicle";
      },
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
              children: [
                Radio(
                  value: id,
                  groupValue: selectedVehicle,
                  activeColor: const Color(0xFFF28C28),
                  onChanged: (value) {
                    setState(() => selectedVehicle = value!);

                    if (value == "bike") controller.vehicleType.value = "Bike";
                    if (value == "electric") controller.vehicleType.value = "Electric Bike";
                    if (value == "no_vehicle") controller.vehicleType.value = "No Vehicle";
                  },
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                ),
                if (hasImage)
                  Image.asset(image, width: 110),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Select Vehicle for Delivery",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w800,
            color: Color(0xFFF28C28),
            fontSize: 16,
          ),
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),

          vehicleTile(
            id: "bike",
            title: "Bike",
            subtitle: "License & RC documents required",
            image: "assets/png/bike.png",
          ),

          vehicleTile(
            id: "electric",
            title: "Electric bike",
            subtitle: "No License required",
            image: "assets/png/electricbike.png",
          ),

          vehicleTile(
            id: "no_vehicle",
            title: "I don't have a Vehicle",
            subtitle: "Rush Basket will help you get a vehicle",
            image: '',
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Obx(() {
              return GestureDetector(
                onTap: controller.isSubmitting.value
                    ? null
                    : () async {
                  if (controller.vehicleType.value.isEmpty) {
                    Get.snackbar("Error", "Please select a vehicle");
                    return;
                  }

                  await controller.submitWorkDetails();
                  // Get.to(() => SelectCityPage());
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
                  child: Center(
                    child: controller.isSubmitting.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
