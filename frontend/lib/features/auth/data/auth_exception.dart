class AuthException implements Exception {
  const AuthException(this.message, {this.details});

  final String message;
  final Map<String, List<String>>? details;

  @override
  String toString() => message;
}
