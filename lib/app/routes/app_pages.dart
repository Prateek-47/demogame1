// lib/app/routes/app_pages.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart'; // Import material for Scaffold and AppBar
import '../../features/home/home_binding.dart';
import '../../features/home/home_screen.dart';
import '../../features/mission_log/mission_log_screen.dart'; // <-- 1. IMPORT OUR NEW SCREEN
import '../../features/database/database_screen.dart'; // <-- 1. IMPORT THE NEW SCREEN
import '../../features/database/database_binding.dart';
import '../../features/messenger/messenger_home_screen.dart';
import '../../features/messenger/chat_screen.dart';
import '../../features/messenger/messenger_binding.dart';
import '../../features/browser/browser_screen.dart';
import '../../features/browser/browser_binding.dart';
import '../../features/file_vault/file_vault_screen.dart';
import '../../features/file_vault/file_vault_binding.dart';
import '../../features/firewall_game/firewall_game_screen.dart';
import '../../features/firewall_game/firewall_game_binding.dart';
import '../../features/audio_game/audio_game_screen.dart';
import '../../features/audio_game/audio_game_binding.dart';


part 'app_routes.dart';

// --- Placeholder Screens for our Tools ---
// IMPORTANT: Each tool screen needs an AppBar so the user can navigate back.





class NewsfeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text('Newsfeed')), body: Center(child: Text('Newsfeed Screen')));
}
// -----------------------------------------


class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeScreen(),
      binding: HomeBinding(),
    ),
    // Add the routes for each tool
    GetPage(name: _Paths.MISSION_LOG, page: () => MissionLogScreen()),
    GetPage(
      name: _Paths.DATABASE,
      page: () => DatabaseScreen(),
      binding: DatabaseBinding(), // Use the real screen and binding
    ),
    GetPage(name: _Paths.MESSENGER, page: () => MessengerHomeScreen()),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatScreen(),
      binding: MessengerBinding(),
    ),
    GetPage(
      name: _Paths.FILE_VAULT,
      page: () => FileVaultScreen(),
      binding: FileVaultBinding(),
    ),
   GetPage(
      name: _Paths.BROWSER,
      page: () => BrowserScreen(),
      binding: BrowserBinding(),
    ),
    GetPage(name: _Paths.NEWSFEED, page: () => NewsfeedScreen()),
    GetPage(
      name: _Paths.FIREWALL_GAME,
      page: () => FirewallGameScreen(),
      binding: FirewallGameBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO_GAME,
      page: () => AudioGameScreen(),
      binding: AudioGameBinding(),
    ),
    
  ];
}