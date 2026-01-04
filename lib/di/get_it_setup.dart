import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
// WICHTIG: Dieser Import wird erst rot sein, da die Datei generiert wird!
import 'get_it_setup.config.dart'; 

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', 
  preferRelativeImports: true, 
  asExtension: true, // Erlaubt getIt.init() Syntax
)
void configureDependencies() => getIt.init();