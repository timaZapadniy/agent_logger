import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/log.dart';
import '../repository/log_repository.dart';

/// Service for sending logs to remote web client
class RemoteLoggerService {
  static final RemoteLoggerService _instance = RemoteLoggerService._internal();
  factory RemoteLoggerService() => _instance;
  RemoteLoggerService._internal();

  WebSocketChannel? _channel;
  bool _isConnected = false;
  String? _sessionId;
  String? _deviceId;
  StreamSubscription<Log>? _logsSubscription;

  /// Connection status
  bool get isConnected => _isConnected;

  /// Session ID
  String? get sessionId => _sessionId;

  /// Connect to remote web client
  Future<bool> connect(String wsUrl, String deviceId) async {
    try {
      disconnect(); // Disconnect if already connected

      _deviceId = deviceId;
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Send connect message
      _sendMessage({
        'type': 'connect',
        'deviceId': deviceId,
      });

      // Note: RemoteLoggerService is not used in current implementation
      // P2PServer handles log forwarding instead

      // Also send existing logs
      for (final log in LogRepository().logs) {
        _sendLog(log);
      }

      _isConnected = true;

      // Listen for errors
      _channel!.stream.listen(
        null,
        onError: (_) => disconnect(),
        onDone: disconnect,
      );

      return true;
    } catch (e) {
      print('Failed to connect to remote logger: $e');
      disconnect();
      return false;
    }
  }

  /// Send a log message to the web client
  void _sendLog(Log log) {
    if (!_isConnected || _channel == null) return;

    try {
      final message = {
        'type': 'log',
        'data': {
          'message': log.message,
          'level': log.level?.toString().split('.').last,
          'timestamp':
              log.time?.toIso8601String() ?? DateTime.now().toIso8601String(),
          'error': log.error?.toString(),
          'stackTrace': log.stackTrace?.toString(),
          'deviceId': _deviceId ?? 'unknown',
        },
      };

      _sendMessage(message);
    } catch (e) {
      print('Error sending log: $e');
    }
  }

  /// Send a message through WebSocket
  void _sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      try {
        _channel!.sink.add(json.encode(message));
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  /// Disconnect from remote web client
  void disconnect() {
    _logsSubscription?.cancel();
    _logsSubscription = null;

    if (_channel != null) {
      _sendMessage({'type': 'disconnect'});
      _channel?.sink.close();
      _channel = null;
    }

    _isConnected = false;
    _sessionId = null;
    _deviceId = null;
  }

  /// Dispose resources
  void dispose() {
    disconnect();
  }
}
