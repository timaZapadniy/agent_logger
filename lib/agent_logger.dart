import 'package:agent_logger/shake.dart';
import 'package:flutter/material.dart';

import 'services/p2p_server.dart';
import 'view/logger_view.dart';
import 'utils/config_helper.dart';

// P2P Relay Server configuration
String get _p2pServerUrl => ConfigHelper.getP2PServerUrl();

/// Main widget that wraps your app and provides logger functionality
class AgentLogger extends StatefulWidget {
  /// The root widget of your app
  final Widget child;

  /// Enable or disable shake detection
  final bool enable;

  /// Enable or disable P2P server functionality
  final bool enableP2P;

  /// Shake detection sensitivity (lower = more sensitive)
  final double shakeThresholdGravity;

  const AgentLogger({
    super.key,
    required this.child,
    this.enable = true,
    this.enableP2P = true,
    this.shakeThresholdGravity = 2.7,
  });

  @override
  AgentLoggerState createState() => AgentLoggerState();
}

class AgentLoggerState extends State<AgentLogger> {
  bool _openLog = false;
  ShakeDetector? _detector;
  final P2PServer _p2pServer = P2PServer();

  @override
  void initState() {
    super.initState();
    if (widget.enable) {
      _initializeShakeDetector();
    }
    // Запускаем P2P сервер при инициализации
    _startP2PServer();
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
    // Останавливаем P2P сервер только при полном закрытии приложения
    _p2pServer.stop();
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

  Future<void> _startP2PServer() async {
    // Only start P2P server if enabled
    if (!widget.enableP2P) {
      debugPrint('P2P Server: Disabled by configuration');
      return;
    }

    debugPrint('P2P Server: Starting with URL: $_p2pServerUrl');
    final success = await _p2pServer.start(relayServerUrl: _p2pServerUrl);
    debugPrint('P2P Server: Start result: $success');

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('P2P Server connected to ${_p2pServerUrl}'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to connect to P2P Server: ${_p2pServerUrl}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
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
        // Индикатор P2P сервера в углу экрана
        if (widget.enableP2P && _p2pServer.isRunning)
          Positioned(
            top: 50,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_tethering,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'P2P: ${_p2pServer.clientsCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (_openLog)
          LoggerView(
            onTap: closeLogger,
            p2pServer: widget.enableP2P ? _p2pServer : null,
          ),
      ],
    );
  }
}
