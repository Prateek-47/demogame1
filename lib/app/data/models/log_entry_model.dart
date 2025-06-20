// lib/app/data/models/log_entry_model.dart

class LogEntry {
  final String id; // <-- ADD THIS ID PROPERTY
  final String timestamp;
  final String text;

  LogEntry({required this.id, required this.timestamp, required this.text});
}