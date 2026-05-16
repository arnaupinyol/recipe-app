import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const fontFamily = 'Roboto Serif';

  static const textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      height: 1.1,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      height: 1.1,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      height: 1.2,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 20,
      height: 1.1,
      fontWeight: FontWeight.w800,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.375,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.57,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.375,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 15,
      height: 1.47,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 12,
      height: 1.83,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.375,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.baseWhite,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.57,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 10,
      height: 2.2,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: AppColors.textPrimary,
    ),
  );
}
