import 'dart:io';
import 'package:flutter/foundation.dart';

/// Helper class for getting configuration values across different platforms
class ConfigHelper {
  /// Get P2P server URL from environment variables or fallback to default
  static String getP2PServerUrl({String? fallback}) {
    final defaultFallback = fallback ?? 'http://144.31.198.54:8080';

    // Try to get from environment variable first (only on non-web platforms)
    if (!kIsWeb) {
      try {
        final envUrl = Platform.environment['P2P_SERVER_URL'];
        if (envUrl != null && envUrl.isNotEmpty) {
          return envUrl;
        }
      } catch (e) {
        // Platform.environment not supported on this platform
        debugPrint('Platform.environment not supported: $e');
      }
    }

    // For web platform, we could implement other methods like:
    // - URL parameters
    // - Local storage
    // - Build-time configuration
    // For now, return fallback
    return defaultFallback;
  }

  /// Get web client URL from environment variables or fallback to default
  static String getWebClientUrl({String? fallback}) {
    final defaultFallback = fallback ?? 'http://144.31.198.54:8080';

    // Try to get from environment variable first (only on non-web platforms)
    if (!kIsWeb) {
      try {
        final envUrl = Platform.environment['WEB_CLIENT_URL'];
        if (envUrl != null && envUrl.isNotEmpty) {
          return envUrl;
        }
      } catch (e) {
        // Platform.environment not supported on this platform
        debugPrint('Platform.environment not supported: $e');
      }
    }

    return defaultFallback;
  }

  /// Get server host and port from P2P server URL
  static String getServerHostPort({String? fallback}) {
    final defaultFallback = fallback ?? '144.31.198.54:8080';
    final serverUrl = getP2PServerUrl(fallback: 'http://144.31.198.54:8080');

    try {
      final uri = Uri.parse(serverUrl);

      // Handle default ports if not specified
      int port = uri.port;
      if (port == -1) {
        port = uri.scheme == 'https' ? 443 : 80;
      }

      return '${uri.host}:$port';
    } catch (e) {
      debugPrint('Failed to parse server URL: $e');
      return defaultFallback;
    }
  }

  /// Get WebSocket URL from P2P server URL
  static String getWebSocketUrl({String? fallback}) {
    final defaultFallback =
        fallback ?? 'ws://144.31.198.54:8080/ws?type=mobile';

    // Try to get from environment variable first (only on non-web platforms)
    if (!kIsWeb) {
      try {
        final envUrl = Platform.environment['P2P_SERVER_URL'];
        if (envUrl != null && envUrl.isNotEmpty) {
          // Convert HTTP/HTTPS URL to WebSocket URL
          final uri = Uri.parse(envUrl);
          final protocol = uri.scheme == 'https' ? 'wss' : 'ws';

          // Handle default ports for SSL/HTTP
          String port = '';
          if (uri.port != -1) {
            port = ':${uri.port}';
          } else {
            // Use default ports if not specified
            port = protocol == 'wss' ? ':443' : ':80';
          }

          return '$protocol://${uri.host}$port/ws?type=mobile';
        }
      } catch (e) {
        // Platform.environment not supported on this platform
        debugPrint('Platform.environment not supported: $e');
      }
    }

    // For web platform, we could implement other methods like:
    // - URL parameters
    // - Local storage
    // - Build-time configuration
    // For now, return fallback
    return defaultFallback;
  }

  /// Check if URL uses SSL/TLS
  static bool isSecureUrl(String url) {
    return url.startsWith('https://') || url.startsWith('wss://');
  }

  /// Convert HTTP URL to HTTPS
  static String toSecureUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    } else if (url.startsWith('ws://')) {
      return url.replaceFirst('ws://', 'wss://');
    }
    return url;
  }

  /// Convert HTTPS URL to HTTP (for testing)
  static String toInsecureUrl(String url) {
    if (url.startsWith('https://')) {
      return url.replaceFirst('https://', 'http://');
    } else if (url.startsWith('wss://')) {
      return url.replaceFirst('wss://', 'ws://');
    }
    return url;
  }
}
