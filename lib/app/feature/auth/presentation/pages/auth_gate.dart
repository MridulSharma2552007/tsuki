import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:tsuki/core/config/env.dart';
import 'package:tsuki/core/constants/ascii.dart';
import 'package:tsuki/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  static const logs = [
    'initializing audio engine...',
    'loading playlists...',
    'checking session...',
    'ready.',
  ];

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Text(
                Ascii.onboardAscii,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 10,
                  color: AppColors.secondary,
                  height: 1.1,
                ),
              ),
            ),

            Positioned(
              left: 20,
              bottom: 20,
              child: AnimatedTextKit(
                animatedTexts: AuthGate.logs
                    .map(
                      (log) => TypewriterAnimatedText(
                        log,
                        textStyle: const TextStyle(
                          fontFamily: 'Courier',
                          fontSize: 10,
                          color: AppColors.secondary,
                        ),
                        speed: const Duration(milliseconds: 30),
                      ),
                    )
                    .toList(),
                totalRepeatCount: 1,
                onFinished: () {
                  // Navigate to login page after animation finishes
                  context.go('/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
