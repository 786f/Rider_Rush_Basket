import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';
import '../../document/screen/document_upload_status.dart';
import '../../order/screen/order_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFFF28C28),
        statusBarIconBrightness: Brightness.light,
      ),
    );

    void _showReferralCodeSheet(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true, // for bigger content
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Referral Code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Referral Code",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You cannot change the referral Code for next 7 days",
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    // TODO: submit referral code
                    Navigator.pop(context);
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

              ],
            ),
          );
        },
      );
    }

    // Help & Support Bottom Sheet
    void _showHelpSupportSheet(BuildContext context) {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) {
          // Use StatefulBuilder to manage state inside the bottom sheet
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              // Local variables for checkboxes
              bool dontHaveDocuments = false;
              bool cantUploadDocuments = false;
              bool unableToSelectStore = false;
              bool noVehicle = false;

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Help & Support",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    const SizedBox(height: 15),
                    CheckboxListTile(
                      value: dontHaveDocuments,
                      onChanged: (val) {
                        setState(() {
                          dontHaveDocuments = val ?? false;
                        });
                      },
                      title: const Text("Don't have Documents"),
                    ),
                    CheckboxListTile(
                      value: cantUploadDocuments,
                      onChanged: (val) {
                        setState(() {
                          cantUploadDocuments = val ?? false;
                        });
                      },
                      title: const Text("Can't upload Documents"),
                    ),
                    CheckboxListTile(
                      value: unableToSelectStore,
                      onChanged: (val) {
                        setState(() {
                          unableToSelectStore = val ?? false;
                        });
                      },
                      title: const Text("Unable to select a Store"),
                    ),
                    CheckboxListTile(
                      value: noVehicle,
                      onChanged: (val) {
                        setState(() {
                          noVehicle = val ?? false;
                        });
                      },
                      title: const Text("I don't have a Vehicle"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Any other Comments",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // You can now read the checkbox states here
                        print({
                          "dontHaveDocuments": dontHaveDocuments,
                          "cantUploadDocuments": cantUploadDocuments,
                          "unableToSelectStore": unableToSelectStore,
                          "noVehicle": noVehicle,
                        });
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
                            "Raise Ticket",
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
              );
            },
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ===================== TOP PURPLE HEADER ==========================
          Container(
            width: double.infinity,
            height: 180, // 🔥 Full top area covered
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF28C28),
                  Color(0xFFE57D20),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20), // 🔥 Better spacing
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -------------------- Main Text + Badge ---------------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Complete your\nOnboarding in 10 min",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "EARN UP TO",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              "₹40,000",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

               //   const SizedBox(height: 10),

                  // ===================== TESTIMONIAL SLIDER =====================
                  // SizedBox(
                  //   height: 120,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: [
                  //       _testimonialCard(
                  //         quote:
                  //         "“Having been a rider for Rush Basket since 1.5 years, I'm really happy with the consistent earnings of Rush Basket”",
                  //         name: "Syed",
                  //         city: "Bangalore",
                  //       ),
                  //       _testimonialCard(
                  //         quote:
                  //         "“I have been working here for a year and love the stable payouts”",
                  //         name: "Manoj",
                  //         city: "Hyderabad",
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
          ),


          const SizedBox(height: 30),

          // ===================== COMPLETE IN 2 STEPS =====================
          const Text(
            "COMPLETE IN 2 STEPS",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 40),

          // STEP 1
          _stepTile(
            step: "1",
            title: "Work Details",
            subtitle: "Vehicle, City, Store",
            onTap: () => Get.toNamed(AppRoutes.workDetails),
            isCompleted: UploadStatus.workDetailsCompleted,
          ),

          const SizedBox(height: 12),

          // STEP 2 (locked until step 1)
          _stepTile(
            step: "2",
            title: "Documents",
            subtitle: "Aadhaar, PAN & Selfie",
            onTap: () => Get.toNamed(AppRoutes.documents),
            isCompleted: UploadStatus.documentDetailsCompleted,
          ),

          const SizedBox(height: 20),

          // Referral + Help
          TextButton.icon(
            onPressed: () => _showReferralCodeSheet(context),
            icon: const Icon(Icons.card_giftcard, color:   Color(0xFF4A76B9),),
            label: const Text(
              "Have a Referral Code?",
              style: TextStyle(
                color:  Color(0xFF4A76B9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => _showHelpSupportSheet(context),
            icon: const Icon(Icons.help_outline, color:   Color(0xFF4A76B9),),
            label: const Text(
              "Need Help?",
              style: TextStyle(
                color:   Color(0xFF4A76B9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Spacer(),

          // ===================== CONTINUE BUTTON =====================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: GestureDetector(
              onTap: () => Get.to(() => OrdersPage()),
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

  // ----------------------------------------------------------------------
  // Testimonial Card
  // ----------------------------------------------------------------------
  Widget _testimonialCard({
    required String quote,
    required String name,
    required String city,
  }) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            quote,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "$name • $city",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // Step Tile (Work Details / Documents)
  // ----------------------------------------------------------------------
  Widget _stepTile({
    required String step,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isCompleted,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: isCompleted
                  ? const Color(0xFF4A76B9).withOpacity(0.15)
                  : Colors.white,
              child: isCompleted
                  ? const Icon(
                Icons.check,
                color: Color(0xFF1A3C6E),
                size: 22,
              )
                  : Text(
                step,
                style: const TextStyle(
                  color: Color(0xFF1A3C6E),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            // Title + Subtitle
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
            const Spacer(),

            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
