import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsuki/core/theme/app_colors.dart';

class AlbumHomeBig extends StatelessWidget {
  final String imageUrl;
  final String title;
  const AlbumHomeBig({super.key, required this.imageUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.terminalAmber),
            ),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 150,
              height: 100,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              placeholder: (context, url) => Container(
                  color: AppColors.terminalAmber.withOpacity(0.1)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        SizedBox(
          width: 150,
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            title,
            style: TextStyle(color: AppColors.terminalAmber, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
