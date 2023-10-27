// library agent_logger;

import 'package:agent_logger/shake.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'buffer_output.dart';

class AgentLogger extends StatefulWidget {
  /// The first widget in metrial app.
  final Widget child;

  AgentLogger({Key? key, required this.child}) : super(key: key);

  final logger = Logger(output: BufferOutput());
  Widget build(
    BuildContext context,
    AgentLoggerState state, {
    bool openLog = false,
  }) {
    return Stack(
      children: [
        child,
        if (openLog)
          Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () => state.closeLogger(),
                  child: const Icon(Icons.close)),
            ),
            body: Center(
              child: Text('${BufferOutput().lines}'),
            ),
          )
      ],
    );
  }

  @override
  AgentLoggerState createState() => AgentLoggerState();
  void i(String message) {
    logger.i(message);
  }
}

class AgentLoggerState extends State<AgentLogger> {
  bool openLog = false;
  late ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) =>
      widget.build(context, this, openLog: openLog);

  void initialize() {
    detector = ShakeDetector.waitForStart(onPhoneShake: () {
      debugPrint('test');
      setState(() {
        openLog = true;
      });
    });
    detector.startListening();
  }

  void closeLogger() => setState(() {
        openLog = false;
      });
}
