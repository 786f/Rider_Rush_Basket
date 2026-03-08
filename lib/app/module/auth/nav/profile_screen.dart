// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../currentorder/current_order_screen.dart';
// import '../order/screen/accountpage/privacypage.dart';
// import '../order/screen/accountpage/referearn.dart';
// import '../order/screen/accountpage/supportpage.dart';
// import '../order/screen/accountpage/termcondition.dart';
// import 'profile_controller.dart';
//
// class ProfileScreen extends StatelessWidget {
//   ProfileScreen({super.key});
//
//   final ProfileController controller = Get.put(ProfileController());
//
//   static const Color primaryOrange = Color(0xffF57C00);
//   static const Color bgColor = Color(0xffFFF7F1);
//
//   void _showWithdrawDialog(BuildContext context) {
//     final TextEditingController amountController =
//     TextEditingController();
//     final TextEditingController descriptionController =
//     TextEditingController();
//
//     Get.dialog(
//       Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Withdraw Amount",
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: primaryOrange,
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Amount Field
//               TextField(
//                 controller: amountController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(
//                   labelText: "Enter Amount",
//                   prefixIcon: const Icon(Icons.currency_rupee,
//                       color: primaryOrange),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                     const BorderSide(color: primaryOrange),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 15),
//
//               // Description Field
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                   labelText: "Description",
//                   prefixIcon: const Icon(Icons.description,
//                       color: primaryOrange),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                     const BorderSide(color: primaryOrange),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               Obx(() => SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: controller.isLoading.value
//                       ? null
//                       : () {
//                     final amount =
//                     double.tryParse(amountController.text);
//
//                     if (amount == null || amount <= 0) {
//                       Get.snackbar(
//                           "Error", "Enter valid amount");
//                       return;
//                     }
//
//                     controller.withdrawAmount(
//                       amount: amount,
//                       description:
//                       descriptionController.text.isEmpty
//                           ? "Wallet withdrawal"
//                           : descriptionController.text,
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primaryOrange,
//                     shape: RoundedRectangleBorder(
//                       borderRadius:
//                       BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 14),
//                   ),
//                   child: controller.isLoading.value
//                       ? const CircularProgressIndicator(
//                     color: Colors.white,
//                   )
//                       : const Text(
//                     "Withdraw",
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,color: Colors.white),
//                   ),
//                 ),
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "Account",
//           style: TextStyle(
//             color: primaryOrange,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: primaryOrange),
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         final profile = controller.profile;
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               _profileHeader(
//                 name: profile['fullName'] ?? "Rider",
//                 phone: profile['mobileNumber'] ?? "--",
//                 image: profile['image'],
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: () {
//                         _showWithdrawDialog(context);
//                       },
//                       child: _earningCard(
//                         "Due Amount",
//                         "₹${profile['dueBalance'] ?? 0}",
//                         Icons.account_balance_wallet_outlined,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _earningCard(
//                       "Total Earnings",
//                       "₹${(profile['earningWallet'] ?? 0).toString()}",
//                       Icons.account_balance_wallet,
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 24),
//               // _optionTile(Icons.person, "Edit Profile"),
//               _optionTile(
//                 Icons.shopping_bag,
//                 "Current Order",
//                 onTap: () {
//                   Navigator.push(
//                     Get.context!,
//                     MaterialPageRoute(
//                       builder: (_) => CurrentOrderScreen(),
//                     ),
//                   );
//                 },
//               ),
//               _optionTile(Icons.card_giftcard, "Refer and Earn",onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReferEarnPage(),
//                   ),
//                 );
//               },),
//               _optionTile(Icons.support_agent, "Support",onTap: (){
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) =>  SupportPage(),
//                   ),
//                 );
//               },),
//               _optionTile(
//                 Icons.description,
//                 "Terms and Conditions",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>  TermsConditionsPage(),
//                     ),
//                   );
//                 },
//               ),
//               _optionTile(
//                 Icons.privacy_tip,
//                 "Privacy Policy",
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>  PrivacyPolicyPage(),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               _logoutTile(context),
//               const SizedBox(height: 16),
//               const Text(
//                 "App Version 1.0.0 (30)",
//                 style: TextStyle(color: Colors.black45, fontSize: 12),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _profileHeader({
//     required String name,
//     required String phone,
//     String? image,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 36,
//             backgroundColor: primaryOrange,
//             child: CircleAvatar(
//               radius: 33,
//               backgroundImage: (image != null && image.isNotEmpty)
//                   ? NetworkImage(image)
//                   : null,
//               child: (image == null || image.isEmpty)
//                   ? const Icon(
//                       Icons.person,
//                       size: 32,
//                       color: Colors.white,
//                     )
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 phone,
//                 style: const TextStyle(color: Colors.black54),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _earningCard(String title, String amount, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: [
//           Icon(icon, color: primaryOrange),
//           const SizedBox(height: 8),
//           Text(title, style: const TextStyle(color: Colors.black54)),
//           const SizedBox(height: 4),
//           Text(
//             amount,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: primaryOrange,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _optionTile(
//     IconData icon,
//     String title, {
//     VoidCallback? onTap,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: _cardDecoration(),
//       child: ListTile(
//         leading: Icon(icon, color: primaryOrange),
//         title: Text(title),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//         onTap: onTap,
//       ),
//     );
//   }
//
//   Widget _logoutTile(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: ListTile(
//         leading: const Icon(Icons.logout, color: Colors.red),
//         title: const Text(
//           "Log Out",
//           style: TextStyle(
//             color: Colors.red,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         onTap: () => _showLogoutDialog(context),
//       ),
//     );
//   }
//
//   void _showLogoutDialog(BuildContext context) {
//     Get.dialog(
//       AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         title: const Text("Logout"),
//         content: const Text("Are you sure you want to logout?"),
//         actions: [
//           TextButton(
//             onPressed: Get.back,
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryOrange,
//             ),
//             onPressed: () {
//               Get.back();
//               controller.logout();
//             },
//             child: const Text("Logout"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           blurRadius: 8,
//           color: Colors.black.withOpacity(0.05),
//           offset: const Offset(0, 4),
//         ),
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../currentorder/current_order_screen.dart';
import '../order/screen/accountpage/privacypage.dart';
import '../order/screen/accountpage/referearn.dart';
import '../order/screen/accountpage/supportpage.dart';
import '../order/screen/accountpage/termcondition.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  static const Color primaryOrange = Color(0xffF57C00);
  static const Color bgColor = Color(0xffFFF7F1);

  void _showWithdrawDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController =
    TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Withdraw Amount",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryOrange,
                ),
              ),
              const SizedBox(height: 20),

              /// Amount Field
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Amount",
                  prefixIcon: const Icon(Icons.currency_rupee,
                      color: primaryOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              /// Description Field
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  prefixIcon:
                  const Icon(Icons.description, color: primaryOrange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Obx(() => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                    final amount =
                    double.tryParse(amountController.text);

                    if (amount == null || amount <= 0) {
                      Get.snackbar("Error", "Enter valid amount");
                      return;
                    }

                    controller.withdrawAmount(
                      amount: amount,
                      description: descriptionController.text.isEmpty
                          ? "Wallet withdrawal"
                          : descriptionController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text(
                    "Withdraw",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Account",
          style: TextStyle(
            color: primaryOrange,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryOrange),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile;

        return RefreshIndicator(
          color: primaryOrange,
          onRefresh: () async {
            await controller.fetchProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _profileHeader(
                  name: profile['fullName'] ?? "Rider",
                  phone: profile['mobileNumber'] ?? "--",
                  image: profile['image'],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(

                        child: _earningCard(
                          "Due Amount",
                          "₹${profile['dueBalance'] ?? 0}",
                          Icons.account_balance_wallet_outlined,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _showWithdrawDialog(context);
                        },
                        child: _earningCard(
                          "Total Earnings",
                          "₹${(profile['earningWallet'] ?? 0).toString()}",
                          Icons.account_balance_wallet,
                        ) ,
                      ),


                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Current Order
                _optionTile(
                  Icons.shopping_bag,
                  "Current Order",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CurrentOrderScreen(),
                      ),
                    );
                  },
                ),

                /// Refer & Earn
                _optionTile(
                  Icons.card_giftcard,
                  "Refer and Earn",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReferEarnPage(),
                      ),
                    );
                  },
                ),

                /// Support
                _optionTile(
                  Icons.support_agent,
                  "Support",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SupportPage(),
                      ),
                    );
                  },
                ),

                /// Terms
                _optionTile(
                  Icons.description,
                  "Terms and Conditions",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TermsConditionsPage(),
                      ),
                    );
                  },
                ),

                /// Privacy
                _optionTile(
                  Icons.privacy_tip,
                  "Privacy Policy",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                _logoutTile(context),

                const SizedBox(height: 16),

                const Text(
                  "App Version 1.0.0 (30)",
                  style: TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _profileHeader({
    required String name,
    required String phone,
    String? image,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: primaryOrange,
            child: CircleAvatar(
              radius: 33,
              backgroundImage:
              (image != null && image.isNotEmpty) ? NetworkImage(image) : null,
              child: (image == null || image.isEmpty)
                  ? const Icon(Icons.person, size: 32, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(phone, style: const TextStyle(color: Colors.black54)),
            ],
          )
        ],
      ),
    );
  }

  Widget _earningCard(String title, String amount, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Icon(icon, color: primaryOrange),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile(
      IconData icon,
      String title, {
        VoidCallback? onTap,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: _cardDecoration(),
      child: ListTile(
        leading: Icon(icon, color: primaryOrange),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _logoutTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text(
          "Log Out",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        onTap: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryOrange),
            onPressed: () {
              Get.back();
              controller.logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          blurRadius: 8,
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}