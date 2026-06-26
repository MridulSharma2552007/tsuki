import 'package:flutter/widgets.dart';
import 'package:tsuki/utils/app_colors.dart';

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
            child: Image.network(imageUrl, fit: BoxFit.cover),
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
