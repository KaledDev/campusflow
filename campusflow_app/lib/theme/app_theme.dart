import 'package:flutter/material.dart';

class AppTheme {
  // Palette issue du Design System v1 (contraste >= 4.5:1 pour les textes)
  static const Color primaryColor = Color(0xFF0F4C81);
  static const Color secondaryAccentColor = Color(0xFFB45309);
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color surfaceVariantColor = Color(0xFFF8FAFC);
  static const Color textPrimaryColor = Color(0xFF111827);
  static const Color textSecondaryColor = Color(0xFF475569);
  static const Color borderColor = Color(0xFFCBD5E1);
  static const Color successColor = Color(0xFF15803D);
  static const Color errorColor = Color(0xFFB91C1C);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryAccentColor,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      surface: backgroundColor,
      onSurface: textPrimaryColor,
      surfaceContainerHighest: surfaceVariantColor,
      onSurfaceVariant: textSecondaryColor,
      outline: borderColor,
    );

    const textTheme = TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimaryColor,
        height: 1.3,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryColor,
        height: 1.35,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textSecondaryColor,
        height: 1.3,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimaryColor,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceVariantColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderColor, width: 1.5),
        ),
      ),
    );
  }
}
