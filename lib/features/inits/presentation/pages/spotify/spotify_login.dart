import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';
import 'package:tsuki/core/widgets/buttons.dart';
import 'package:tsuki/features/inits/presentation/pages/onboard/widgets/page_zero_onboard.dart';
import 'dart:ui';

import 'package:tsuki/features/inits/presentation/pages/spotify/spotify_connect.dart';

class SpotifyLogin extends StatefulWidget {
  const SpotifyLogin({super.key});

  @override
  State<SpotifyLogin> createState() => _SpotifyLoginState();
}

class _SpotifyLoginState extends State<SpotifyLogin> {
  @override
  Widget build(BuildContext context) {
    final screenheight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.only(top: screenheight * 0.07),
        child: Center(
          child: Column(
            children: [
              Text('>ᴗ< Hum', style: AppTextTheme.screenTitle),
              SizedBox(height: screenheight * 0.1),
              introcontainer(
                screenheight: screenheight,
                onboardcolor: AppColors.moodSky,
              ),
              SizedBox(height: screenheight * 0.07),
              Text(
                "Let's find your \n sound",
                style: AppTextTheme.screenTitleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenheight * 0.03),
              Text(
                "Connect Spotify so we can bring in\n your playlists, liked songs ,and the \n artists you already love.Nothing\n plays until you're ready.",
                style: AppTextTheme.secondary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenheight * 0.03),
              PrimaryButton(
                onPress: () {
                  print("Button pressed");

                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SpotifyConnect()),
                    );
                  } catch (e, s) {
                    print(e);
                    print(s);
                  }
                },
                label: "ᯤ  Connect with Spotify",
              ),
              SizedBox(height: screenheight * 0.03),
              Text(
                "Not now, just let me look around",
                style: AppTextTheme.secondary,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenheight * 0.02),
              Text(
                "We only read your playlists and library.\n Nothing is ever posted on your behalf",
                style: AppTextTheme.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
