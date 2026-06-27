import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsuki/core/theme/app_colors.dart';

class ArtistHomeBig extends StatelessWidget {
  final String artistName;
  final String artistImageUrl;
  final String ArtistPageUrl;
  const ArtistHomeBig({
    super.key,
    required this.artistName,
    required this.artistImageUrl,
    required this.ArtistPageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.terminalAmber),
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  artistImageUrl,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: AppColors.terminalAmber.withOpacity(0.1),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 10),
        SizedBox(
          width: 150,
          child: Text(
            artistName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.terminalAmber),
          ),
        ),
      ],
    );
  }
}
