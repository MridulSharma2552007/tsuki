import 'dart:io';

import 'package:tsuki/features/auth/data/auth_api.dart';
import 'package:tsuki/features/auth/data/models/login_response.dart';
import 'package:tsuki/features/auth/data/models/registeration_response.dart';
import 'package:tsuki/core/storage/secure_storage_service.dart';

class AuthRepository {
  final AuthApi api;
  final SecureStorageService storage;

  AuthRepository(this.api, {required this.storage});
  Future<LoginResponse> login(String email, String password) async {
    final data = await api.login(email, password);
    final response = LoginResponse.fromJson(data);

    print('[REPO] TYPE: ${data.runtimeType}');
    print('[REPO] DATA: $data');
    await storage.saveTokens(
      accessToken: response.accessToken,
      idToken: response.idToken,
      refreshToken: response.refreshToken,
    );
    return response;
  }

  Future<RegisterResponse> register(String email, String password) async {
    final data = await api.register(email, password);
    print('[REPO] REGISTER : ${data}');

    return RegisterResponse.fromJson(data);
  }

  Future<void> verify(String email, String code) async {
    await api.verify(email, code);
    print('[REPO] Verify Called');
  }
}
