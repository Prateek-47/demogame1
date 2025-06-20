// lib/features/messenger/messenger_binding.dart

import 'package:get/get.dart';
import 'messenger_controller.dart';

class MessengerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessengerController>(() => MessengerController());
  }
}