import 'package:agent_logger/models/log.dart';
import 'package:logger/logger.dart';

class BufferOutput extends LogOutput {
  ///Logs list.
  final lines = <Log>[];
  static final BufferOutput _instance = BufferOutput._internal();

  factory BufferOutput() {
    return _instance;
  }
  BufferOutput._internal() {
    // initialization logic
  }
  @override
  void output(OutputEvent event) {
    // Output is handled by the UI through LogRepository
    // No console output needed here
  }
}
