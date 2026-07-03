import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;
  const PrimaryButton({super.key, required this.onPress, required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(350, 60),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      onPressed: onPress,
      child: Text(label, style: AppTextTheme.buttonLabel),
    );
  }
}
