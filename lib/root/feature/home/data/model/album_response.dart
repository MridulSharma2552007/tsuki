class AlbumResponse {
  final String id;
  final String title;
  final String artist;
  final String thumbnail;

  AlbumResponse({
    required this.id,
    required this.title,
    required this.artist,
    required this.thumbnail,
  });

  factory AlbumResponse.fromJson(Map<String, dynamic> json) {
    return AlbumResponse(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      thumbnail: json['thumbnail'],
    );
  }
}
