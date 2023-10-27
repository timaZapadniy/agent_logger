// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:logger/logger.dart';

class Log {
  String message;
  Level? level;
  DateTime? time;
  Object? error;
  StackTrace? stackTrace;
  Log({
    required this.message,
    this.level,
    this.time,
    this.error,
    this.stackTrace,
  });

  Log copyWith({
    String? message,
    Level? level,
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    return Log(
      message: message ?? this.message,
      level: level ?? this.level,
      time: time ?? this.time,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'level': level,
      'time': time?.millisecondsSinceEpoch,
      'error': error,
      'stackTrace': stackTrace,
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
      message: map['message'] as String,
      level: map['level'] != null ? map['level'] : null,
      time: map['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['time'] as int)
          : null,
      error: map['error'] != null ? map['error'] : null,
      stackTrace: map['stackTrace'] != null ? map['stackTrace'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Log.fromJson(String source) =>
      Log.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Log(message: $message, level: $level, time: $time, error: $error, stackTrace: $stackTrace)';
  }

  @override
  bool operator ==(covariant Log other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.level == level &&
        other.time == time &&
        other.error == error &&
        other.stackTrace == stackTrace;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        level.hashCode ^
        time.hashCode ^
        error.hashCode ^
        stackTrace.hashCode;
  }
}
