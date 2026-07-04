import 'package:flutter/material.dart';
import 'package:tsuki/app/theme/app_colors.dart';
import 'package:tsuki/app/theme/app_text_theme.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onPress;

  const PrimaryButton({super.key, required this.onPress, required this.label});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _scale = 0.97);
      },
      onTapUp: (_) {
        setState(() => _scale = 1.0);
      },
      onTapCancel: () {
        setState(() => _scale = 1.0);
      },
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(350, 60),
            backgroundColor: AppColors.surface,
            elevation: 4,
            shadowColor: Colors.black26,
            overlayColor: AppColors.textSecondary.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          onPressed: widget.onPress,
          child: Text(widget.label, style: AppTextTheme.buttonLabel),
        ),
      ),
    );
  }
}
