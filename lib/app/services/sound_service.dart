// lib/app/services/sound_service.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SoundService extends GetxService {
  late AudioPlayer _uiSoundPlayer;

  Future<SoundService> init() async {
    print("SoundService Initialized");
    _uiSoundPlayer = AudioPlayer();
    await _uiSoundPlayer.setPlayerMode(PlayerMode.lowLatency);
    // You can set a default volume for all sounds played through this player
    await _uiSoundPlayer.setVolume(0.3);
    return this;
  }

  // To fix the "plays only once" bug, we call stop() before every play().
  // This resets the player's state and ensures it can play again immediately.
  void playTap() async {
    await _uiSoundPlayer.stop();
    await _uiSoundPlayer.play(AssetSource('audio/button.wav'));
  }

  void playNotification() async {
    await _uiSoundPlayer.stop();
    await _uiSoundPlayer.play(AssetSource('audio/notification.wav'));
  }

  void playError() async {
    await _uiSoundPlayer.stop();
    await _uiSoundPlayer.play(AssetSource('audio/error.wav'));
  }

  @override
  void onClose() {
    _uiSoundPlayer.dispose();
    super.onClose();
  }
}