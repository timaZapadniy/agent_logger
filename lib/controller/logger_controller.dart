import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/log.dart';
import '../repository/log_repository.dart';

/// Controller for managing logger view state and actions
class LoggerController extends ChangeNotifier {
  final LogRepository _repository;

  LoggerController(this._repository) {
    _subscription = _repository.logsStream.listen((_) {
      notifyListeners();
    });
  }

  StreamSubscription<List<Log>>? _subscription;
  final Set<Log> _selectedLogs = {};
  String _searchQuery = '';

  /// Get filtered logs based on search query
  List<Log> get filteredLogs {
    if (_searchQuery.isEmpty) {
      return _repository.logs.reversed.toList();
    }
    return _repository.searchLogs(_searchQuery).reversed.toList();
  }

  /// Get all logs
  List<Log> get allLogs => _repository.logs;

  /// Get selected logs
  Set<Log> get selectedLogs => Set.unmodifiable(_selectedLogs);

  /// Check if log is selected
  bool isSelected(Log log) => _selectedLogs.contains(log);

  /// Check if any logs are selected
  bool get hasSelection => _selectedLogs.isNotEmpty;

  /// Toggle log selection
  void toggleSelection(Log log) {
    if (_selectedLogs.contains(log)) {
      _selectedLogs.remove(log);
    } else {
      _selectedLogs.add(log);
    }
    notifyListeners();
  }

  /// Clear selection
  void clearSelection() {
    _selectedLogs.clear();
    notifyListeners();
  }

  /// Search logs
  void search(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Export selected logs or all logs to file and share
  Future<ShareResult> exportAndShare() async {
    final logsToExport =
        _selectedLogs.isNotEmpty ? _selectedLogs.toList() : allLogs;
    final filePath = await _writeLogsToFile(logsToExport);
    final result = await Share.shareXFiles([XFile(filePath)], text: 'Logs');
    return result;
  }

  /// Share single log as text
  Future<ShareResult> shareLog(Log log) async {
    return await Share.share(
      '${_formatDateTime(log.time!)}\n${log.message}',
      subject: 'Log Entry',
    );
  }

  /// Write logs to file
  Future<String> _writeLogsToFile(List<Log> logs) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String fileName =
        'log_${DateFormat('dd-MM-yyyy_HH-mm-ss').format(DateTime.now())}.txt';
    final File file = File('${directory.path}/$fileName');

    final StringBuffer buffer = StringBuffer();
    for (final log in logs) {
      buffer.writeln();
      buffer.writeln('(${_formatDateTime(log.time!)}) ${log.message}');
      if (log.error != null) {
        buffer.writeln('Error: ${log.error}');
      }
      if (log.stackTrace != null) {
        buffer.writeln('StackTrace: ${log.stackTrace}');
      }
    }

    await file.writeAsString(buffer.toString());
    return file.path;
  }

  /// Format date time for display
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd:MM:yyyy – kk:mm:ss').format(dateTime);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
