import 'dart:convert';

import 'package:dio/dio.dart';

class SearchApi {
  final Dio dio;
  SearchApi(this.dio);

  Future<Map<String, dynamic>> search(String q) async {
    final response = await dio.post('/metadata/search?q=${q}');
    return jsonDecode(response.data);
  }
}
