// lib/features/firewall_game/firewall_game_logic.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
//import '../../app/data/models/file_model.dart';
import '../browser/browser_controller.dart';

// --- Data Models for the Game ---
enum NodeType { start, end, neutral, hostile }

class FirewallNode {
  final int id;
  final Offset position;
  final NodeType type;
  FirewallNode({required this.id, required this.position, required this.type});
}

// --- The Game Controller ---
class FirewallGameController extends GetxController {
  final GameStateController gameState = Get.find();
  final nodes = <FirewallNode>[].obs;
  final playerPath = <Offset>[].obs;
  final playerNodePath = <int>[].obs; // track node IDs
  
  final int gridSize = 6;
  final double nodeRadius = 20.0;
  final double cell_size = 60.0;

  @override
  void onInit() {
    super.onInit();
    _generateGrid();
  }

  void _generateGrid() {
    // Generate a simple, static grid for the puzzle
    nodes.assignAll([
      FirewallNode(id: 0, position: Offset(cell_size * 1, cell_size * 1), type: NodeType.start),
      FirewallNode(id: 1, position: Offset(cell_size * 2, cell_size * 1), type: NodeType.neutral),
      FirewallNode(id: 2, position: Offset(cell_size * 3, cell_size * 1), type: NodeType.hostile),
      FirewallNode(id: 3, position: Offset(cell_size * 1, cell_size * 2), type: NodeType.neutral),
      FirewallNode(id: 4, position: Offset(cell_size * 2, cell_size * 2), type: NodeType.neutral),
      FirewallNode(id: 5, position: Offset(cell_size * 3, cell_size * 2), type: NodeType.neutral),
      FirewallNode(id: 6, position: Offset(cell_size * 1, cell_size * 3), type: NodeType.hostile),
      FirewallNode(id: 7, position: Offset(cell_size * 2, cell_size * 3), type: NodeType.neutral),
      FirewallNode(id: 8, position: Offset(cell_size * 3, cell_size * 3), type: NodeType.neutral),
      FirewallNode(id: 9, position: Offset(cell_size * 1, cell_size * 4), type: NodeType.neutral),
      FirewallNode(id: 10, position: Offset(cell_size * 2, cell_size * 4), type: NodeType.hostile),
      FirewallNode(id: 11, position: Offset(cell_size * 3, cell_size * 4), type: NodeType.end),
    ]);
  }

  void onPanStart(Offset details) {
    playerPath.clear();
    playerNodePath.clear();
    _updatePath(details);
    update(); // <-- ADD THIS
  }

  void onPanEnd() {
    final endNode = nodes.firstWhere((n) => n.type == NodeType.end);
    if (playerNodePath.isNotEmpty && playerNodePath.last == endNode.id) {
      _onGameWon();
    } else {
      playerPath.clear();
      playerNodePath.clear();
      update(); // <-- ADD THIS
    }
  }

  void _updatePath(Offset currentPosition) {
    // ... (no change needed inside the for loop itself) ...
    // The existing logic already modifies the RxList, which is fine.
    // The important part is calling update() after the gesture is processed.
    for (var node in nodes) {
      if ((currentPosition - node.position).distance <= nodeRadius && !playerNodePath.contains(node.id)) {
        if (node.type == NodeType.hostile) {
           playerPath.clear();
           playerNodePath.clear();
           break;
        }
        playerPath.add(node.position);
        playerNodePath.add(node.id);
      }
    }
    update(); // <-- ADD THIS AT THE END OF THE METHOD
  }
  void onPanUpdate(Offset details) {
    _updatePath(details);
  }

   void _onGameWon() {
    // This now shows a styled snackbar at the top of the screen.
    Get.snackbar(
      "Firewall Breached",
      "Success! Accessing account data...",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green[600],
      colorText: Colors.black,
      margin: const EdgeInsets.all(12),
      borderRadius: 4,
    );

    // Update the global game state as before
    gameState.addClue('gilded_cage_accessed');
    gameState.unlockFile('note_for_lb');

    // Delay the screen closing to allow the snackbar to be seen.
    // A duration of 2 seconds is usually a good amount of time.
    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close the minigame screen AFTER the delay
    });
  }
}

// --- The Custom Painter ---
class FirewallPainter extends CustomPainter {
  final List<FirewallNode> nodes;
  final List<Offset> playerPath;
  final double nodeRadius;

  FirewallPainter({required this.nodes, required this.playerPath, required this.nodeRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint();
    final pathPaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Draw nodes
    for (var node in nodes) {
      switch (node.type) {
        case NodeType.start:
          nodePaint.color = Colors.blue;
          break;
        case NodeType.end:
          nodePaint.color = Colors.green;
          break;
        case NodeType.hostile:
          nodePaint.color = Colors.red;
          break;
        case NodeType.neutral:
          nodePaint.color = Colors.grey;
          break;
      }
      canvas.drawCircle(node.position, nodeRadius, nodePaint);
    }

    // Draw player path
    if (playerPath.length > 1) {
      for (int i = 0; i < playerPath.length - 1; i++) {
        canvas.drawLine(playerPath[i], playerPath[i+1], pathPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}