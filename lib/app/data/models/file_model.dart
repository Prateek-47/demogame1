// lib/app/data/models/file_model.dart

// An enum to represent the different types of files for easy filtering
// and for showing the correct icon in the UI.
enum FileType {
  dossier,
  executable,
  audio,
  geolink,
  pdf,
  report,
}

class GameFile {
  final String id;
  final String fileName;
  final FileType type;
  final String content; // Could be a description, a URL, or file path
  final String? password; // The password to unlock the file, if any
  bool isLocked;

  GameFile({
    required this.id,
    required this.fileName,
    required this.type,
    this.content = '',
    this.password,
    this.isLocked = true,
  });
}