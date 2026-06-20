import 'package:dio/dio.dart';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await dio.post(
      '/auth/register',
      data: {'email': email, 'password': password},
    );
    return response.data;
  }
}
