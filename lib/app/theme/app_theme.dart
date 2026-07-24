import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 5,
    useMaterial3: true,
    textTheme: AppTypography.textTheme,
  );
}