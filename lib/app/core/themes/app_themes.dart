import 'package:flutter/material.dart';
import 'package:pawnco/app/core/themes/app_colors.dart';

import 'app_fonts.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      error: AppColors.warning,
    ),
    textTheme: TextTheme(
      headlineLarge: AppFonts.headline,
      titleLarge: AppFonts.title,
      titleMedium: AppFonts.title2,
      bodyLarge: AppFonts.body,
    ),
  );
}
