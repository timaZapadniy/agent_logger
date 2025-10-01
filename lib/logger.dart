import 'package:agent_logger/models/log.dart';
import 'package:agent_logger/repository/log_repository.dart';
import 'package:logger/logger.dart';

import 'buffer_output.dart';

/// Custom logger implementation that stores logs in repository
class LoggerWriter extends Logger {
  static final LoggerWriter _instance = LoggerWriter._internal();

  factory LoggerWriter() => _instance;

  final LogRepository _repository = LogRepository();
  bool _isClosed = false;

  LoggerWriter._internal() : super(output: BufferOutput());

  /// Add log to repository and call parent logger
  void _addLog(
    Level level,
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (_isClosed) return;

    final logTime = time ?? DateTime.now();
    _repository.addLog(Log(
      message: message.toString(),
      level: level,
      time: logTime,
      error: error,
      stackTrace: stackTrace,
    ));
  }

  @override
  void d(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.debug, message,
        time: time, error: error, stackTrace: stackTrace);
    super.d(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void e(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.error, message,
        time: time, error: error, stackTrace: stackTrace);
    super.e(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void f(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.fatal, message,
        time: time, error: error, stackTrace: stackTrace);
    super.f(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void i(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.info, message,
        time: time, error: error, stackTrace: stackTrace);
    super.i(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void t(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.trace, message,
        time: time, error: error, stackTrace: stackTrace);
    super.t(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  @Deprecated('Use [t] instead of [v] for trace logs')
  void v(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.trace, message,
        time: time, error: error, stackTrace: stackTrace);
    super.v(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void w(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.warning, message,
        time: time, error: error, stackTrace: stackTrace);
    super.w(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  @Deprecated('Use [f] instead of [wtf] for fatal logs')
  void wtf(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(Level.fatal, message,
        time: time, error: error, stackTrace: stackTrace);
    super.wtf(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void log(Level level, message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    _addLog(level, message, time: time, error: error, stackTrace: stackTrace);
    super.log(level, message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  Future<void> close() async {
    _isClosed = true;
    await super.close();
  }

  @override
  bool isClosed() => _isClosed;

  /// Clear all logs from repository
  void clearLogs() {
    _repository.clear();
  }
}
