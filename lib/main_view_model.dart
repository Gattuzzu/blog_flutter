import 'package:blog_beispiel/data/persistence/local_persistence.dart';
import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  static MainViewModel? _instance;
  Color _appColor = Colors.deepPurple;
  final LocalPersistence _persistence = LocalPersistence();

  Color get appColor => _appColor;

  MainViewModel._() {
    init();
  } 

  static MainViewModel instance() {
    if(_instance == null){
      MainViewModel._instance = MainViewModel._();
    }
    return _instance!;
  }

  // Beim Start der App aufrufen
  Future<void> init() async {
    Color? savedColor = await _persistence.loadAppColor();
    if (savedColor != null) {
      _appColor = savedColor;
      notifyListeners(); // UI informieren
    }
  }

  void updateColor(Color newColor) async {
    _appColor = newColor;
    notifyListeners(); // UI sofort aktualisieren
    await _persistence.saveAppColor(newColor); // Dauerhaft speichern
  }
}