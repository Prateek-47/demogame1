// lib/features/browser/browser_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
//import '../../app/routes/app_pages.dart';

// Enum to represent the different "pages" our fake browser can show
// Add a new page type to the enum
enum BrowserPage { searchHome, searchResults, bankLogin, bankTransactions, mapView }

class BrowserController extends GetxController {
  final GameStateController gameState = Get.find();
  late TextEditingController searchController;
  late TextEditingController usernameController;

  final currentPage = BrowserPage.searchHome.obs;

  // lib/features/browser/browser_controller.dart

// ... inside the BrowserController class ...

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    usernameController = TextEditingController(text: 'athorne');

    // --- UPDATED LOGIC ---
    // First, check if a specific page was passed as an argument.
    if (Get.arguments is BrowserPage) {
      currentPage.value = Get.arguments;
    } 
    // If no argument, then fall back to the existing logic.
    else if (gameState.unlockedClueIds.contains('gilded_cage_accessed')) {
      currentPage.value = BrowserPage.bankTransactions;
    }
  }

  void performSearch() {
    if (searchController.text.toLowerCase().contains('gilded cage')) {
      currentPage.value = BrowserPage.searchResults;
    }
  }

  void navigateTo(BrowserPage page) {
    currentPage.value = page;
  }

  void attemptLogin() {
    // When login is attempted, Control sends a message and unlocks the bypass tool
    if (!gameState.unlockedClueIds.contains('firewall_bypass_unlocked')) {
      gameState.addLogEntry(
        '23:15',
        "Agent, we've detected your attempt to access Thorne's financial account. His security is formidable. I'm pushing a brute-force decryption package to your File Vault. Use it to bypass their firewall.",
      );
      gameState.unlockFile('firewall_bypass');
      gameState.addClue('firewall_bypass_unlocked');
    }
    // For now, we just print. Later this will navigate to the minigame.
    print("Login attempt detected! Minigame should be triggered from File Vault now.");
    Get.snackbar(
      "Access Denied",
      "Failed to log in. The firewall is too strong.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromARGB(255, 186, 81, 28),
      colorText: Colors.black,
      margin: const EdgeInsets.all(12),
      borderRadius: 4,
    );
  }
  
  @override
  void onClose() {
    searchController.dispose();
    usernameController.dispose();
    super.onClose();
  }
}