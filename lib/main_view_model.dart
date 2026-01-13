import 'package:blog_beispiel/data/persistence/local_persistence.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainViewModel extends ChangeNotifier {
  Color _appColor = Colors.deepPurple;
  final LocalPersistence persistence;

  Color get appColor => _appColor;

  MainViewModel({required this.persistence}) {
    init();
  } 

  // Beim Start der App aufrufen
  Future<void> init() async {
    Color? savedColor = await persistence.loadAppColor();
    if (savedColor != null) {
      _appColor = savedColor;
      notifyListeners(); // UI informieren
    }
  }

  void updateColor(Color newColor) async {
    _appColor = newColor;
    notifyListeners(); // UI sofort aktualisieren
    await persistence.saveAppColor(newColor); // Dauerhaft speichern
  }
}