import 'package:tsuki/app/feature/auth/data/auth_api.dart';
import 'package:tsuki/app/feature/auth/data/models/login_response.dart';
import 'package:tsuki/app/feature/auth/data/models/registeration_response.dart';

class AuthRepository {
  final AuthApi api;

  AuthRepository(this.api);

  Future<LoginResponse> login(String email, String password) async {
    final data = await api.login(email, password);

    return LoginResponse.fromJson(data);
  }

  Future<RegisterResponse> register(String email, String password) async {
    final data = await api.register(email, password);
    return RegisterResponse.fromJson(data);
  }
}
