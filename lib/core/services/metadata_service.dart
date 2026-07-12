import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MetadataService {
  MetadataService._();

  static final MetadataService _instance = MetadataService._();

  static late final YoutubeExplode _yt;

  static Future<void> init() async {
    _yt = YoutubeExplode();
  }

  static Future<List<Video>> searchSongs(String query) async {
    return _yt.search.search("$query official audio");
  }
}
