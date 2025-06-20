// lib/features/home/home_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tool_model.dart';
import '../../app/routes/app_pages.dart';

class HomeController extends GetxController {
  // This list defines all the tools available on our OS home screen.
  final List<Tool> tools = [
    Tool(name: 'Mission Log', icon: Icons.article_outlined, route: Routes.MISSION_LOG),
    Tool(name: 'Database', icon: Icons.storage_outlined, route: Routes.DATABASE),
    Tool(name: 'Messenger', icon: Icons.message_outlined, route: Routes.MESSENGER),
    Tool(name: 'File Vault', icon: Icons.folder_special_outlined, route: Routes.FILE_VAULT),
    Tool(name: 'Browser', icon: Icons.public_outlined, route: Routes.BROWSER),
    Tool(name: 'Newsfeed', icon: Icons.newspaper_outlined, route: Routes.NEWSFEED),
  ];
}