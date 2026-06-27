import 'package:dio/dio.dart';
import 'package:tsuki/features/home/data/home_api.dart';
import 'package:tsuki/features/home/data/model/featured_response.dart';

class HomeRepository {
  final HomeApi api;
  HomeRepository(this.api);

  Future<FeaturedResponse> getFeaturedFeed() async {
    final data = await api.getfeaturedFeed();
    final response = FeaturedResponse.fromJson(data);
    return response;
  }
}
