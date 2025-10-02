# Agent Logger 🔍

A beautiful and powerful in-app logging solution for Flutter applications with shake-to-open functionality.

Inspired by [Logger](https://pub.dev/packages/logger), Agent Logger provides a clean architecture for viewing, searching, and sharing logs directly within your app.

## ✨ Features

- 📱 **Shake to Open** - Simply shake your device to view logs
- 🌐 **Remote Viewing** - View logs in web browser via QR code connection ✨ NEW!
  - 🎉 **P2P Mode** - No server needed! Direct connection
  - 🔧 **Relay Mode** - Works anywhere with WebSocket server
- 🎨 **Beautiful UI** - Modern, Material Design interface
- 🔍 **Real-time Search** - Instantly search through logs
- 📤 **Export & Share** - Share logs via any platform
- 🎯 **Multi-level Logging** - Debug, Info, Warning, Error levels
- 🏗️ **Clean Architecture** - Repository pattern, separation of concerns
- ⚡ **Reactive Updates** - Stream-based log updates
- 🎛️ **Selection Mode** - Select multiple logs to export
- 🔒 **Thread-safe** - Safe for concurrent access

## 📸 Screenshots

![Logger View](https://firebasestorage.googleapis.com/v0/b/agentlogger-b8866.appspot.com/o/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-10-30%20%D0%B2%2011.58.11.png?alt=media&token=93e468db-9d3c-44d3-88c4-3ed7f80ddcf9&_gl=1*2d8q4z*_ga*NTQ4MDc0NDI5LjE2OTI3OTI0Njc.*_ga_CW55HF8NVT*MTY5ODY0Njk5Ny4xMDcuMS4xNjk4NjUzMzcxLjYwLjAuMA..)
![Log Selection](https://firebasestorage.googleapis.com/v0/b/agentlogger-b8866.appspot.com/o/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-10-30%20%D0%B2%2012.01.02.png?alt=media&token=eddad3cb-9a7e-404f-93f1-fdcb09bfa2d6&_gl=1*q8b4n6*_ga*NTQ4MDc0NDI5LjE2OTI3OTI0Njc.*_ga_CW55HF8NVT*MTY5ODY0Njk5Ny4xMDcuMS4xNjk4NjUyODc0LjMuMC4w)

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  agent_logger: ^latest_version
```

## 📖 Usage

### 1. Initialize the Logger

Create a global logger instance (singleton pattern ensures same instance everywhere):

```dart
import 'package:agent_logger/logger.dart';

final logger = LoggerWriter();
```

### 2. Wrap Your App

Wrap your root widget with `AgentLogger`:

```dart
import 'package:agent_logger/agent_logger.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AgentLogger(
        enable: true, // Enable shake detection
        shakeThresholdGravity: 2.7, // Shake sensitivity (optional)
        child: MyHomePage(),
      ),
    );
  }
}
```

### 3. Log Events

Use the logger anywhere in your app:

```dart
// Debug logs
logger.d('Debug message');

// Info logs
logger.i('User logged in');

// Warning logs
logger.w('Low battery warning');

// Error logs with exception
try {
  // some code
} catch (e, stackTrace) {
  logger.e('Error occurred', error: e, stackTrace: stackTrace);
}
```

## 🎯 Features in Detail

### Shake to Open
Simply shake your device to open the logger view. No need for debug buttons or complex gestures!

### 🌐 Remote Viewing (NEW!)
View logs from your mobile device in real-time on any web browser:
- **P2P Mode** - Direct connection, NO server needed! 🎉
- **Scan QR Code** - Automatic setup
- **Real-time Streaming** - See logs as they happen
- **Team Collaboration** - Share session with team members
- **Works offline** - Just WiFi connection needed

👉 **P2P Mode (no server):** [P2P_MODE.md](P2P_MODE.md)  
👉 **With server:** [REMOTE_LOGGING.md](REMOTE_LOGGING.md)

### Search Functionality
Type in the search bar to instantly filter logs by content. Perfect for finding specific events.

### Selection Mode
- **Long press** on any log to enter selection mode
- **Tap** logs to add/remove from selection
- **Share** only selected logs or share all

### Export Options
- Share logs as text file
- Share individual log entries
- Copy log text
- Stream to web client

## 🏗️ Architecture

Agent Logger follows clean architecture principles:

- **Repository Layer**: Centralized log storage with reactive streams
- **Controller Layer**: UI state management using ChangeNotifier
- **View Layer**: Modular, testable UI components
- **Service Layer**: Logger implementation and shake detection

For detailed architecture documentation, see [ARCHITECTURE.md](ARCHITECTURE.md).

## ⚙️ Configuration

```dart
AgentLogger(
  enable: true, // Enable/disable shake detection
  shakeThresholdGravity: 2.7, // Shake sensitivity (lower = more sensitive)
  child: YourApp(),
)
```

## 🧪 Testing

Agent Logger is built with testing in mind:

```dart
// Mock repository for testing
final mockRepository = MockLogRepository();
final controller = LoggerController(mockRepository);

// Test your logging logic
logger.i('Test message');
expect(LogRepository().logs.length, 1);
```

## 🔄 Migration from Previous Versions

If you're upgrading from an older version, the API remains mostly the same. Key improvements:

- ✅ Better memory management (proper dispose)
- ✅ No more global mutable state
- ✅ Improved search performance
- ✅ Better error handling

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and architecture documentation.

## 📄 License

See the [LICENSE](LICENSE) file for details.

## 💡 Tips

- Use different log levels appropriately (d, i, w, e)
- Include context in your log messages
- Use error logging with stack traces for exceptions
- Search by keywords to quickly find relevant logs
- Export logs to share with your team

## 🛠️ Requirements

- Flutter >= 2.0.0
- Dart >= 2.12.0

## 📚 Dependencies

- [logger](https://pub.dev/packages/logger) - Logging functionality
- [sensors_plus](https://pub.dev/packages/sensors_plus) - Shake detection
- [share_plus](https://pub.dev/packages/share_plus) - Share functionality
- [path_provider](https://pub.dev/packages/path_provider) - File system access
- [mobile_scanner](https://pub.dev/packages/mobile_scanner) - QR code scanning
- [web_socket_channel](https://pub.dev/packages/web_socket_channel) - WebSocket communication

---

**Happy Debugging! 🐛🔍**

