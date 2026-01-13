import 'package:blog_beispiel/data/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class ProfileViewModel extends ChangeNotifier {
  final AuthRepository repository;
  
  // Lokaler State
  bool _isAuthenticated = false;
  String _userName = "";

  bool get isAutenticated => _isAuthenticated;
  String get userName => _userName;
  
  // Listener Callbacks speichern für Dispose
  VoidCallback? _authListener;
  VoidCallback? _userNameListener;

  ProfileViewModel({required this.repository}) {
    _init();
  }

  void _init() {
    _isAuthenticated = repository.isAuthenticated.value;
    _userName = repository.username.value ?? "";
    
    _authListener = () {
      _isAuthenticated = repository.isAuthenticated.value;
      notifyListeners();
    };
    repository.isAuthenticated.addListener(_authListener!);

    _userNameListener = () {
      _userName = repository.username.value ?? "";
      notifyListeners();
    };
    repository.username.addListener(_userNameListener!);
  }

  @override
  void dispose() {
    if (_authListener != null) {
      repository.isAuthenticated.removeListener(_authListener!);
    }

    if(_userNameListener != null){
      repository.username.removeListener(_userNameListener!);
    }

    super.dispose();
  }
  
  Future<void> login() async {
    try {
      final authUri = await repository.initAuthFlow();

      // Force launch or check canLaunch first
      await launchUrl(authUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print("Login Error: $e");
      }
    }
  }

  Future<void> logout() async {
    await repository.logout();
  }
}