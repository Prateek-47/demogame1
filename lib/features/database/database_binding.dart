// lib/features/database/database_binding.dart

import 'package:get/get.dart';
import 'database_controller.dart';

class DatabaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DatabaseController>(() => DatabaseController());
  }
}