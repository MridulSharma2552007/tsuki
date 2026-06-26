import 'package:flutter/widgets.dart';
import 'package:tsuki/root/feature/home/widgets/song_tile_small.dart';

class FeaturedSongs extends StatelessWidget {
  final List songs;

  const FeaturedSongs({super.key, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: songs.map((song) {
        return SongTileSmall(
          title: song.title,
          artist: song.artist,
          thumbnail: song.thumbnail,
          duration: song.duration,
          id: song.id,
        );
      }).toList(),
    );
  }
}
