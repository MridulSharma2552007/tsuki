class ArtistResponse {
  final String id;
  final String name;
  final String thumbnail;
  final String youtubeUrl;

  ArtistResponse({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.youtubeUrl,
  });

  factory ArtistResponse.fromJson(Map<String, dynamic> json) {
    return ArtistResponse(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      youtubeUrl: json['youtubeUrl'],
    );
  }
}
