// lib/features/messenger/messenger_controller.dart

import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
import '../../app/data/models/dialogue_model.dart';

class MessengerController extends GetxController {
  final GameStateController gameState = Get.find<GameStateController>();
  late final Conversation conversation;

  final history = <DialogueNode>[].obs;
  final currentNode = Rxn<DialogueNode>();

  @override
  void onInit() {
    super.onInit();
    String contactId = Get.parameters['contactId']!;
    conversation = gameState.conversations[contactId]!;
    
    // Start the conversation by showing the first node from Lena
    _processNode(conversation.startNodeId);
  }

  // This is the NEW, corrected logic for handling a player's choice.
  void selectChoice(DialogueChoice choice) {
    // 1. Immediately add the player's choice as a message to the history.
    final playerMessageNode = DialogueNode(
      id: 'player_choice_${DateTime.now().millisecondsSinceEpoch}', // Unique temp ID
      speaker: Speaker.player,
      text: choice.text,
    );
    history.add(playerMessageNode);

    // 2. Clear the current choices from the UI by setting a node with no choices.
    currentNode.value = playerMessageNode; 

    // 3. After a short delay, process and show Lena's response.
    Future.delayed(const Duration(milliseconds: 800), () {
      _processNode(choice.nextNodeId);
    });
  }

  // This is a simplified helper method to process and display the next node.
  void _processNode(String nodeId) {
    final nodeToShow = conversation.nodes[nodeId];
    if (nodeToShow == null) return; // Failsafe

    // Add the new node from Lena to the history
    history.add(nodeToShow);
    // Set it as the current node to display its text and any new choices
    currentNode.value = nodeToShow;

    // Check if reaching this node triggers a new clue
    if (nodeToShow.triggerClue != null && !gameState.unlockedClueIds.contains(nodeToShow.triggerClue!)) {
      gameState.addClue(nodeToShow.triggerClue!);
      gameState.addLogEntry(
        '23:01',
        'Contact with Petrova lost. She is a dead end for now. New keywords acquired: "Gilded Cage," "Little Bird." Her fear suggests OmniCorp is involved. Find the cage.',
      );
    }
  }
}