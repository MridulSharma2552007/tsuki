import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchModel {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String channelId;
  final Duration duration;

  const SearchModel({
    required this.id,
    required this.title,
    required this.author,
    required this.thumbnailUrl,
    required this.channelId,
    required this.duration,
  });

  factory SearchModel.fromVideo(Video video) {
    return SearchModel(
      id: video.id.value,
      title: video.title,
      author: video.author,
      thumbnailUrl: video.thumbnails.highResUrl,
      channelId: video.channelId.value,
      duration: video.duration ?? Duration.zero,
    );
  }
}
