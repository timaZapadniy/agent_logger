import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/log.dart';
import '../repository/log_repository.dart';

/// P2P Server for direct connection between mobile and web
class P2PServer {
  static final P2PServer _instance = P2PServer._internal();
  factory P2PServer() => _instance;
  P2PServer._internal();

  HttpServer? _server;
  final List<WebSocket> _clients = [];
  final NetworkInfo _networkInfo = NetworkInfo();
  String? _serverUrl;
  StreamSubscription<Log>? _logsSubscription;

  /// Server status
  bool get isRunning => _server != null;

  /// Server URL
  String? get serverUrl => _serverUrl;

  /// Number of connected clients
  int get clientsCount => _clients.length;

  /// Start P2P server
  Future<bool> start() async {
    if (isRunning) return true;

    try {
      // Get local IP address
      final wifiIP = await _networkInfo.getWifiIP();
      if (wifiIP == null) {
        print('Could not get WiFi IP address');
        return false;
      }

      // Start HTTP server
      _server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      final port = _server!.port;
      _serverUrl = 'http://$wifiIP:$port';

      // Handle WebSocket connections
      _server!.listen((HttpRequest request) {
        if (request.uri.path == '/ws') {
          WebSocketTransformer.upgrade(request).then((WebSocket webSocket) {
            _handleNewClient(webSocket);
          });
        } else {
          // Serve simple HTML page for testing
          request.response
            ..statusCode = 200
            ..headers.contentType = ContentType.html
            ..write('''
<!DOCTYPE html>
<html>
<head>
    <title>Agent Logger Web Client</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { max-width: 600px; margin: 0 auto; }
        .log { background: #f5f5f5; padding: 10px; margin: 5px 0; border-radius: 4px; }
        .error { background: #ffebee; border-left: 4px solid #f44336; }
        .info { background: #e8f5e8; border-left: 4px solid #4caf50; }
        .debug { background: #e3f2fd; border-left: 4px solid #2196f3; }
        .warning { background: #fff3e0; border-left: 4px solid #ff9800; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Agent Logger - Web Client</h1>
        <p>Connected to mobile device. Logs will appear below:</p>
        <div id="logs"></div>
    </div>
    <script>
        const ws = new WebSocket('ws://' + window.location.host + '/ws');
        const logsDiv = document.getElementById('logs');
        
        ws.onmessage = function(event) {
            const data = JSON.parse(event.data);
            if (data.type === 'log') {
                const log = data.data;
                const logDiv = document.createElement('div');
                logDiv.className = 'log ' + (log.level || 'info').toLowerCase();
                logDiv.innerHTML = '<strong>[' + log.level + ']</strong> ' + 
                                 new Date(log.timestamp).toLocaleTimeString() + 
                                 '<br>' + log.message;
                if (log.error) {
                    logDiv.innerHTML += '<br><em>Error: ' + log.error + '</em>';
                }
                logsDiv.insertBefore(logDiv, logsDiv.firstChild);
            }
        };
        
        ws.onopen = function() {
            console.log('Connected to mobile device');
        };
        
        ws.onclose = function() {
            console.log('Disconnected from mobile device');
        };
    </script>
</body>
</html>
            ''');
          request.response.close();
        }
      });

      // Cancel previous subscription if exists
      await _logsSubscription?.cancel();

      // Listen to logs and broadcast to clients
      _logsSubscription = LogRepository().singleLogStream.listen((log) {
        _broadcastLog(log);
      });

      print('P2P Server started on $_serverUrl');
      return true;
    } catch (e) {
      print('Failed to start P2P server: $e');
      return false;
    }
  }

  /// Handle new WebSocket client
  void _handleNewClient(WebSocket webSocket) {
    _clients.add(webSocket);
    print('New client connected. Total clients: ${_clients.length}');

    // Send existing logs to new client
    for (final log in LogRepository().logs) {
      _sendLogToClient(webSocket, log);
    }

    // Handle client disconnect
    webSocket.listen(
      null,
      onError: (_) => _removeClient(webSocket),
      onDone: () => _removeClient(webSocket),
    );
  }

  /// Remove client from list
  void _removeClient(WebSocket webSocket) {
    _clients.remove(webSocket);
    print('Client disconnected. Total clients: ${_clients.length}');
  }

  /// Broadcast log to all connected clients
  void _broadcastLog(Log log) {
    if (_clients.isEmpty) return;

    final message = {
      'type': 'log',
      'data': {
        'message': log.message,
        'level': log.level?.toString().split('.').last,
        'timestamp':
            log.time?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'error': log.error?.toString(),
        'stackTrace': log.stackTrace?.toString(),
        'deviceId': 'mobile_device',
      },
    };

    _broadcastMessage(json.encode(message));
  }

  /// Send log to specific client
  void _sendLogToClient(WebSocket client, Log log) {
    final message = {
      'type': 'log',
      'data': {
        'message': log.message,
        'level': log.level?.toString().split('.').last,
        'timestamp':
            log.time?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'error': log.error?.toString(),
        'stackTrace': log.stackTrace?.toString(),
        'deviceId': 'mobile_device',
      },
    };

    try {
      client.add(json.encode(message));
    } catch (e) {
      print('Error sending log to client: $e');
      _removeClient(client);
    }
  }

  /// Broadcast message to all clients
  void _broadcastMessage(String message) {
    final clientsToRemove = <WebSocket>[];

    for (final client in _clients) {
      try {
        client.add(message);
      } catch (e) {
        print('Error broadcasting to client: $e');
        clientsToRemove.add(client);
      }
    }

    // Remove failed clients
    for (final client in clientsToRemove) {
      _removeClient(client);
    }
  }

  /// Connect to existing P2P server (as client)
  Future<bool> connectToServer(String serverUrl) async {
    try {
      // This is a simplified implementation
      // In a real scenario, you'd connect as a WebSocket client
      // For now, we'll just validate the URL and return success
      if (serverUrl.startsWith('http://') || serverUrl.startsWith('https://')) {
        print('Connecting to server: $serverUrl');
        // TODO: Implement actual WebSocket client connection
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to connect to server: $e');
      return false;
    }
  }

  /// Stop P2P server
  Future<void> stop() async {
    _logsSubscription?.cancel();
    _logsSubscription = null;

    // Close all client connections
    for (final client in _clients) {
      try {
        client.close();
      } catch (e) {
        print('Error closing client: $e');
      }
    }
    _clients.clear();

    // Stop server
    await _server?.close();
    _server = null;
    _serverUrl = null;

    print('P2P Server stopped');
  }

  /// Dispose resources
  void dispose() {
    stop();
  }
}
