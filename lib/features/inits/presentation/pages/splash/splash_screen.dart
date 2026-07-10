import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/core/constants/auth_keys.dart';
import 'package:tsuki/core/services/shared_preference_storage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? isLoggedIn() {
    return SharedPreferenceStorageService.instance.getBool(
      key: AuthKeys.isLoggedin,
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      isLoggedIn() == true ? context.push('/shell') : context.push('/onboard');

      print(isLoggedIn());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.textPrimary);
  }
}
