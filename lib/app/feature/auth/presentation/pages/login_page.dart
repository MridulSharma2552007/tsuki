import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_bloc.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_event.dart';
import 'package:tsuki/app/feature/auth/bloc/auth_state.dart';
import 'package:tsuki/core/constants/ascii.dart';
import 'package:tsuki/core/theme/app_text_style.dart';
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
          if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error Logning")));
          }
        },
        builder: (context, state) {
          return PageView(
            controller: controller,
            children: [
              loginwidget(controller: controller),
              Column(children: [Center(child: Text('PAGE 1'))]),
            ],
          );
        },
      ),
    );
  }
}

class loginwidget extends StatefulWidget {
  final PageController _controller;
  const loginwidget({super.key, required PageController controller})
    : _controller = controller;

  @override
  State<loginwidget> createState() => _loginwidgetState();
}

class _loginwidgetState extends State<loginwidget> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  bool isValidPassword(String password) {
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
    );

    return regex.hasMatch(password);
  }

  void login() {
    final email = emailcontroller.text.trim();
    final password = passwordcontroller.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and password required')),
      );
      return;
    }

    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password must contain uppercase, lowercase, number and symbol',
          ),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
      LoginRequested(email: email, password: password),
    );
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
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF0A0A0A);
                      }
                      return const Color(0xFFFFB000);
                    }),
                  ),
                  onPressed: () => login(),
                  child: Text(
                    " > LOGIN",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: AppColors.primaryBg,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String obj;
  final TextEditingController textEditingController;
  const CustomTextField({
    super.key,
    required this.obj,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      style: const TextStyle(
        color: Color(0xFFFFB000),
        fontFamily: 'Courier',
        fontSize: 14,
      ),
      cursorColor: Color(0xFFFFB000),
      decoration: InputDecoration(
        hintText: obj,
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
    );
  }
}
