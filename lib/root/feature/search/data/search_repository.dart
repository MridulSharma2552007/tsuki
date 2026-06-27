import 'package:tsuki/root/feature/search/data/models/search_response.dart';
import 'package:tsuki/root/feature/search/data/search_api.dart';

class SearchRepository {
  final SearchApi api;
  SearchRepository(this.api);
  Future<SearchResponse> Search(String q) async {
    final data = await api.search(q);
    final response = SearchResponse.fromJson(data);
    return response;
  }
}
