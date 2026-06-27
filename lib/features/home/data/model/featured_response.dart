import 'package:tsuki/features/home/data/model/album_response.dart';
import 'package:tsuki/features/home/data/model/artist_response.dart';
import 'package:tsuki/features/home/data/model/songs_response.dart';

class FeaturedResponse {
  final List<ArtistResponse> artists;
  final List<AlbumResponse> albums;
  final List<SongsResponse> songs;

  FeaturedResponse({
    required this.artists,
    required this.albums,
    required this.songs,
  });

  factory FeaturedResponse.fromJson(Map<String, dynamic> json) {
    return FeaturedResponse(
      artists: (json['artists'] as List)
          .map((e) => ArtistResponse.fromJson(e))
          .toList(),
      albums: (json['albums'] as List)
          .map((e) => AlbumResponse.fromJson(e))
          .toList(),
      songs: (json['songs'] as List)
          .map((e) => SongsResponse.fromJson(e))
          .toList(),
    );
  }
}
