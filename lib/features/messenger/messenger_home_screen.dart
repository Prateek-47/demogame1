// lib/features/messenger/messenger_home_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
import '../../app/routes/app_pages.dart';

class MessengerHomeScreen extends StatelessWidget {
  final GameStateController gameState = Get.find<GameStateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Secure Messenger')),
      body: ListView.builder(
        itemCount: gameState.conversations.length,
        itemBuilder: (context, index) {
          final contactId = gameState.conversations.keys.elementAt(index);
          final conversation = gameState.conversations[contactId]!;
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(conversation.contactName),
            subtitle: Text(conversation.contactId),
            onTap: () {
              // Navigate to the specific chat screen, passing the contactId
              Get.toNamed(Routes.CHAT.replaceFirst(':contactId', contactId));
            },
          );
        },
      ),
    );
  }
}