import 'package:app_links/app_links.dart';
import 'package:blog_beispiel/data/auth/auth_repository.dart';
import 'package:blog_beispiel/data/logger/logger.util.dart';
import 'package:blog_beispiel/di/get_it_setup.dart';
import 'package:blog_beispiel/main_view_model.dart';
import 'package:blog_beispiel/data/router/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:logger/logger.dart';

final _log = getLogger();

void main() async {
  if(kDebugMode){
    Logger.level = Level.debug;
  } else{
    Logger.level = Level.info;
  }

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
  
  const String appFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR', defaultValue: "development");
  _log.i("App Flavor: $appFlavor");
  if(appFlavor == "production"){
    await GlobalConfiguration().loadFromAsset("prod_settings");
  } else{
    await GlobalConfiguration().loadFromAsset("dev_settings");
  }

  // 1. Auth Status prüfen (wartet nicht zwingend auf Ergebnis, kann async sein)
  await getIt<AuthRepository>().checkLoginStatus();

  // 2. Deep Links Setup
  final appLinks = AppLinks();
  appLinks.uriLinkStream.listen((uri) {
    if (uri.scheme == 'blogapp' && uri.host == 'login-callback') {
      final code = uri.queryParameters['code'];
      if (code != null) {
        getIt<AuthRepository>().handleAuthCallback(code);
      }
    }
  });

  runApp(MyApp(viewModel: getIt<MainViewModel>()));
}

class MyApp extends StatelessWidget {
  final MainViewModel viewModel;

  const MyApp({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    _log.i("App wird gestartet!");
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