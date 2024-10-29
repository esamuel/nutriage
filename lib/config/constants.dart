import 'package:flutter/material.dart';

class AppConstants {
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 1500);
  
  // Padding & Spacing
  static const double defaultPadding = 24.0;
  static const double defaultSpacing = 16.0;
  
  // Button Properties
  static const double buttonHeight = 56.0;
  static const double buttonRadius = 12.0;
  
  // Text Sizes
  static const double headlineTextSize = 32.0;
  static const double bodyTextSize = 18.0;
  
  // Icon Sizes
  static const double welcomeIconSize = 80.0;
}

class AppAnimations {
  static final Curve defaultCurve = Curves.easeOut;
  static final Curve fadeInCurve = Curves.easeIn;
}