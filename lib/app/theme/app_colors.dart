import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base
  static const Color background = Color(0xFFF8F3E8);
  static const Color surface = Color(
    0xFF1D1B17,
  ); // ink — nav bar, buttons, mini player
  static const Color textPrimary = Color(0xFF221F1A);
  static const Color textSecondary = Color(0xFF6B685F);
  static const Color inactive = Color(0xFF9A9689);
  static const Color divider = Color(0xFFE4DDCC);

  // Mood colors — each pairs a light background with its own dark text.
  // Never mix a mood's background with textPrimary; always use its matching *Text color.
  static const Color moodSky = Color(0xFFC7E3F3);
  static const Color moodSkyText = Color(0xFF1B4D66);

  static const Color moodAmber = Color(0xFFF6C768);
  static const Color moodAmberText = Color(0xFF6B4707);

  static const Color moodRose = Color(0xFFF3C9D3);
  static const Color moodRoseText = Color(0xFF7A2E40);

  static const Color moodSage = Color(0xFFCFE0BE);
  static const Color moodSageText = Color(0xFF3C5A28);
}
