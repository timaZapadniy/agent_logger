import 'package:agent_logger/shake.dart';
import 'package:flutter/material.dart';

import 'view/logger_view.dart';

/// Main widget that wraps your app and provides logger functionality
class AgentLogger extends StatefulWidget {
  /// The root widget of your app
  final Widget child;

  /// Enable or disable shake detection
  final bool enable;

  /// Shake detection sensitivity (lower = more sensitive)
  final double shakeThresholdGravity;

  const AgentLogger({
    super.key,
    required this.child,
    this.enable = true,
    this.shakeThresholdGravity = 2.7,
  });

  @override
  AgentLoggerState createState() => AgentLoggerState();
}

class AgentLoggerState extends State<AgentLogger> {
  bool _openLog = false;
  ShakeDetector? _detector;

  @override
  void initState() {
    super.initState();
    if (widget.enable) {
      _initializeShakeDetector();
    }
  }

  @override
  void didUpdateWidget(AgentLogger oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enable != oldWidget.enable) {
      if (widget.enable) {
        _initializeShakeDetector();
      } else {
        _disposeShakeDetector();
      }
    }
  }

  @override
  void dispose() {
    _disposeShakeDetector();
    super.dispose();
  }

  void _initializeShakeDetector() {
    _detector = ShakeDetector.waitForStart(
      onPhoneShake: _onShakeDetected,
      shakeThresholdGravity: widget.shakeThresholdGravity,
    );
    _detector?.startListening();
  }

  void _disposeShakeDetector() {
    _detector?.stopListening();
    _detector = null;
  }

  void _onShakeDetected() {
    if (!_openLog && mounted) {
      setState(() {
        _openLog = true;
      });
    }
  }

  void closeLogger() {
    if (_openLog && mounted) {
      setState(() {
        _openLog = false;
      });
    }
  }

  void openLogger() {
    if (!_openLog && mounted) {
      setState(() {
        _openLog = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enable) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        if (_openLog)
          LoggerView(
            onTap: closeLogger,
          ),
      ],
    );
  }
}
