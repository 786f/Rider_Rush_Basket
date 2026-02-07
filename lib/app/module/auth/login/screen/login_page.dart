import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';


class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Stack(
        children: [

          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 280,
              height: 280,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1A3C6E),
                    Color(0xFF4A76B9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Opacity(
                opacity: 0.18,
                child: Container(),
              ),
            ),
          ),

          Positioned(
            bottom: -160,
            right: -160,
            child: Container(
              width: 380,
              height: 380,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF28C28),
                    Color(0xFFE57D16),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Opacity(
                opacity: 0.20,
                child: Container(),
              ),
            ),
          ),

          Positioned(
            bottom: 200,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFF28C28).withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 70),

                    Center(
                      child: Hero(
                        tag: "app_logo",
                        child: Image.asset(
                          "assets/png/rushbasket.png",
                          height: 170,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    Text(
                      "Welcome Back 👋",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[900],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Login to continue with RushBaskets",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 45),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white.withOpacity(0.9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onChanged: (value) => controller.phone.value = value,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          prefixIcon: Icon(
                            Icons.phone_rounded,
                            color: Color(0xFFF28C28),
                            size: 26,
                          ),
                          hintText: "Enter Mobile Number",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 45),

                    GestureDetector(
                      onTap: controller.sendOtp,
                      child: Obx(() => Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF28C28), Color(0xFFE37814)],
                          ),
                        ),
                        child: Center(
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                            "Send OTP",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )),
                    ),


                    const SizedBox(height: 30),

                    Text(
                      "By continuing, you agree to our Terms & Conditions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 225),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
