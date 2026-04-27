import 'package:flutter/material.dart';
class AppConstants {
  static const String appName = "MediCore";
  static const String appVersion = "1.0.0";
  static const double cardElevation = 0.0; 
  static const String apiBaseUrl = "https://your-api-endpoint.com/v1";
  static const int uploadSizeLimitBytes = 5 * 1024 * 1024; 
  static const String geminiModel = "gemini-1.5-pro"; 
  static const int cacheDurationHours = 24; 

  // radius 
  static const double _baseRadius = 12.0;
  static const double radiusMedium     = _baseRadius;
  static const double radiusExtraSmall = _baseRadius / 4;
  static const double radiusSmall      = _baseRadius / 2;
  static const double radiusLarge      = _baseRadius * 1.5;

  //padding 
  static const double defaultPadding = 20.0;
  static const double _gridStep = 8.0;
  static const double paddingH = 12.0;
  static const double paddingV = 16.0;
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: paddingH,
    vertical: paddingV,
  );

}
