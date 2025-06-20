// lib/features/audio_game/audio_game_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'audio_game_controller.dart';

class AudioGameScreen extends GetView<AudioGameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Decryption Utility")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // Obx will rebuild the child when isPasswordCorrect changes
        child: Obx(() {
          return controller.isPasswordCorrect.value
              ? _buildDecryptionInterface()
              : _buildPasswordInterface();
        }),
      ),
    );
  }

  Widget _buildPasswordInterface() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("PASSWORD REQUIRED", style: Get.textTheme.titleLarge),
        SizedBox(height: 20),
        TextField(
          controller: controller.passwordController,
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
        ),
        SizedBox(height: 10),
        Obx(() => Text(controller.passwordError.value, style: TextStyle(color: Colors.red))),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: controller.checkPassword,
          child: Text("DECRYPT"),
        ),
      ],
    );
  }

  Widget _buildDecryptionInterface() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text("DECRYPTION IN PROGRESS...", style: Get.textTheme.titleLarge),
        _buildSlider("FILTER", controller.filter),
        _buildSlider("PITCH", controller.pitch),
        _buildSlider("GAIN", controller.gain),
        
        // --- NEW: This Icon is now wrapped in an Obx to be reactive ---
        Obx(() {
          // Calculate color and size based on signalClarity
          // Color.lerp smoothly transitions between two colors.
          final iconColor = Color.lerp(
            Colors.grey[700], // "Cold" color
            Colors.greenAccent, // "Hot" color
            controller.signalClarity.value,
          );
          // The size will grow from 60 to 100 as clarity increases.
          final iconSize = 60 + (40 * controller.signalClarity.value);

          return Icon(
            Icons.graphic_eq,
            size: iconSize,
            color: iconColor,
          );
        }),
      ],
    );
  }

  Widget _buildSlider(String label, RxInt value) { // <-- Now accepts RxInt
    return Column(
      children: [
        Text(label),
        Obx(
          () => Slider(
            // The Slider widget works with doubles, so we convert our int
            value: value.value.toDouble(),
            // --- NEW: Define the range and divisions ---
            min: 1.0,
            max: 10.0,
            divisions: 9, // This creates 10 snapping points (10 - 1)
            // This shows the number label as you slide
            label: value.value.toString(),
            
            // The onChanged callback gives a double, so we round it back to an int
            onChanged: (newValue) => value.value = newValue.round(),
            onChangeEnd: (_) => controller.onSliderChanged(),
            activeColor: Colors.green,
          ),
        ),
      ],
    );
  }
}