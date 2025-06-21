// lib/app/routes/app_routes.dart

part of 'app_pages.dart';

abstract class Routes {
   static const SPLASH = _Paths.SPLASH; 
   static const LOGIN = _Paths.LOGIN; // <-- ADD THIS
  static const HOME = _Paths.HOME;
  static const MISSION_LOG = _Paths.MISSION_LOG;
  static const DATABASE = _Paths.DATABASE;
  static const MESSENGER = _Paths.MESSENGER;
  static const FILE_VAULT = _Paths.FILE_VAULT;
  static const BROWSER = _Paths.BROWSER;
  static const NEWSFEED = _Paths.NEWSFEED;
  static const CHAT = _Paths.CHAT;
  static const FIREWALL_GAME = _Paths.FIREWALL_GAME; 
  static const AUDIO_GAME = _Paths.AUDIO_GAME;
  
}

abstract class _Paths {
  static const SPLASH = '/splash'; // <-- ADD THIS
  static const LOGIN = '/login'; // <-- ADD THIS
  static const HOME = '/home';
  static const MISSION_LOG = '/mission-log';
  static const DATABASE = '/database';
  static const MESSENGER = '/messenger';
  static const FILE_VAULT = '/file-vault';
  static const BROWSER = '/browser';
  static const NEWSFEED = '/newsfeed';
  static const CHAT = '/messenger/:contactId'; 
  static const FIREWALL_GAME = '/firewall-game';
  static const AUDIO_GAME = '/audio-game';
 
}