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
  void d(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {}

  @override
  void e(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement e
  }

  @override
  void f(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement f
  }

  @override
  void i(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    BufferOutput().lines.add(message);
    super.i(message, time: time, error: error, stackTrace: stackTrace);
  }

  @override
  bool isClosed() {
    // TODO: implement isClosed
    throw UnimplementedError();
  }

  @override
  void log(Level level, message,
      {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement log
  }

  @override
  void t(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement t
  }

  @override
  void v(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement v
  }

  @override
  void w(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement w
  }

  @override
  void wtf(message, {DateTime? time, Object? error, StackTrace? stackTrace}) {
    // TODO: implement wtf
  }
}
