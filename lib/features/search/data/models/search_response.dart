class SearchResponse {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String album;
  final String duration;
  final String thumbnail;
  final String youtubeUrl;

  SearchResponse({
    required this.id,
    required this.title,
    required this.artist,
    required this.artistId,
    required this.album,
    required this.duration,
    required this.thumbnail,
    required this.youtubeUrl,
  });
  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      artistId: json['artistId'],
      album: json['album'],
      duration: json['duration'],
      thumbnail: json['thumbnail'],
      youtubeUrl: json['youtubeUrl'],
    );
  }
}
