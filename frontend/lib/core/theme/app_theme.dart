import 'package:flutter/material.dart';
import '../constants/app_constants.dart'; 

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF0F766E); 
  static const Color backgroundColor = Color(0xFFFFFFFF); 
  static const Color surfaceColor = Color(0xFFF8FAFC); 
  static const Color borderColor = Color(0xFFE2E8F0); 
  static const Color textPrimary = Color(0xFF0F172A); 
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        background: backgroundColor,
        surface: surfaceColor,
        onPrimary: Colors.white,
        onBackground: textPrimary,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0, 
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: AppTypography.metricDisplay),
        headlineLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: AppTypography.headingLarge, letterSpacing: -0.5),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: AppTypography.headingMedium),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: AppTypography.titleLarge),
        titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: AppTypography.titleMedium),
        bodyLarge: TextStyle(color: textPrimary, fontSize: AppTypography.bodyLarge),
        bodyMedium: TextStyle(color: textMuted, fontSize: AppTypography.bodyMedium, height: 1.5),
        labelSmall: TextStyle(color: textMuted, fontSize: AppTypography.labelTiny, letterSpacing: 0.5),
      ),
    );
  }
}
