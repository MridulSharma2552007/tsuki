import 'package:dio/dio.dart';
import 'package:tsuki/core/config/env.dart';

class ApiClient {
  final Dio dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
}
