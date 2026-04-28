import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "MediCore";
  static const String appVersion = "1.2.1";

  // API
  // static const String apiBaseUrl = "http://127.0.0.1:5001/healthlens-5fc36/us-central1/api";
  static const String apiBaseUrl = "http://127.0.0.1:8080";
  static const String geminiModel = "gemini-1.5-pro"; 
  static const int uploadSizeLimitBytes = 5 * 1024 * 1024; // 5MB 
  static const int cacheDurationHours = 24; 

  // Radius
  static const double _baseRadius = 12.0;
  static const double radiusExtraSmall = _baseRadius / 4;  // 3.0
  static const double radiusSmall      = _baseRadius / 2;  // 6.0
  static const double radiusMedium     = _baseRadius;      // 12.0 
  static const double radiusLarge      = _baseRadius * 1.5; // 18.0 

  // Padding 
  static const double _gridStep = 8.0;
  
  static const double paddingXS = _gridStep * 0.5; // 4.0
  static const double paddingS  = _gridStep;       // 8.0
  static const double paddingM  = _gridStep * 1.5; // 12.0 
  static const double paddingL  = _gridStep * 2.0; // 16.0 
  static const double paddingXL = _gridStep * 3.0; // 24.0

  // Standard flat elevation 
  static const double cardElevation = 0.0; 

  static const EdgeInsets screenPadding = EdgeInsets.all(24.0);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: paddingM,
    vertical: paddingL,  
  );

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: paddingL,
    vertical: paddingL,  
  );
  
  static const EdgeInsets tightPadding = EdgeInsets.symmetric(
    horizontal: paddingM,
    vertical: paddingS,
  );
}

class AppTypography {
  static const double _baseSize = 14.0; 
  static const double _ratio = 1.25; 

  // --- 2. The Scale Steps (Calculated automatically) ---
  static const double _stepUp1 = _ratio;              // 1.25
  static const double _stepUp2 = _stepUp1 * _ratio;   // 1.56
  static const double _stepUp3 = _stepUp2 * _ratio;   // 1.95
  static const double _stepUp4 = _stepUp3 * _ratio;   // 2.44
  static const double _stepUp5 = _stepUp4 * _ratio;   // 3.05
  
  static const double _stepDown1 = 1 / _ratio;        // 0.80

  static const double labelTiny     = _baseSize * _stepDown1; // 11.2px (Dates, tags)
  static const double bodyMedium    = _baseSize;              // 14.0px (Standard reading)
  
  static const double bodyLarge     = _baseSize * 1.15;       // 16.1px (Button text)
  static const double titleMedium   = _baseSize * _stepUp1;   // 17.5px (Card sub-headers)
  static const double titleLarge    = _baseSize * _stepUp2;   // 21.8px (Card Titles, App Bar)

  static const double headingMedium = _baseSize * _stepUp3;   // 27.3px (Section Headers)
  static const double headingLarge  = _baseSize * _stepUp4;   // 34.1px (Main Screen Titles)
  
  static const double metricDisplay = _baseSize * _stepUp5;   // 42.7px ("185 bpm" on Dashboard)
}
