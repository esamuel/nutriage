import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SessionManager {
  static const String _isLoggedInKey = 'is_logged_in';
  
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      debugPrint('Error checking login status: $e');
      return false;
    }
  }

  static Future<bool> setLoggedIn(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_isLoggedInKey, value);
      return true;
    } catch (e) {
      debugPrint('Error setting login status: $e');
      return false;
    }
  }

  static Future<bool> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      return true;
    } catch (e) {
      debugPrint('Error clearing session: $e');
      return false;
    }
  }
}