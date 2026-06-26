import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_event.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_state.dart';
import 'package:tsuki/app/feature/auth/presentation/shared/widgets_auth.dart';
import 'package:tsuki/core/theme/app_text_style.dart';
import 'package:tsuki/utils/app_colors.dart';

class VerifyPage extends StatefulWidget {
  final String email;
  const VerifyPage({super.key, required this.email});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final codeController = TextEditingController();

  void verify() {
    final code = codeController.text.trim();
    if (code.isEmpty || code.length < 6) {
      TerminalOverlay.show(context, 'Enter a valid 6-digit code');
      return;
    }
    context.read<AuthBloc>().add(
      VerifyRequested(email: widget.email, code: code),
    );
    TerminalOverlay.show(context, 'Account Verified You can Log in Now');
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            TerminalOverlay.show(context, state.message);
          } else if (state is Authenticated) {
            context.go('/root');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    logoascii(),
                    const SizedBox(height: 20),
                    tsukiascii(),
                    const SizedBox(height: 40),
                    Text('VERIFY OTP', style: AppTextStyles.terminalTitle),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'your data is safe, we store our data in AWS Mumbai server',
                            textStyle: const TextStyle(
                              fontFamily: 'Courier',
                              fontSize: 10,
                              color: AppColors.secondary,
                            ),
                            speed: const Duration(milliseconds: 30),
                          ),
                        ],
                        totalRepeatCount: 1,
                        isRepeatingAnimation: false,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomTextField(
                      obj: '6-DIGIT CODE',
                      textEditingController: codeController,
                    ),
                    const SizedBox(height: 30),
                    AuthButton(
                      label: '> VERIFY',
                      onPressed: state is AuthLoading ? () {} : verify,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
