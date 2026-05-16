import 'package:flutter/material.dart';

abstract final class AppColors {
  // Figma: Global Colors
  static const brandPrimary = Color(0xFF8C5A3C);
  static const brandSecondary = Color(0xFFC08552);
  static const textPrimary = Color(0xFF4B2E2B);
  static const baseWhite = Color(0xFFFFFFFF);
  static const backgroundDefault = Color(0xFFFFF8F0);
  static const neutral300 = Color(0xFFD9D9D9);
  static const overlayScrim = Color(0x26000000);
  static const iconDefault = Color(0xFF1D1B20);

  // Semantic aliases used by the Flutter theme.
  static const background = backgroundDefault;
  static const surface = baseWhite;
  static const surfaceMuted = backgroundDefault;
  static const primary = brandPrimary;
  static const secondary = brandSecondary;
  static const accent = brandSecondary;
  static const textSecondary = brandPrimary;
  static const border = neutral300;
}
