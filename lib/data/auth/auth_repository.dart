import 'dart:convert';
import 'dart:math';

import 'package:blog_beispiel/data/persistence/local_persistence.dart';
import 'package:blog_beispiel/data/persistence/local_persistence_keys.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import 'keycloak_data_source.dart';

class AuthRepository {
  static final instance = AuthRepository._init();
  AuthRepository._init();

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);
  final ValueNotifier<String?> username = ValueNotifier(null);

  // 1. PKCE Initialisierung
  Future<Uri> initAuthFlow() async {
    final verifier = _generateCodeVerifier();
    final challenge = _generateCodeChallenge(verifier);

    // WICHTIG: Verifier speichern, wir brauchen ihn nach dem Redirect wieder!
    await LocalPersistence.instance.saveToKey(LocalPersistenceKeys.codeVerifierKey, verifier);

    return KeycloakDataSource.instance.getAuthorizationUri(challenge);
  }

  // 2. Login abschliessen (nach Redirect)
  Future<void> handleAuthCallback(String code) async {
    final verifier = await LocalPersistence.instance.loadFromKey(LocalPersistenceKeys.codeVerifierKey);
    if (verifier == null) throw Exception("Code Verifier not found!");

    final tokens = await KeycloakDataSource.instance.exchangeCodeForToken(
      code,
      verifier,
    );
    
    // Tokens speichern
    await _saveTokens(tokens);
    isAuthenticated.value = true;
    username.value = "User";
  }

  Future<void> checkLoginStatus() async {
    final token = await LocalPersistence.instance.loadFromKey(LocalPersistenceKeys.accessTokenKey);
    if (token != null) {
      isAuthenticated.value = true;
      username.value = "User";
    } else {
      isAuthenticated.value = false;
      username.value = null;
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> tokens) async {
    if (tokens[LocalPersistenceKeys.accessTokenKey] != null) {
      await LocalPersistence.instance.saveToKey(
        LocalPersistenceKeys.accessTokenKey,
        tokens[LocalPersistenceKeys.accessTokenKey],
      );
    }
    if (tokens[LocalPersistenceKeys.refreshTokenKey] != null) {
      await LocalPersistence.instance.saveToKey(
        LocalPersistenceKeys.refreshTokenKey,
        tokens[LocalPersistenceKeys.refreshTokenKey],
      );
    }
    await LocalPersistence.instance.removeKey(LocalPersistenceKeys.codeVerifierKey);
  }

  // Helper: PKCE Generierung
  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  Future<String?> getAccessToken() =>
      LocalPersistence.instance.loadFromKey(LocalPersistenceKeys.accessTokenKey);

  Future<void> logout() async {
    await LocalPersistence.instance.removeKey(LocalPersistenceKeys.accessTokenKey);
    await LocalPersistence.instance.removeKey(LocalPersistenceKeys.refreshTokenKey);
    isAuthenticated.value = false;
    username.value = null;
  }
}