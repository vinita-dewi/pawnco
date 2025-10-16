import 'package:flutter/material.dart';
import 'package:pawnco/app/core/themes/app_fonts.dart';

import 'app_colors.dart';

class AppThemeHelper {
  static _ColorHelper get color => _ColorHelper();
  static _FontHelper get font => _FontHelper();
}

class _ColorHelper {
  Color get primary => AppColors.primary;
  Color get secondary => AppColors.secondary;
  Color get background => AppColors.background;
  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get warning => AppColors.warning;
}

class _FontHelper {
  TextStyle headline({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.headline.copyWith(
        color: color ?? AppFonts.title.color,
        fontSize: fontSize ?? AppFonts.title.fontSize,
        fontWeight: weight ?? AppFonts.title.fontWeight,
      );

  TextStyle title({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.title.copyWith(
        color: color ?? AppFonts.title.color,
        fontSize: fontSize ?? AppFonts.title.fontSize,
        fontWeight: weight ?? AppFonts.title.fontWeight,
      );

  TextStyle title2({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.title2.copyWith(
        color: color ?? AppFonts.title.color,
        fontSize: fontSize ?? AppFonts.title.fontSize,
        fontWeight: weight ?? AppFonts.title.fontWeight,
      );

  TextStyle body({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.body.copyWith(
        color: color ?? AppFonts.title.color,
        fontSize: fontSize ?? AppFonts.title.fontSize,
        fontWeight: weight ?? AppFonts.title.fontWeight,
      );
}
