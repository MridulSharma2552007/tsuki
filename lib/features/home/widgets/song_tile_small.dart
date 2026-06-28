import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsuki/core/theme/app_colors.dart';

class SongTileSmall extends StatelessWidget {
  final String title;
  final String artist;
  final String thumbnail;
  final String duration;
  final String id;
  const SongTileSmall({
    super.key,
    required this.title,
    required this.artist,
    required this.thumbnail,
    required this.duration,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.terminalAmber),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.terminalAmber),
              ),
              child: CachedNetworkImage(
                imageUrl: thumbnail,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                placeholder: (context, url) => Container(
                    color: AppColors.terminalAmber.withOpacity(0.1)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.terminalAmber,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  artist,
                  style: TextStyle(
                    color: AppColors.terminalAmber,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  duration,
                  style: TextStyle(color: AppColors.terminalAmber),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
