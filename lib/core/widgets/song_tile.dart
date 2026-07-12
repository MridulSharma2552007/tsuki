import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';
import 'package:tsuki/core/services/time_formatter.dart';

class SongTile extends StatelessWidget {
  final String title;
  final String artist;
  final Duration duration;
  final String imageUrl;
  final String channelid;
  const SongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.imageUrl,
    required this.channelid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.moodSky,

                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.music_note, size: 40);
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, maxLines: 2, style: AppTextTheme.body),
                  SizedBox(height: 4),
                  Text(
                    artist,
                    maxLines: 1,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Text(
              TimeFormatter.format(duration),

              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
