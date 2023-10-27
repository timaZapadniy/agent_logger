// library agent_logger;

import 'package:agent_logger/shake.dart';
import 'package:flutter/material.dart';

import 'logger.dart';
import 'view/logger_view.dart';

class AgentLogger extends StatefulWidget {
  /// The first widget in metrial app.
  final Widget child;
  final bool enable;
  AgentLogger({Key? key, required this.child, this.enable = true})
      : super(key: key);

  final logger = LoggerWriter();
  Widget build(
    BuildContext context,
    AgentLoggerState state, {
    bool openLog = false,
  }) {
    return enable
        ? Stack(
            children: [
              child,
              if (openLog)
                LoggerView(
                  onTap: () {
                    state.closeLogger();
                  },
                )
            ],
          )
        : child;
  }

  @override
  AgentLoggerState createState() => AgentLoggerState();
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
