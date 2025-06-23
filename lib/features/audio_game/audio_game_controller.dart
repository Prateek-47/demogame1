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

  final int _correctFilter = 8;
  final int _correctPitch = 2;
  final int _correctGain = 6;

  final signalClarity = 0.0.obs;

  final filter = 5.obs;
  final pitch = 5.obs;
  final gain = 5.obs;

  @override
  void onInit() {
    super.onInit();
    passwordController = TextEditingController();
    // --- CHANGE 1: Set the player to loop the audio continuously ---
    // We do this once when the controller is created.
    audioPlayer.setReleaseMode(ReleaseMode.loop);
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
    const double maxDistance = 9.0;
    
    final filterDistance = (filter.value - _correctFilter).abs();
    final pitchDistance = (pitch.value - _correctPitch).abs();
    final gainDistance = (gain.value - _correctGain).abs();

    final filterClarity = 1.0 - (filterDistance / maxDistance);
    final pitchClarity = 1.0 - (pitchDistance / maxDistance);
    final gainClarity = 1.0 - (gainDistance / maxDistance);

    signalClarity.value =
        ((filterClarity + pitchClarity + gainClarity) / 3.0).clamp(0.0, 1.0);

    if (filter.value == _correctFilter &&
        pitch.value == _correctPitch &&
        gain.value == _correctGain) {
      _onGameWon();
    }
  }

  void _onGameWon() async {
    // --- CHANGE 2: The logic for winning the game is now more robust ---
    
    // 1. Stop the looping audio.
    await audioPlayer.stop();

    // 2. Update the global game state.
    gameState.addClue('final_audio_decrypted');
    gameState.addLogEntry(
        '23:45',
        "AUDIO LOG RESTORED: Thorne's message recovered. It contains coordinates and a reference to a 'manifest'. It appears he didn't vanish; he defected with his research to prevent it from being weaponized. The case is reaching its conclusion.",
    );
    gameState.unlockFile('rendezvous_geo');
    gameState.unlockFile('manifest_pdf');

    // 3. Navigate back IMMEDIATELY.
    Get.back();

    // 4. Show the success message AFTER navigating.
    // This will appear on top of the File Vault screen.
    Get.snackbar("Decryption Complete", "Audio log successfully restored.",
        backgroundColor: Colors.green);
  }

  @override
  void onClose() {
    // It's very important to stop and dispose of the player to free up resources.
    audioPlayer.stop();
    passwordController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
}