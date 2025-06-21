// lib/features/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // This removes the simple native splash screen, allowing our Flutter UI to take over.
    FlutterNativeSplash.remove(); 
    
    // After a 3-second delay, navigate to the home screen.
    Future.delayed(const Duration(seconds: 2), () {
      // Use offNamed to prevent the user from navigating back to the splash screen.
      Get.offNamed(Routes.LOGIN);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is simply our full-screen image.
      body: Image.asset(
        'assets/images/splash_logo.png', // The path to your full-screen image
        // This is the most important property. It tells the image to fill the
        // entire screen without stretching or distorting its proportions.
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}