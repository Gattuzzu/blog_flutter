// Diese Variable wird überell da verwendet, wo der Code eigentlich nie hinkommen sollte.
String errorDuringDevelopment = "Error during development: Page in the wrong state!";

// Fehler der App
class AppException implements Exception {
  final String message;
  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException() : super('Keine Internetverbindung');
}

class ServerException extends AppException {
  ServerException(String? details) : super('Serverfehler: $details');
}