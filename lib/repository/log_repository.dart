import 'dart:async';
import 'package:logger/logger.dart';
import '../models/log.dart';

/// Repository for managing logs in a centralized and thread-safe way
class LogRepository {
  static final LogRepository _instance = LogRepository._internal();

  factory LogRepository() => _instance;

  LogRepository._internal();

  final List<Log> _logs = [];
  final _logsController = StreamController<List<Log>>.broadcast();

  /// Stream of logs for reactive updates
  Stream<List<Log>> get logsStream => _logsController.stream;

  /// Get all logs
  List<Log> get logs => List.unmodifiable(_logs);

  /// Get logs count
  int get count => _logs.length;

  /// Add a new log entry
  void addLog(Log log) {
    _logs.add(log);
    _logsController.add(List.unmodifiable(_logs));
  }

  /// Clear all logs
  void clear() {
    _logs.clear();
    _logsController.add(List.unmodifiable(_logs));
  }

  /// Search logs by query
  List<Log> searchLogs(String query) {
    if (query.isEmpty) return logs;
    return _logs
        .where((log) =>
            log.message.toLowerCase().contains(query.toLowerCase()) ||
            (log.error
                    ?.toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false))
        .toList();
  }

  /// Get logs by level
  List<Log> getLogsByLevel(Level? level) {
    if (level == null) return logs;
    return _logs.where((log) => log.level == level).toList();
  }

  /// Dispose resources
  void dispose() {
    _logsController.close();
  }
}
