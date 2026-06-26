import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_event.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_state.dart';
import 'package:tsuki/app/feature/auth/presentation/pages/register_page.dart';
import 'package:tsuki/app/feature/auth/presentation/shared/widgets_auth.dart';
import 'package:tsuki/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.primaryBg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerificationRequired) {
            TerminalOverlay.show(
              context,
              "TRANSMISSION COMPLETE\nAN OTP HAS BEEN SENT TO YOUR EMAIL.\nCHECK YOUR SPAM FOLDER.",
            );
            context.push('/verify/${state.email}');
          } else if (state is Authenticated) {
            context.go('/root');
          }
        },
        builder: (context, state) {
          return PageView(
            controller: controller,
            children: [
              LoginWidget(controller: controller),
              RegisterPage(controller: controller),
            ],
          );
        },
      ),
    );
  }
}

class LoginWidget extends StatefulWidget {
  final PageController _controller;
  const LoginWidget({super.key, required PageController controller})
    : _controller = controller;

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  void login() {
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
      LoginRequested(email: email, password: password),
    );
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logoascii(),
              tsukiascii(),
              SizedBox(height: 40),
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
                    onTap: () => widget._controller.animateToPage(
                      1,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: Text(
                      'New Here Create a account?',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22),
              AuthButton(label: " > LOGIN", onPressed: () => login()),
            ],
          ),
        ),
      ),
    );
  }
}
