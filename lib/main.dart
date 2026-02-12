

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riderrushbasketapp/app/module/auth/login/screen/otp_page.dart';
import 'package:riderrushbasketapp/app/module/auth/onboarding/binding/onboarding_binding.dart';
import 'package:riderrushbasketapp/app/module/auth/splash/binding/splash_binding.dart';

import 'app/module/auth/document/screen/document_page.dart';
import 'app/module/auth/jobrider/rider_job_list_page.dart';
import 'app/module/auth/login/binding/otp_binding.dart';
import 'app/module/auth/nav/bottom_nav_screen.dart';
import 'app/module/auth/onboarding/screen/onboarding_screen.dart';
import 'app/module/auth/personal/personalinfo.dart';
import 'app/module/auth/splash/screen/splash_screen.dart';
import 'app/module/auth/success/screen/success_page.dart';
import 'app/module/auth/websocket/incoming_product_screen.dart';
import 'app/module/auth/workdetail/screen/workdetailpage.dart';
import 'app/routes/app_routes.dart'; // <-- Make sure this file exists
import 'app/module/auth/login/binding/login_binding.dart';
import 'app/module/auth/login/screen/login_page.dart';
// If you don’t have splash screen yet, I will provide one below

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rush Basket App',
      initialRoute: AppRoutes.splash, // <-- No error now

      getPages: [
        GetPage(
          name: AppRoutes.splash,
          page: () => SplashPage(),
          binding: SplashBinding(),
        ),
        GetPage(
          name: AppRoutes.login,
          page: () => LoginPage(),
          binding: LoginBinding(),
        ),
        GetPage(name: AppRoutes.otp, page: () =>  OtpPage(), binding: OtpBinding()),
        GetPage(
          name: AppRoutes.onboarding,
          page: () =>  OnboardingPage(),
          binding: OnboardingBindings(),
        ),
        GetPage(
          name: AppRoutes.personal,
          page: () => const PersonalInformationPage(),
         // binding: OnboardingBindings(),
        ),
        GetPage(
          name: AppRoutes.workDetails,
          page: () => const WorkDetailsPage(),
          binding: OnboardingBindings(),
        ),
        GetPage(
          name: AppRoutes.documents,
          page: () => const DocumentsPage(),
          binding: OnboardingBindings(),
        ),
        GetPage(
          name: AppRoutes.success,
          page: () => const SuccessPage(),
        ),

        GetPage(
          name: AppRoutes.riderJobList,
          page: () =>  RiderJobListPage(),
        ),
        GetPage(
          name: AppRoutes.nav,
          page: () =>  BottomNavScreen(),
        ),
      ],
    );
  }
}
