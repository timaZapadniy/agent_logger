import 'package:logger/logger.dart';

class BufferOutput extends LogOutput {
  ///Logs list.
  final lines = <String>[];
  static final BufferOutput _instance = BufferOutput._internal();

  factory BufferOutput() {
    return _instance;
  }
  BufferOutput._internal() {
    // initialization logic
  }
  @override
  void output(OutputEvent event) {
    lines.addAll(event.lines);
    // for (var line in event.lines) {
    //   // print(line);
    // }
  }
}
