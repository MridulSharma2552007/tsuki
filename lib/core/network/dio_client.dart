import 'package:dio/dio.dart';
import 'package:tsuki/core/config/env.dart';

class DioClient {
  DioClient._();
  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: Env.backendUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 20),
            sendTimeout: const Duration(seconds: 20),
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: false,
            responseBody: true,
            error: true,
          ),
        );
}
