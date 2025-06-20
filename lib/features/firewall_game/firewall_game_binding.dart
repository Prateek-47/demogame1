// lib/features/firewall_game/firewall_game_binding.dart
import 'package:get/get.dart';
import 'firewall_game_logic.dart';

class FirewallGameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirewallGameController>(() => FirewallGameController());
  }
}