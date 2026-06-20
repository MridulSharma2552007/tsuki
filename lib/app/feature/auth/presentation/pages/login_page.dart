import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_state.dart';
import 'package:tsuki/core/constants/ascii.dart';
import 'package:tsuki/utils/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error Logning")));
          }
        },
        builder: (context, state) {
          return PageView(children: [loginwidget()]);
        },
      ),
    );
  }
}

class loginwidget extends StatelessWidget {
  const loginwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            Ascii.onboardAscii,
            style: TextStyle(
              fontSize: 8,
              fontFamily: 'Courier',
              color: AppColors.secondary,
            ),
          ),
          Text(
            Ascii.tsukiArt,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Courier',
              color: AppColors.secondary,
            ),
          ),
          SizedBox(height: 40),
          TextField(
            style: const TextStyle(
              color: Color(0xFFFFB000),
              fontFamily: 'Courier',
              fontSize: 14,
            ),
            cursorColor: Color(0xFFFFB000),
            decoration: InputDecoration(
              hintText: 'EMAIL',
              hintStyle: TextStyle(
                color: const Color(0xFFFFB000).withOpacity(0.4),
                fontFamily: 'Courier',
                letterSpacing: 2,
              ),
              filled: true,
              fillColor: const Color(0xFF0A0A0A),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Color(0xFFFFB000), width: 1),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(color: Color(0xFFFFB000), width: 2),
              ),
              prefixText: '> ',
              prefixStyle: const TextStyle(
                color: Color(0xFFFFB000),
                fontFamily: 'Courier',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
