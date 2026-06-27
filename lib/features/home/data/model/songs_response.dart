class SongsResponse {
  final String id;
  final String title;
  final String artist;
  final String duration;
  final String thumbnail;
  final String youtubeUrl;

  SongsResponse({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.thumbnail,
    required this.youtubeUrl,
  });
  factory SongsResponse.fromJson(Map<String, dynamic> json) {
    return SongsResponse(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      duration: json['duration'],
      thumbnail: json['thumbnail'],
      youtubeUrl: json['youtubeUrl'],
    );
  }
}
