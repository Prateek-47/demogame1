// lib/app/data/models/dialogue_model.dart

// An enum to identify who is speaking
enum Speaker { player, lena }

// Represents a choice the player can make
class DialogueChoice {
  final String text;
  final String nextNodeId; // The ID of the node to go to if this is chosen

  DialogueChoice({required this.text, required this.nextNodeId});
}

// Represents one "piece" of dialogue in the conversation tree
class DialogueNode {
  final String id;
  final Speaker speaker;
  final String text;
  final List<DialogueChoice> choices;
  final String? triggerClue; // Optional: a clue to unlock when this node is reached

  DialogueNode({
    required this.id,
    required this.speaker,
    required this.text,
    this.choices = const [],
    this.triggerClue,
  });
}

// Represents an entire conversation with a contact
class Conversation {
  final String contactId;
  final String contactName;
  final String startNodeId;
  final Map<String, DialogueNode> nodes;

  Conversation({
    required this.contactId,
    required this.contactName,
    required this.startNodeId,
    required this.nodes,
  });
}