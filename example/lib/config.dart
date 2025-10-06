import 'package:agent_logger/utils/config_helper.dart';

/// Configuration file for Agent Logger Demo
class Config {
  // P2P Relay Server configuration
  static String get p2pServerUrl => ConfigHelper.getP2PServerUrl();

  // Web client configuration
  static String get webClientUrl => ConfigHelper.getWebClientUrl();

  // Default session ID for testing
  static const String defaultSessionId = 'session_abc123';

  // Shake sensitivity
  static const double shakeThresholdGravity = 2.7;

  // Enable/disable features
  static const bool enableShakeDetection = true;
  static const bool enableP2P = true;
}
