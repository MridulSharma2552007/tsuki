import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuki/features/auth/bloc/auth_bloc.dart';
import 'package:tsuki/features/auth/bloc/auth_event.dart';
import 'package:tsuki/features/auth/presentation/shared/widgets_auth.dart';
import 'package:tsuki/core/theme/app_text_style.dart';

class RegisterPage extends StatefulWidget {
  final PageController controller;
  const RegisterPage({super.key, required this.controller});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();

  void register() {
    final email = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();

    if (email.isEmpty || password.isEmpty) {
      TerminalOverlay.show(context, 'Email and password required');
      return;
    }

    if (!isValidPassword(password)) {
      TerminalOverlay.show(
        context,
        'Password must contain uppercase, lowercase, number and symbol',
      );
      return;
    }

    context.read<AuthBloc>().add(
      RegisterRequested(email: email, password: password),
    );
    TerminalOverlay.show(
      context,
      "TRANSMISSION COMPLETE \nAN OTP HAS BEEN SENT TO YOUR EMAIL ADDRESS.\nIF THE MESSAGE IS NOT VISIBLE,\nPLEASE CHECK YOUR SPAM FOLDER.",
    );
    context.push('/verify/$email');
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              logoascii(),
              SizedBox(height: 20),
              tsukiascii(),
              SizedBox(height: 20),
              CustomTextField(
                obj: 'EMAIL',
                textEditingController: emailcontroller,
              ),
              SizedBox(height: 40),
              CustomTextField(
                obj: 'PASSWORD',
                textEditingController: passwordcontroller,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => widget.controller.animateToPage(
                      0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: Text(
                      'Already a User Login >',
                      style: AppTextStyles.terminal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AuthButton(label: '> REGISTER', onPressed: () => register()),
            ],
          ),
        ),
      ),
    );
  }
}
