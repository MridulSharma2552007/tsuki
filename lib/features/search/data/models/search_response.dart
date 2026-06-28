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
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Unknown title',
      artist: json['artist'] as String? ?? 'Unknown artist',
      artistId: json['artistId'] as String? ?? '',
      album: json['album'] as String? ?? '',
      duration: json['duration'] as String? ?? '0:00',
      thumbnail: json['thumbnail'] as String? ?? '',
      youtubeUrl: json['youtubeUrl'] as String? ?? '',
    );
  }
}
