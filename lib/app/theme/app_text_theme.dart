import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tsuki/app/theme/app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  // Display / headings — Fraunces (serif). Used for screen titles, greetings,
  // playlist/card names — anywhere the app is "speaking" to the user.

  static TextStyle get screenTitleLarge => GoogleFonts.fraunces(
    fontSize: 27,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  static TextStyle get screenTitle => GoogleFonts.fraunces(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get cardTitle => GoogleFonts.fraunces(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle get cardTitleSmall => GoogleFonts.fraunces(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  // UI / body — DM Sans. Used for buttons, labels, list rows, nav,
  // timestamps — anywhere the app is showing data or controls.

  static TextStyle get body => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle get secondary => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get caption => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.inactive,
  );

  static TextStyle get buttonLabel => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.background, // cream text on ink buttons
  );

  static TextStyle get moodChip => GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ); // color set per-mood at the call site (e.g. AppColors.moodSkyText)
}
