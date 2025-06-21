// lib/features/file_vault/file_vault_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/game_state_controller.dart';
import '../../app/data/models/file_model.dart';
import 'file_vault_controller.dart';

class FileVaultScreen extends GetView<FileVaultController> {
  final GameStateController gameState = Get.find();

  // Map file types to specific icons
  final Map<FileType, IconData> _iconMap = {
    FileType.dossier: Icons.person_search,
    FileType.executable: Icons.code,
    FileType.audio: Icons.graphic_eq,
    FileType.geolink: Icons.map_outlined,
    FileType.pdf: Icons.picture_as_pdf,
    FileType.report: Icons.assessment,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("File Vault")),
      body: Obx(
        () => GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: gameState.allGameFiles.length,
          itemBuilder: (context, index) {
            final file = gameState.allGameFiles[index];
            return _FileIcon(
              file: file,
              icon: _iconMap[file.type] ?? Icons.insert_drive_file,
              onTap: () => controller.handleFileTap(file),
            );
          },
        ),
      ),
    );
  }
}

// A private widget for styling each file icon
class _FileIcon extends StatelessWidget {
  final GameFile file;
  final IconData icon;
  final VoidCallback onTap;

  const _FileIcon({required this.file, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = file.isLocked ? Colors.grey[700] : Get.theme.primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(file.isLocked ? Icons.lock_outline : icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            file.fileName,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: color),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}