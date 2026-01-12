import 'package:blog_beispiel/data/auth/auth_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository.instance;
  
  // Lokaler State
  bool _isAuthenticated = false;
  String _userName = "";

  bool get isAutenticated => _isAuthenticated;
  String get userName => _userName;
  
  // Listener Callbacks speichern für Dispose
  VoidCallback? _authListener;
  VoidCallback? _userNameListener;

  ProfileViewModel() {
    _init();
  }

  void _init() {
    _isAuthenticated = _repository.isAuthenticated.value;
    _userName = _repository.username.value ?? "";
    
    _authListener = () {
      _isAuthenticated = _repository.isAuthenticated.value;
      notifyListeners();
    };
    _repository.isAuthenticated.addListener(_authListener!);

    _userNameListener = () {
      _userName = _repository.username.value ?? "";
      notifyListeners();
    };
    _repository.username.addListener(_userNameListener!);
  }

  @override
  void dispose() {
    if (_authListener != null) {
      _repository.isAuthenticated.removeListener(_authListener!);
    }

    if(_userNameListener != null){
      _repository.username.removeListener(_userNameListener!);
    }

    super.dispose();
  }
  
  Future<void> login() async {
    try {
      final authUri = await _repository.initAuthFlow();

      // Force launch or check canLaunch first
      await launchUrl(authUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print("Login Error: $e");
      }
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}