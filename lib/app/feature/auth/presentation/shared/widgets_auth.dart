import 'package:flutter/material.dart';
import 'package:tsuki/core/constants/ascii.dart';
import 'package:tsuki/utils/app_colors.dart';

bool isValidPassword(String password) {
  final regex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$',
  );
  return regex.hasMatch(password);
}

class TerminalOverlay {
  static void show(BuildContext context, String message) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 50,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.terminalSurface,
              border: Border.all(color: AppColors.terminalAmber),
            ),
            child: Text(
              '> $message',
              style: const TextStyle(
                color: AppColors.terminalAmber,
                fontFamily: 'Courier',
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(
      const Duration(seconds: 3),
      () => entry.remove(),
    );
  }
}

class tsukiascii extends StatelessWidget {
  const tsukiascii({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      Ascii.tsukiArt,
      style: TextStyle(
        fontSize: 12,
        fontFamily: 'Courier',
        color: AppColors.secondary,
      ),
    );
  }
}

class logoascii extends StatelessWidget {
  const logoascii({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      Ascii.onboardAscii,
      style: TextStyle(
        fontSize: 8,
        fontFamily: 'Courier',
        color: AppColors.secondary,
      ),
    );
  }
}

class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              return AppColors.terminalSurface;
            }
            return AppColors.terminalAmber;
          }),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Courier',
            color: AppColors.primaryBg,
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
        color: AppColors.terminalAmber,
        fontFamily: 'Courier',
        fontSize: 14,
      ),
      cursorColor: AppColors.terminalAmber,
      decoration: InputDecoration(
        hintText: obj,
        hintStyle: TextStyle(
          color: AppColors.terminalAmber.withOpacity(0.4),
          fontFamily: 'Courier',
          letterSpacing: 2,
        ),
        filled: true,
        fillColor: AppColors.terminalSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.terminalAmber, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: AppColors.terminalAmber, width: 2),
        ),
        prefixText: '> ',
        prefixStyle: const TextStyle(
          color: AppColors.terminalAmber,
          fontFamily: 'Courier',
        ),
      ),
    );
  }
}
