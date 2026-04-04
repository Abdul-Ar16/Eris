import 'package:flutter/material.dart';

class ErisColors {
  static const Color background = Color(0xFF000000); // True Black
  static const Color surface = Color(0xFF121212);    // Dark Surface
  static const Color surfaceVariant = Color(0xFF1E1E1E);
  
  static const Color primary = Color(0xFF2D6BFF);
  static const Color primaryLight = Color(0xFF5E8BFF);
  
  static const Color danger = Color(0xFFFF3B3B);
  static const Color warning = Color(0xFFFF9500);
  static const Color success = Color(0xFF34C759);

  static const Color floodHigh = Color(0xFFB71C1C);
  static const Color floodWarning = Color(0xFFE65100);

  static const Color riskHigh = Color(0xFFB71C1C);
  static const Color riskMedium = Color(0xFFF57C00);
  static const Color riskSafe = Color(0xFF2E7D32);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white38;
}

class ErisTheme {
  static ThemeData build() {
    const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ErisColors.primary,
      onPrimary: Colors.white,
      secondary: ErisColors.primaryLight,
      onSecondary: Colors.white,
      surface: ErisColors.surface,
      onSurface: ErisColors.textPrimary,
      error: ErisColors.danger,
      onError: Colors.white,
      outline: Colors.white24,
      surfaceVariant: ErisColors.surfaceVariant,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ErisColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: ErisColors.background,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: ErisColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.white10),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ErisColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ErisColors.primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: ErisColors.textSecondary),
        hintStyle: const TextStyle(color: ErisColors.textTertiary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ErisColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white24),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: ErisColors.textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: ErisColors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: ErisColors.textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: ErisColors.textPrimary),
        bodyMedium: TextStyle(color: ErisColors.textSecondary),
      ),
    );
  }
}
