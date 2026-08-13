import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme = GoogleFonts.interTextTheme().copyWith(
    headlineLarge: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),

    headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),

    titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),

    bodyLarge: const TextStyle(fontSize: 16),

    bodyMedium: const TextStyle(fontSize: 14),
  );
}
