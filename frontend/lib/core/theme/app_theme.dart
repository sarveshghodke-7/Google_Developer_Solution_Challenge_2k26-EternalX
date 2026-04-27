import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
  static const Color primaryColor = Color(0xFF0F766E); 
  static const Color backgroundColor = Color(0xFFFFFFFF); 
  static const Color surfaceColor = Color(0xFFF8FAFC); 
  static const Color borderColor = Color(0xFFE2E8F0); 
  static const Color textPrimary = Color(0xFF0F172A); 
  static const Color textMuted = Color(0xFF64748B);

  static const Color darkBackgroundColor = Color(0xFF020817); 
  static const Color darkSurfaceColor = Color(0xFF0F172A);    
  static const Color darkBorderColor = Color(0xFF1E293B);    
  static const Color darkTextPrimary = Color(0xFFF8FAFC);   
  static const Color darkTextMuted = Color(0xFF94A3B8);       
  static const Color darkPrimaryColor = Color(0xFF2DD4BF);   

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
      textTheme: _buildTextTheme(textPrimary, textMuted, primaryColor),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: darkBackgroundColor,
      colorScheme: const ColorScheme.dark(
        primary: darkPrimaryColor,
        background: darkBackgroundColor,
        surface: darkSurfaceColor,
        onPrimary: darkBackgroundColor,
        onBackground: darkTextPrimary,
        onSurface: darkTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackgroundColor,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      textTheme: _buildTextTheme(darkTextPrimary, darkTextMuted, darkPrimaryColor),
    );
  }

  static TextTheme _buildTextTheme(Color mainText, Color mutedText, Color primary) {
    return TextTheme(
      displayLarge: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: AppTypography.metricDisplay),
      headlineLarge: TextStyle(color: mainText, fontWeight: FontWeight.bold, fontSize: AppTypography.headingLarge, letterSpacing: -0.5),
      headlineMedium: TextStyle(color: mainText, fontWeight: FontWeight.bold, fontSize: AppTypography.headingMedium),
      titleLarge: TextStyle(color: mainText, fontWeight: FontWeight.w600, fontSize: AppTypography.titleLarge),
      titleMedium: TextStyle(color: mainText, fontWeight: FontWeight.w600, fontSize: AppTypography.titleMedium),
      bodyLarge: TextStyle(color: mainText, fontSize: AppTypography.bodyLarge),
      bodyMedium: TextStyle(color: mutedText, fontSize: AppTypography.bodyMedium, height: 1.5),
      labelSmall: TextStyle(color: mutedText, fontSize: AppTypography.labelTiny, letterSpacing: 0.5),
    );
  }
}
