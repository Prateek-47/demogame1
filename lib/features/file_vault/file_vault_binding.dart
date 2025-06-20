// lib/features/file_vault/file_vault_binding.dart
import 'package:get/get.dart';
import 'file_vault_controller.dart';

class FileVaultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FileVaultController>(() => FileVaultController());
  }
}