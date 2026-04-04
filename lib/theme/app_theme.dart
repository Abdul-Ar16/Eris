import 'package:flutter/material.dart';

class ErisColors {
  static const Color background = Color(0xFF141414);
  static const Color card = Color(0xFF1E1E1E);
  static const Color borderBlue = Color(0xFF2D6BFF);

  static const Color floodHigh = Color(0xFF7A3B3B);
  static const Color floodWarning = Color(0xFFB06A2E);

  static const Color riskHigh = Color(0xFF7A2D2D);
  static const Color riskMedium = Color(0xFFC0832E);
  static const Color riskSafe = Color(0xFF2F7A3A);

  static const Color primary = Color(0xFF2D6BFF);
  static const Color danger = Color(0xFFC43B3B);
}

class ErisTheme {
  static ThemeData build() {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ErisColors.primary,
      secondary: ErisColors.borderBlue,
      surface: ErisColors.card,
      error: ErisColors.danger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onError: Colors.white,
      outline: Colors.white24,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ErisColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: ErisColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ErisColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

