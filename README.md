## Hey, everybody. I am sharing a package to create and read application logs in the application itself.

The package is inspired by [Logger](https://pub.dev/packages/logger) and replicates its functionality.

# To open AgentLogger, simply shake the device

![](https://firebasestorage.googleapis.com/v0/b/agentlogger-b8866.appspot.com/o/IMG_3038.PNG?alt=media&token=52f2f65e-c24b-4b2a-b07c-db47adbedb8f&_gl=1*1lp3fpw*_ga*NTQ4MDc0NDI5LjE2OTI3OTI0Njc.*_ga_CW55HF8NVT*MTY5ODY0Njk5Ny4xMDcuMS4xNjk4NjUwOTEwLjU5LjAuMA..)
![](https://firebasestorage.googleapis.com/v0/b/agentlogger-b8866.appspot.com/o/IMG_3039.PNG?alt=media&token=d7f2c8e0-20ac-45f3-ab47-75c8e005ff64&_gl=1*ulfprc*_ga*NTQ4MDc0NDI5LjE2OTI3OTI0Njc.*_ga_CW55HF8NVT*MTY5ODY0Njk5Ny4xMDcuMS4xNjk4NjUwOTQyLjI3LjAuMA..)

- You can share the logs on social media, or just copy the text of the logs.

- Click and highlight the logs you want, then the share button at the top to send only what you need.

- Or just click the share button at the top to send the entire logging history.

# Installing

1. initialize AgentLogger as [Logger](https://pub.dev/packages/logger)
```dart
var logger = LoggerWriter();
```
2. Wrap your parent application widget in an AgentLogger widget.
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3:
            true, 
      ),
      home: AgentLogger(
        child: const MyHomePage(title: 'Flutter Demo Home Page'),
        enable: true, 
      ),
    );
  }
}
```

3. And log whatever you need to log according to the [Logger](https://pub.dev/packages/logger) package instructions
```dart
 logger.i('test log $_counter');
```

## I hope this tool will help you in debugging and testing your applications.

