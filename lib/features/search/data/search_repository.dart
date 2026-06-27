import 'package:tsuki/features/search/data/models/search_response.dart';
import 'package:tsuki/features/search/data/search_api.dart';

class SearchRepository {
  final SearchApi api;
  SearchRepository(this.api);
  Future<List<SearchResponse>> Search(String q) async {
    final data = await api.search(q);
    final songs = data['songs'] as List<dynamic>;
    return songs
        .map((e) => SearchResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
