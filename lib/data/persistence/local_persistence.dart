import 'dart:ui';

import 'package:blog_beispiel/data/logger/logger.util.dart';
import 'package:blog_beispiel/data/persistence/local_persistence_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class LocalPersistence {
  final Logger log = getLogger();
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  Future<Color?> loadAppColor() async {
    String? colorString = await storage.read(key: LocalPersistenceKeys.appColorKey);
    if(colorString != null){
      log.i("App Farbe aus dem Lokalen Speicher geladen: $colorString");
      return Color(int.parse(colorString));
    }
    log.e("Es wurde keine Farbe im Lokalen Speicher gefunden!");
    return null;
  }

  Future<void> saveAppColor(Color color) async {
    String colorString = color.toARGB32().toString();
    log.i("App Farbe in den Lokalen Speicher gespeichert: $colorString");
    await storage.write(key: LocalPersistenceKeys.appColorKey, value: colorString);
  }
}