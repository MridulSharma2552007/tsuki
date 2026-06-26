import 'package:flutter/widgets.dart';
import 'package:tsuki/utils/app_colors.dart';

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
              borderRadius: BorderRadiusGeometry.circular(100),
              child: Image.network(artistImageUrl, fit: BoxFit.cover),
            ),
          ),
        ),

        SizedBox(height: 10),
        Text(artistName, style: TextStyle(color: AppColors.terminalAmber)),
      ],
    );
  }
}
