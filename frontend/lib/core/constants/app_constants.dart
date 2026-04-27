import 'package:flutter/material.dart';
class AppConstants {
  static const String appName = "MediCore";
  static const String appVersion = "1.0.0";
  static const double cardElevation = 0.0;

  /// Firebase Functions base URL.
  /// Format: https://<region>-<projectId>.cloudfunctions.net/<functionName>
  /// For local emulator: http://127.0.0.1:5001/healthlens-5fc36/us-central1/api
  static const String apiBaseUrl =
      'https://us-central1-healthlens-5fc36.cloudfunctions.net/api';

  static const int uploadSizeLimitBytes = 25 * 1024 * 1024; // 25MB

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
