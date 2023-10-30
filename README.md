## Hey, everybody. I am sharing a package to create and read application logs in the application itself.

The package is inspired by [Logger](https://pub.dev/packages/logger) and replicates its functionality.

# To open AgentLogger, simply shake the device

![](https://firebasestorage.googleapis.com/v0/b/agentlogger-b8866.appspot.com/o/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-10-30%20%D0%B2%2011.54.49.png?alt=media&token=a2ff86a9-0fcf-4eb5-8e6c-a79ff14fcace&_gl=1*hvqar1*_ga*NTQ4MDc0NDI5LjE2OTI3OTI0Njc.*_ga_CW55HF8NVT*MTY5ODY0Njk5Ny4xMDcuMS4xNjk4NjUyNTYzLjYwLjAuMA..)
![](https://firebasestorage.googleapis.com/v0/b/agentlogger-b8866.appspot.com/o/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%202023-10-30%20%D0%B2%2012.01.02.png?alt=media&token=eddad3cb-9a7e-404f-93f1-fdcb09bfa2d6&_gl=1*q8b4n6*_ga*NTQ4MDc0NDI5LjE2OTI3OTI0Njc.*_ga_CW55HF8NVT*MTY5ODY0Njk5Ny4xMDcuMS4xNjk4NjUyODc0LjMuMC4w)


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

