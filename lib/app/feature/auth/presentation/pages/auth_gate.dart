import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:tsuki/core/config/env.dart';
import 'package:tsuki/core/constants/ascii.dart';
import 'package:tsuki/core/storage/secure_storage_service.dart';
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
  Future<bool> hasToken() async {
    final token = await SecureStorageService().getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> _handleStartup() async {
    final hasJwt = await hasToken();

    if (!mounted) return;

    if (hasJwt) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Stack(
          children: [ascii_widget(), initialization_text(_handleStartup)],
        ),
      ),
    );
  }
}

class initialization_text extends StatelessWidget {
  final VoidCallback onFinish;
  const initialization_text(this.onFinish, {super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
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
        onFinished: onFinish,
      ),
    );
  }
}

class ascii_widget extends StatelessWidget {
  const ascii_widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
