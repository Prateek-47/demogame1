// lib/features/messenger/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'messenger_controller.dart';
import '../../app/data/models/dialogue_model.dart';

class ChatScreen extends GetView<MessengerController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.conversation.contactName)),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: controller.history.length,
                itemBuilder: (context, index) {
                  final node = controller.history[index];
                  return _ChatBubble(node: node);
                },
              ),
            ),
          ),
          Obx(() => _PlayerChoices(node: controller.currentNode.value)),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final DialogueNode node;
  const _ChatBubble({required this.node});

  @override
  Widget build(BuildContext context) {
    bool isPlayer = node.speaker == Speaker.player;
    return Align(
      alignment: isPlayer ? Alignment.centerRight : Alignment.centerLeft,
      child: Card(
        color: isPlayer ? Colors.green : const Color(0xFF2A2A2A),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            node.text,
            style: TextStyle(color: isPlayer ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}

class _PlayerChoices extends StatelessWidget {
  final DialogueNode? node;
  const _PlayerChoices({required this.node});

  @override
  Widget build(BuildContext context) {
    if (node == null || node!.choices.isEmpty) {
      return const SizedBox.shrink(); // No choices, show nothing
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: node!.choices.map((choice) {
          return ElevatedButton(
            onPressed: () => Get.find<MessengerController>().selectChoice(choice),
            child: Text(choice.text),
          );
        }).toList(),
      ),
    );
  }
}