import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/app/module/auth/jobrider/rider_job_controller.dart';

class RiderJobListPage extends StatelessWidget {
  RiderJobListPage({super.key});

  final RiderJobController controller =
  Get.put(RiderJobController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7EF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF28C28),
        title: const Text(
          "Available Rider Jobs",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFF28C28),
            ),
          );
        }

        if (controller.jobList.isEmpty) {
          return const Center(
            child: Text(
              "No jobs available",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.jobList.length,
          itemBuilder: (context, index) {
            final job = controller.jobList[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  Text(
                    job.jobTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 14),

                  _infoRow(
                    icon: Icons.location_on,
                    text: job.city,
                  ),

                  _infoRow(
                    icon: Icons.store,
                    text: job.storeName,
                  ),

                  _infoRow(
                    icon: Icons.business,
                    text: job.vendorName,
                  ),

                  const SizedBox(height: 14),


                  Row(
                    children: [
                      _amountChip(
                        label: "Bonus ₹${job.joiningBonus}",
                        color: Colors.green,
                      ),
                      const SizedBox(width: 10),
                      _amountChip(
                        label: "Fee ₹${job.onboardingFee}",
                        color: Colors.red,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                        controller.applyForJob(job.id);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFFF28C28),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        "Apply Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }


  Widget _infoRow({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.grey,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountChip({
    required String label,
    required Color color,
  }) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
