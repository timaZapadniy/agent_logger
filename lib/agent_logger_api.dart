/// Agent Logger - A beautiful and powerful logging solution for Flutter
///
/// This library provides:
/// - Shake detection to open logger
/// - Beautiful UI for viewing logs
/// - Search and filter functionality
/// - Export and share logs
/// - Multiple log levels
library agent_logger;

export 'agent_logger.dart';
export 'logger.dart';
export 'models/log.dart';
export 'repository/log_repository.dart';
export 'controller/logger_controller.dart';

// Re-export logger levels for convenience
export 'package:logger/logger.dart' show Level;
