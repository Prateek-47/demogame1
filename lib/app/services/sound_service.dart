// lib/app/services/sound_service.dart

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class SoundService extends GetxService {
  // Use a separate player for UI sounds to avoid conflict with other audio
  late AudioPlayer _uiSoundPlayer;

  // The init method is required for Get.putAsync
  Future<SoundService> init() async {
    print("SoundService Initialized");
    _uiSoundPlayer = AudioPlayer();
    // Low latency mode is best for short, responsive UI sounds
    await _uiSoundPlayer.setPlayerMode(PlayerMode.lowLatency);
    // Set a low volume for UI sounds so they aren't annoying
    await _uiSoundPlayer.setVolume(0.3);
    return this;
  }

  void playTap() async{
   await _uiSoundPlayer.play(AssetSource('assets/audio/button.wav'));
  }

  void playNotification() {
    _uiSoundPlayer.play(AssetSource('assets/audio/notification.wav'));
  }

  void playError() {
    _uiSoundPlayer.play(AssetSource('assets/audio/error.wav'));
  }

  @override
  void onClose() {
    // Dispose of the player when the service is closed
    _uiSoundPlayer.dispose();
    super.onClose();
  }
}