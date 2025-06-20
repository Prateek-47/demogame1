// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/controllers/game_state_controller.dart'; // <-- 1. IMPORT THE CONTROLLER
import 'app/routes/app_pages.dart';
import 'app/services/sound_service.dart'; 

Future<void> main() async {
  // 2. INITIALIZE YOUR GLOBAL CONTROLLER BEFORE RUNNING THE APP
  WidgetsFlutterBinding.ensureInitialized();
  
  // 4. Initialize and put the service using Get.putAsync
  await Get.putAsync(() => SoundService().init());
  Get.put(GameStateController()); 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Case File: Nightingale",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.green,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        fontFamily: GoogleFonts.robotoMono().fontFamily,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.green[300]),
          bodyMedium: TextStyle(color: Colors.green[300]),
          titleLarge: TextStyle(color: Colors.green[300]),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color(0xFF1A1A1A),
          selectedItemColor: Colors.green[400],
          unselectedItemColor: Colors.grey[600],
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}