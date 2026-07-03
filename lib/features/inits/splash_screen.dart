import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuki/app/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      context.push('/onboard');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.textPrimary);
  }
}
