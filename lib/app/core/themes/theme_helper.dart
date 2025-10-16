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
  Color get surfaceDim => AppColors.surfaceDim;
}

class _FontHelper {
  TextStyle headline({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.headline.copyWith(
        color: color ?? AppFonts.headline.color,
        fontSize: fontSize ?? AppFonts.headline.fontSize,
        fontWeight: weight ?? AppFonts.headline.fontWeight,
      );

  TextStyle title({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.title.copyWith(
        color: color ?? AppFonts.title.color,
        fontSize: fontSize ?? AppFonts.title.fontSize,
        fontWeight: weight ?? AppFonts.title.fontWeight,
      );

  TextStyle title2({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.title2.copyWith(
        color: color ?? AppFonts.title2.color,
        fontSize: fontSize ?? AppFonts.title2.fontSize,
        fontWeight: weight ?? AppFonts.title2.fontWeight,
      );

  TextStyle body({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.body.copyWith(
        color: color ?? AppFonts.body.color,
        fontSize: fontSize ?? AppFonts.body.fontSize,
        fontWeight: weight ?? AppFonts.body.fontWeight,
      );

  TextStyle description({Color? color, double? fontSize, FontWeight? weight}) =>
      AppFonts.description.copyWith(
        color: color ?? AppFonts.description.color,
        fontSize: fontSize ?? AppFonts.description.fontSize,
        fontWeight: weight ?? AppFonts.description.fontWeight,
      );
}
