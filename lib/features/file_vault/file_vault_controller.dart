// lib/features/file_vault/file_vault_controller.dart

import 'package:flutter/material.dart'; // Import this for AlertDialog
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
import '../../app/data/models/file_model.dart';
import '../../app/routes/app_pages.dart';
import '../browser/browser_controller.dart';
import '../../app/services/sound_service.dart';

class FileVaultController extends GetxController {
  void handleFileTap(GameFile file) {
    Get.find<SoundService>().playTap();
    final GameStateController gameState = Get.find();

    if (file.isLocked) {
      Get.find<SoundService>().playError();
      Get.snackbar(
        "Access Denied",
        "File is encrypted or requires a key.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    gameState.markEvidenceAsViewed(file.id);

    switch (file.id) {
      case 'firewall_bypass':
        Get.toNamed(Routes.FIREWALL_GAME);
        break;
      case 'note_for_lb':
        Get.toNamed(Routes.AUDIO_GAME);
        break;
      case 'rendezvous_geo':
        Get.toNamed(Routes.BROWSER, arguments: BrowserPage.mapView);
        break;

      // --- THIS IS THE NEW, SIMPLIFIED LOGIC ---
      case 'manifest_pdf':
        // Instead of navigating, we now show a dialog box directly.
        Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF1F1F1F),
            title: Text(
              file.fileName,
              style: TextStyle(color: Colors.green[200]),
            ),
            content: SingleChildScrollView(
              child: Text(
                file.content,
                style: TextStyle(
                  color: Colors.green[200], // Ensure text is visible
                  height: 1.6,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(), // Closes the dialog
                child: const Text('CLOSE'),
              ),
            ],
          ),
        );
        break;

      default:
        Get.snackbar(
          "No Associated Action",
          "This file contains read-only information.",
        );
    }
  }
}