import 'package:flutter/material.dart';

class KomkanTheme {
  // Brand Colors
  static const Color background = Color(0xFF0C0D12);
  static const Color cardBackground = Color(0xFF14151B);
  static const Color border = Color(0xFF22242E);
  static const Color primaryCyan = Color(0xFF00E5FF);
  static const Color accentPurple = Color(0xFF6B11F4);
  static const Color badgePink = Color(0xFFFF2D55);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8F90A6);

  static const Color backgroundLight = Color(0xFFF7F8FC);
  static const Color cardBackgroundLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE6E8F0);
  static const Color textPrimaryLight = Color(0xFF161B26);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryCyan,
      colorScheme: const ColorScheme.light(
        primary: primaryCyan,
        secondary: accentPurple,
        surface: cardBackgroundLight,
        background: backgroundLight,
        error: badgePink,
      ),
      fontFamily: 'Google Sans',
      cardTheme: const CardThemeData(
        color: cardBackgroundLight,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderLight, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: cardBackgroundLight,
        hintStyle: TextStyle(
          color: textSecondaryLight,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.1,
        ),
        labelStyle: TextStyle(
          color: primaryCyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderLight, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryCyan, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF0C0D12),
          backgroundColor: primaryCyan,
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          shadowColor: primaryCyan.withOpacity(0.4),
          elevation: 8,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimaryLight,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          height: 1.2,
        ),
        titleMedium: TextStyle(
          color: textPrimaryLight,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimaryLight, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondaryLight, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryCyan,
      colorScheme: const ColorScheme.dark(
        primary: primaryCyan,
        secondary: accentPurple,
        surface: cardBackground,
        background: background,
        error: badgePink,
      ),
      fontFamily: 'Google Sans',
      cardTheme: const CardThemeData(
        color: cardBackground,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF14151B),
        hintStyle: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.1,
        ),
        labelStyle: TextStyle(
          color: primaryCyan,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: border, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryCyan, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xFF0C0D12),
          backgroundColor: primaryCyan,
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          shadowColor: primaryCyan.withOpacity(0.4),
          elevation: 8,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
          height: 1.2,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      ),
    );
  }

  // Custom glows and shadows
  static List<BoxShadow> get cyanGlow => [
    BoxShadow(
      color: primaryCyan.withOpacity(0.3),
      blurRadius: 12,
      spreadRadius: 2,
    ),
  ];

  static List<BoxShadow> get purpleGlow => [
    BoxShadow(
      color: accentPurple.withOpacity(0.4),
      blurRadius: 10,
      spreadRadius: 1,
    ),
  ];
}
