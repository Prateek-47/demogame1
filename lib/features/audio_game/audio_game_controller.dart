// lib/features/audio_game/audio_game_controller.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';

class AudioGameController extends GetxController {
  final GameStateController gameState = Get.find();
  final AudioPlayer audioPlayer = AudioPlayer();

  late TextEditingController passwordController;
  final isPasswordCorrect = false.obs;
  final passwordError = ''.obs;

  // --- UPDATED: Define the correct integer values for the puzzle (1-10) ---
  final int _correctFilter = 8;
  final int _correctPitch = 2;
  final int _correctGain = 6;

  final signalClarity = 0.0.obs;

  // --- UPDATED: Reactive variables are now integers ---
  final filter = 5.obs; // Start at a neutral value of 5
  final pitch = 5.obs;
  final gain = 5.obs;

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
  }

  void checkPassword() {
    if (passwordController.text.toLowerCase() == 'littlebird') {
      isPasswordCorrect.value = true;
      passwordError.value = '';
      playAudio();
    } else {
      passwordError.value = 'DECRYPTION FAILED: Incorrect Password';
    }
  }

  void playAudio() async {
    await audioPlayer.play(AssetSource('audio/encrypted_note.mp3'));
  }

  void onSliderChanged() {
    // --- UPDATED: The clarity calculation now uses integer distance ---
    // The maximum distance on a 1-10 slider is 9 (e.g., from 1 to 10).
    const double maxDistance = 9.0;
    
    final filterDistance = (filter.value - _correctFilter).abs();
    final pitchDistance = (pitch.value - _correctPitch).abs();
    final gainDistance = (gain.value - _correctGain).abs();

    // Calculate clarity for each slider (1.0 = perfect, 0.0 = furthest away)
    final filterClarity = 1.0 - (filterDistance / maxDistance);
    final pitchClarity = 1.0 - (pitchDistance / maxDistance);
    final gainClarity = 1.0 - (gainDistance / maxDistance);

    signalClarity.value =
        ((filterClarity + pitchClarity + gainClarity) / 3.0).clamp(0.0, 1.0);

    // Win condition is now an exact match
    if (filter.value == _correctFilter &&
        pitch.value == _correctPitch &&
        gain.value == _correctGain) {
      _onGameWon();
    }
  }

  void _onGameWon() async {
    await audioPlayer.stop();
    Get.snackbar("Decryption Complete", "Audio log successfully restored.", backgroundColor: Colors.green);
    
    gameState.addClue('final_audio_decrypted');
    gameState.addLogEntry(
        '23:45',
        "AUDIO LOG RESTORED: Thorne's message recovered. It contains coordinates and a reference to a 'manifest'. It appears he didn't vanish; he defected with his research to prevent it from being weaponized. The case is reaching its conclusion.",
    );

    gameState.unlockFile('rendezvous_geo');
    gameState.unlockFile('manifest_pdf');

    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Go back to the File Vault
    });
  }

  @override
  void onClose() {
    passwordController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
}