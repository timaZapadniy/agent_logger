import 'package:agent_logger/models/log.dart';
import 'package:firebase_dart/firebase_dart.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:logger/logger.dart';
import 'package:firebase_dart/firebase_dart.dart' as firebase;
import 'buffer_output.dart';

class LoggerWriter extends Logger {
  final FirebaseOptions? firebaseOptions;
  static LoggerWriter _instance(firebaseOptions) {
    return LoggerWriter._internal(firebaseOptions);
  }

  factory LoggerWriter({firebaseOptions = null}) {
    return _instance(firebaseOptions);
  }
  LoggerWriter._internal(this.firebaseOptions) {
    if (firebaseOptions != null) initFirebase(firebaseOptions!);
  }
  Future<void> initFirebase(FirebaseOptions options) async {
    firebase.FirebaseDart.setup();

    var app = await firebase.Firebase.initializeApp(options: options);

    Firestore.initialize(options.projectId);
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
    if (firebaseOptions != null) {
      var _i =
          Firestore.instance.collection('deviceLogs').document('test').set({
        'message': message,
        'time': time ?? DateTime.now(),
        'error': error,
        'stackTrace': stackTrace
      });
    }

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
