// lib/features/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';
import '../../app/services/sound_service.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NIGHTINGALE OS'),
        backgroundColor: const Color(0xFF1A1A1A), // A slightly different dark color for the app bar
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        // This delegate defines the grid layout. We want 4 items per row.
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9, // Adjust ratio to make tiles taller or shorter
        ),
        itemCount: controller.tools.length,
        itemBuilder: (context, index) {
          final tool = controller.tools[index];
          // Use an InkWell for tap effects
          return InkWell(
            onTap: () {
              // Navigate to the tool's route when tapped
              Get.find<SoundService>().playTap();
              Get.toNamed(tool.route);
            },
            borderRadius: BorderRadius.circular(8.0),
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
          );
        },
      ),
    );
  }
}