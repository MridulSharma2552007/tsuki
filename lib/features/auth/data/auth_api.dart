import 'package:dio/dio.dart';
import 'dart:convert';

class AuthApi {
  final Dio dio;
  AuthApi(this.dio);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    print('[API] RESPONSE TYPE: ${response.data.runtimeType}');
    print('[API] RESPONSE: ${response.data}');

    return jsonDecode(response.data);
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    print('[API] REGISTER ');
    final response = await dio.post(
      '/auth/register',
      data: {'email': email, 'password': password},
    );
    return jsonDecode(response.data);
  }

  Future<Map<String, dynamic>> verify(String email, String code) async {
    print('[API] VERIFY ');
    final response = await dio.post(
      '/auth/verify',
      data: {'email': email, 'code': code},
    );
    return jsonDecode(response.data);
  }
}
