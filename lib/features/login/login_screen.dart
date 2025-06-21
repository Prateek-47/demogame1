// lib/features/login/login_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import '../../app/services/sound_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isScanning = false;
  String _statusText = "Awaiting Biometric Scan";

  void _startScan() {
    setState(() {
      _isScanning = true;
      _statusText = "SCANNING...";
    });

    // Simulate a scan, then grant access.
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _statusText = "ACCESS GRANTED";
      });
      Get.find<SoundService>().playNotification(); // Play a success sound

      // Navigate to the home screen after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offNamed(Routes.HOME); // Use offNamed to prevent going back to login
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'CtOS',
                style: Get.textTheme.headlineSmall?.copyWith(color: Colors.white,fontSize: 60.0, // <-- Increase the font size here.
    fontWeight: FontWeight.bold,),
              ),
              const SizedBox(height: 40),
              TextField(
                readOnly: true, // Make it non-editable
                controller: TextEditingController(text: 'Agent-742'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  labelText: 'AGENT ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 50),
              GestureDetector(
                onTap: _isScanning ? null : _startScan,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _isScanning ? 1.0 : 0.0),
                  duration: const Duration(seconds: 3),
                  builder: (context, value, child) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                        boxShadow: [
                          // Create a glowing effect based on the animation value
                          BoxShadow(
                            color: Colors.green.withOpacity(value * 0.5),
                            blurRadius: 30 * value,
                            spreadRadius: 5 * value,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.fingerprint,
                        size: 100,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _statusText,
                style: const TextStyle(color: Colors.green, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}