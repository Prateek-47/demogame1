// lib/features/browser/browser_binding.dart
import 'package:get/get.dart';
import 'browser_controller.dart';

class BrowserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrowserController>(() => BrowserController());
  }
}