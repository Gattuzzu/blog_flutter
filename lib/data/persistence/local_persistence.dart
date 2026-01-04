import 'dart:ui';

import 'package:blog_beispiel/data/persistence/local_persistence_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalPersistence {
  final storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  Future<Color?> loadAppColor() async {
    String? colorString = await storage.read(key: LocalPersistenceKeys.appColorKey);
    if(colorString != null){
      return Color(int.parse(colorString));
    }
    return null;
  }

  Future<void> saveAppColor(Color color) async {
    await storage.write(key: LocalPersistenceKeys.appColorKey, value: color.toARGB32().toString());
  }
}