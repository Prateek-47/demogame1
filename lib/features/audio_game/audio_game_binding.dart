import 'package:get/get.dart';
import 'audio_game_controller.dart';

class AudioGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioGameController>(() => AudioGameController());
  }
}