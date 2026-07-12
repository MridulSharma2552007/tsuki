import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.1),
          Text("Your library", style: AppTextTheme.screenTitleLarge),
          Text(
            "Everything you've saved, all in one place",
            style: AppTextTheme.secondary,
          ),
        ],
      ),
    );
  }
}
