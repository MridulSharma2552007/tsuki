import 'dart:convert';

import 'package:dio/dio.dart';

class HomeApi {
  final Dio dio;
  HomeApi(this.dio);

  Future<Map<String, dynamic>> getfeaturedFeed() async {
    final response = await dio.get('/metadata/featured');
    return jsonDecode(response.data);
  }
}
