import 'package:tsuki/core/services/metadata_service.dart';
import 'package:tsuki/features/home/search/data/models/search_model.dart';

class SearchRepository {
  Future<List<SearchModel>> search(String q) async {
    final videos = await MetadataService.searchSongs(q);
    return videos.map((video) => SearchModel.fromVideo(video)).toList();
  }
}
