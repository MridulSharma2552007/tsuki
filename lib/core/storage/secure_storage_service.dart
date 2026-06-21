import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String idToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: 'access_token', value: accessToken);

    await _storage.write(key: 'id_token', value: idToken);

    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getIdToken() async {
    return await _storage.read(key: 'id_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}
