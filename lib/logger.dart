import 'package:agent_logger/models/log.dart';
import 'package:logger/logger.dart';

import 'buffer_output.dart';

class LoggerWriter extends Logger {
  static final LoggerWriter _instance = LoggerWriter._internal();

  factory LoggerWriter() {
    return _instance;
  }
  LoggerWriter._internal() {
    // initialization logic
  }
  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  void d(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.d(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void e(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.e(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void f(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.f(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void i(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.i(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  bool isClosed() {
    // TODO: implement isClosed
    throw UnimplementedError();
  }

  @override
  void log(Level level, message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    super.log(level, message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void t(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.t(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void v(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.v(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void w(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.w(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }

  @override
  void wtf(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(Log(
        message: message,
        time: time ?? DateTime.now(),
        error: error,
        stackTrace: stackTrace));
    super.wtf(message,
        time: time ?? DateTime.now(), error: error, stackTrace: stackTrace);
  }
}
