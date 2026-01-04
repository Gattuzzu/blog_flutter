import 'package:blog_beispiel/services/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  // 1. Logging: Fängt Fehler im Flutter-Framework (z.B. Render-Fehler)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Hier könnte man den Fehler an Sentry/Crashlytics senden
    debugPrint("Flutter Error: ${details.exception}");
    // (Sauberes Logging besprechen wir an einer anderen Stelle im Kurs)
  };

  // 2. UI-Fallback: Definiert, was angezeigt wird, wenn ein Widget abstürzt
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      return ErrorWidget(details.exception); // Standard "Red Screen" im Debug
    }
    return const Center(
      child: Text(
        "Ein unerwarteter Fehler ist aufgetreten.",
        style: TextStyle(color: Colors.orange),
      ),
    );
  };

  // 3. Async Errors: Fängt asynchrone Fehler (z.B. Futures ohne await)
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Uncaught error: $error');
    // Auch diese Fehler sollten idealerweise an Sentry/Crashlytics gesendet werden
    return true;
  };
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();

}

class MyAppState extends State {
  static MyAppState? _thisWidget;
  Color _appColor = Colors.deepPurple;

  MyAppState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MyAppState._thisWidget = this;
    return MaterialApp.router(
      title: 'Blog App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _appColor),
      ),
      routerConfig: appRouter,
    );
  }

  static void changeColor(Color newColor) {
    MyAppState._thisWidget?.setState(() => MyAppState._thisWidget?._appColor = newColor);
  }
}
