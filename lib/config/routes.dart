import 'package:flutter/material.dart';
import '../screens/onboarding/welcome_screen.dart';
import '../screens/onboarding/user_info_screen.dart';
import '../screens/health/sheets/health_tracking_screen.dart';
import '../screens/main_layout.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const WelcomeScreen(),
  '/user-info': (context) => const UserInfoScreen(),
  '/main': (context) => const MainLayout(),
  '/health-tracker': (context) => const HealthTrackingScreen(),
};