/// Configuration file for Agent Logger Demo
class Config {
  // P2P Relay Server configuration
  static const String p2pServerUrl = 'http://144.31.198.54:8080';
  
  // Web client configuration
  static const String webClientUrl = 'http://144.31.198.54';
  
  // Default session ID for testing
  static const String defaultSessionId = 'session_abc123';
  
  // Shake sensitivity
  static const double shakeThresholdGravity = 2.7;
  
  // Enable/disable features
  static const bool enableShakeDetection = true;
  static const bool enableP2P = true;
}
