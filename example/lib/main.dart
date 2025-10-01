import 'package:flutter/material.dart';
import 'package:agent_logger/agent_logger.dart';
import 'package:agent_logger/logger.dart';

// Global logger instance - singleton pattern ensures same instance everywhere
final logger = LoggerWriter();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  logger.i('App started');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agent Logger Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Wrap your home widget with AgentLogger
      // Shake your device to open the logger view
      home: AgentLogger(
        enable: true, // Enable shake detection
        shakeThresholdGravity: 2.7, // Shake sensitivity
        child: const MyHomePage(title: 'Agent Logger Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    logger.i('Counter incremented to $_counter');
  }

  void _demonstrateLogs() {
    logger.d('Debug: This is a debug message');
    logger.i('Info: Counter value is $_counter');
    logger.w('Warning: Counter is getting high!');

    try {
      throw Exception('Test exception');
    } catch (e, stackTrace) {
      logger.e('Error: Something went wrong', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.phonelink_ring,
              size: 48,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            const Text(
              'Shake your device to open logger!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _demonstrateLogs,
              icon: const Icon(Icons.bug_report),
              label: const Text('Generate Test Logs'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment and log',
        child: const Icon(Icons.add),
      ),
    );
  }
}
