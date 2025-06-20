// lib/features/database/database_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';

// 1. Add the 'loading' state to our enum
enum SearchStatus { initial, loading, notFound, found }

class DatabaseController extends GetxController {
  final GameStateController gameState = Get.find<GameStateController>();
  late TextEditingController textEditingController;
  final searchStatus = SearchStatus.initial.obs;

  @override
  void onInit() {
    super.onInit();
    textEditingController = TextEditingController();
  }

  void performSearch() {
    String query = textEditingController.text.toLowerCase().trim();

    // 2. Set the state to loading immediately when the search begins
    searchStatus.value = SearchStatus.loading;

    // 3. Simulate a 2-second network/database delay
    Future.delayed(const Duration(seconds: 2), () {
      // 4. The original search logic now goes inside the delay
      if (query.contains('lena petrova')) {
        searchStatus.value = SearchStatus.found;
        if (!gameState.unlockedClueIds.contains('petrova_dossier')) {
          gameState.addClue('petrova_dossier');
          gameState.addLogEntry(
            '22:10',
            'Intel acquired. Dossier found for L. Petrova. Secure contact number acquired: LPetrova_84. Awaiting your initiative.',
          );
        }
      } else {
        searchStatus.value = SearchStatus.notFound;
      }
    });
  }

  @override
  void onClose() {
    textEditingController.dispose();
    super.onClose();
  }
}