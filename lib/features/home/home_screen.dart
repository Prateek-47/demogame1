// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../app/services/sound_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar is removed to make the info card the main header
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. THE NEW AGENT INFO CARD ---
            _AgentInfoCard(),

            // --- 2. THE GRID OF TOOLS IS WRAPPED IN EXPANDED ---
            // This makes it take up the remaining space on the screen.
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(24.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: controller.tools.length,
                itemBuilder: (context, index) {
                  final tool = controller.tools[index];
                  return InkWell(
                    onTap: () {
                      Get.find<SoundService>().playTap();
                      Get.toNamed(tool.route);
                    },
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(tool.icon, size: 40.0),
                          const SizedBox(height: 8.0),
                          Text(
                            tool.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms).scale(
                        delay: (100 * index).ms,
                        duration: 200.ms,
                        begin: const Offset(0.8, 0.8),
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- A NEW PRIVATE WIDGET FOR THE INFO CARD ---
class _AgentInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AGENT-742',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('STATUS: ', style: TextStyle(color: Colors.grey[400])),
              const Text('ACTIVE', style: TextStyle(color: Colors.greenAccent)),
            ],
          ),
          Row(
            children: [
              Text('LOCATION: ', style: TextStyle(color: Colors.grey[400])),
              const Text('[REDACTED]', style: TextStyle(color: Colors.white)),
            ],
          ),
          Row(
            children: [
              Text('CONNECTION: ', style: TextStyle(color: Colors.grey[400])),
              const Text('SECURE', style: TextStyle(color: Colors.greenAccent)),
            ],
          ),
        ],
      ),
    );
  }
}