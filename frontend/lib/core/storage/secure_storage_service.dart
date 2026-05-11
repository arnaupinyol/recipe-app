import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  const SecureStorageService([this._storage = const FlutterSecureStorage()]);

  static const authTokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  Future<String?> readToken() => _storage.read(key: authTokenKey);

  Future<void> writeToken(String token) =>
      _storage.write(key: authTokenKey, value: token);

  Future<void> clearToken() => _storage.delete(key: authTokenKey);
}
