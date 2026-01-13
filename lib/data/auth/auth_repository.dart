import 'dart:convert';
import 'dart:math';

import 'package:blog_beispiel/data/persistence/local_persistence.dart';
import 'package:blog_beispiel/data/persistence/local_persistence_keys.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

import 'keycloak_data_source.dart';

@lazySingleton
class AuthRepository {
  static final Logger log = Logger();
  final KeycloakDataSource keycloakDataSource;
  final LocalPersistence localPersistence;

  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);
  final ValueNotifier<String?> username = ValueNotifier(null);

  AuthRepository({required this.keycloakDataSource, required this.localPersistence});

  // 1. PKCE Initialisierung
  Future<Uri> initAuthFlow() async {
    final verifier = _generateCodeVerifier();
    final challenge = _generateCodeChallenge(verifier);

    // WICHTIG: Verifier speichern, wir brauchen ihn nach dem Redirect wieder!
    await localPersistence.saveToKey(LocalPersistenceKeys.codeVerifierKey, verifier);

    return keycloakDataSource.getAuthorizationUri(challenge);
  }

  // 2. Login abschliessen (nach Redirect)
  Future<void> handleAuthCallback(String code) async {
    final verifier = await localPersistence.loadFromKey(LocalPersistenceKeys.codeVerifierKey);
    if (verifier == null) throw Exception("Code Verifier not found!");

    final tokens = await keycloakDataSource.exchangeCodeForToken(
      code,
      verifier,
    );
    
    // Tokens speichern
    await _saveTokens(tokens);
    isAuthenticated.value = true;
    _setUserName();
  }

  Future<void> checkLoginStatus() async {
    final token = await localPersistence.loadFromKey(LocalPersistenceKeys.accessTokenKey);
    if (token != null) {
      isAuthenticated.value = true;
      _setUserName();
    } else {
      isAuthenticated.value = false;
      username.value = null;
    }
  }

  Future<void> _saveTokens(Map<String, dynamic> tokens) async {
    if (tokens[LocalPersistenceKeys.accessTokenKey] != null) {
      await localPersistence.saveToKey(
        LocalPersistenceKeys.accessTokenKey,
        tokens[LocalPersistenceKeys.accessTokenKey],
      );
    }
    if (tokens[LocalPersistenceKeys.refreshTokenKey] != null) {
      await localPersistence.saveToKey(
        LocalPersistenceKeys.refreshTokenKey,
        tokens[LocalPersistenceKeys.refreshTokenKey],
      );
    }
    await localPersistence.removeKey(LocalPersistenceKeys.codeVerifierKey);
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
      localPersistence.loadFromKey(LocalPersistenceKeys.accessTokenKey);

  Future<void> _setUserName() async {
    Map<String, dynamic>? data = await _getAllUserData();
    username.value = data?['preferred_username'] ?? "";
  }

  Future<Map<String, dynamic>?> _getAllUserData() async {
    Map<String, dynamic>? data;
    String? token = await getAccessToken();
    if(token != null){
      data = _decodeToken(token);
    }
    return data;
  }

  Map<String, dynamic>? _decodeToken(String? token) {
    if (token == null || token.isEmpty) return null;

    try {
      // Ein JWT besteht aus Header.Payload.Signature
      final parts = token.split('.');
      if (parts.length != 3) return null;

      // Wir brauchen den mittleren Teil (Payload)
      final payload = parts[1];
      
      // Base64 Dekodierung mit Normalisierung des Paddings
      var normalized = base64Url.normalize(payload);
      var resp = utf8.decode(base64Url.decode(normalized));
      
      return json.decode(resp) as Map<String, dynamic>;
    } catch (e) {
      log.e("Fehler beim Dekodieren des Tokens: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await localPersistence.removeKey(LocalPersistenceKeys.accessTokenKey);
    await localPersistence.removeKey(LocalPersistenceKeys.refreshTokenKey);
    isAuthenticated.value = false;
    username.value = null;
  }
}