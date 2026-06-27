import 'package:flutter/widgets.dart';
import 'package:tsuki/features/home/widgets/artist_home_big.dart';

class FeaturedArtist extends StatelessWidget {
  final List artists;
  const FeaturedArtist({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: artists.length,
        itemBuilder: (context, index) {
          final artist = artists[index];
          return ArtistHomeBig(
            artistName: artist.name,
            artistImageUrl: artist.thumbnail,
            ArtistPageUrl: artist.youtubeUrl,
          );
        },
      ),
    );
  }
}
