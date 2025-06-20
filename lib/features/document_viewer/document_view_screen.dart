// lib/features/document_viewer/document_view_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
import '../../app/data/models/file_model.dart';

class DocumentViewScreen extends StatelessWidget {
  final GameStateController gameState = Get.find();

  @override
  Widget build(BuildContext context) {
    final dynamic fileIdArg = Get.arguments;
    
    print('Navigated to DocumentViewScreen with argument: $fileIdArg');

    GameFile? file;
    Widget bodyContent;

    if (fileIdArg is String) {
      file = gameState.getFileById(fileIdArg);
      if (file != null) {
        bodyContent = Text(
          file.content,
          // --- THIS IS THE ONLY CHANGE ---
          // We are explicitly setting a visible color for the text.
          style: TextStyle(
            color: Colors.green[200], // Set text color to a light green
            height: 1.6,
            fontFamily: 'monospace',
          ),
        );
      } else {
        bodyContent = Center(
          child: Text(
            'DEBUG: File not found for ID: "$fileIdArg"\n\nPlease check the \'id\' in GameStateController.dart.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        );
      }
    } else {
      bodyContent = const Center(
        child: Text(
          'DEBUG: No file ID was passed to this screen.\n\nPlease check the Get.toNamed() call in FileVaultController.dart.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(file?.fileName ?? 'Document Viewer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: const Color(0xFF1F1F1F),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: bodyContent,
          ),
        ),
      ),
    );
  }
}