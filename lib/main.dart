import 'package:blog_beispiel/di/get_it_setup.dart';
import 'package:blog_beispiel/main_view_model.dart';
import 'package:blog_beispiel/data/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() async {
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

  // Methode ist Global und in "lib/di/get_it_setup.dart"
  configureDependencies(); 

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp(viewModel: MainViewModel.instance()));
}

class MyApp extends StatelessWidget {
  final MainViewModel viewModel;
  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    // ListenableBuilder sorgt dafür, dass die App neu baut, wenn notifyListeners() gerufen wird
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: viewModel.appColor),
          ),
          routerConfig: appRouter,
        );
      },
    );
  }
}