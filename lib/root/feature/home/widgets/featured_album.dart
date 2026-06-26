import 'package:flutter/widgets.dart';
import 'package:tsuki/root/feature/home/widgets/album_home_big.dart';

class FeaturedAlbum extends StatelessWidget {
  final List albums;
  const FeaturedAlbum({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (context, index) {
          final album = albums[index];
          return AlbumHomeBig(imageUrl: album.thumbnail, title: album.title);
        },
      ),
    );
  }
}
