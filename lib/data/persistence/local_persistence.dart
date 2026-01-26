import 'dart:ui';

import 'package:gattus_blog/data/logger/logger.util.dart';
import 'package:gattus_blog/data/persistence/local_persistence_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class LocalPersistence {
  final Logger log = getLogger();
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  /*
  *   Hauptfunktionen:
  */
  Future<String?> loadFromKey(String key) async {
    String? value = await storage.read(key: key);
    if(value != null){
      log.d("Der Key '$key' konnte aus dem Lokalen Speicher geladen werden: '$value'");
      return value;
    }
    log.e("Der Key '$key' konnte aus dem Lokalen Speicher nicht geladen werden!");
    return null;
  }

  Future<void> saveToKey(String key, String value) async {
    log.d("Der Key '$key' wird in den Lokalen Speicher mit dem Wert '$value' abgespeichert.");
    await storage.write(key: key, value: value);
  }

  Future<void> removeKey(String key) async {
    log.i("Der Key '$key' wird aus dem Lokalen Speicher gelöscht.");
    return storage.delete(key: key);
  }

  /*
  *   Hilfsfunktionen
  */
  Future<Color?> loadAppColor() async {
    String? colorString = await loadFromKey(LocalPersistenceKeys.appColorKey);
    if(colorString != null){
      return Color(int.parse(colorString));
    }
    return null;
  }

  Future<void> saveAppColor(Color color) async {
    String colorString = color.toARGB32().toString();
    await saveToKey(LocalPersistenceKeys.appColorKey, colorString);
  }
}