// lib/features/firewall_game/firewall_game_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firewall_game_logic.dart';

class FirewallGameScreen extends GetView<FirewallGameController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bypass In Progress...")),
      body: Center(
        child: GestureDetector(
          onPanStart: (details) => controller.onPanStart(details.localPosition),
          onPanUpdate: (details) => controller.onPanUpdate(details.localPosition),
          onPanEnd: (_) => controller.onPanEnd(),
          child: Container(
            width: controller.cell_size * 4,
            height: controller.cell_size * 5,
            color: Colors.black54,
            // REPLACE Obx with GetBuilder
            child: GetBuilder<FirewallGameController>(
              builder: (controller) => CustomPaint(
                painter: FirewallPainter(
                  nodes: controller.nodes,
                  playerPath: controller.playerPath,
                  nodeRadius: controller.nodeRadius,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}