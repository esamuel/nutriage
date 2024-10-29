import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
  static const String _userKey = 'user_data';
  SharedPreferences? _prefs;
  
  String? _name;
  int? _age;
  double? _weight;
  double? _height;
  List<String> _healthConditions = [];
  List<String> _dietaryRestrictions = [];

  // Getters
  String? get name => _name;
  int? get age => _age;
  double? get weight => _weight;
  double? get height => _height;
  List<String> get healthConditions => _healthConditions;
  List<String> get dietaryRestrictions => _dietaryRestrictions;

  UserProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    await loadSavedData(); // Changed to use the unified loading method
  }

  Future<bool> loadSavedData() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      
      final userData = _prefs?.getString(_userKey);
      debugPrint('Loading stored user data: $userData');
      
      if (userData != null) {
        final data = json.decode(userData);
        _name = data['name'];
        _age = data['age'];
        _weight = data['weight']?.toDouble();
        _height = data['height']?.toDouble();
        _healthConditions = List<String>.from(data['healthConditions'] ?? []);
        _dietaryRestrictions = List<String>.from(data['dietaryRestrictions'] ?? []);
        notifyListeners();
        debugPrint('User data loaded successfully');
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error loading saved data: $e');
      return false;
    }
  }

  Future<bool> saveUserData() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }

      final userData = {
        'name': _name,
        'age': _age,
        'weight': _weight,
        'height': _height,
        'healthConditions': _healthConditions,
        'dietaryRestrictions': _dietaryRestrictions,
      };

      debugPrint('Attempting to save user data: $userData');
      
      final success = await _prefs!.setString(_userKey, json.encode(userData));
      
      if (success) {
        // Verify the data was saved
        final savedData = _prefs!.getString(_userKey);
        debugPrint('Verified saved data: $savedData');
        return savedData != null;
      }
      return false;
    } catch (e) {
      debugPrint('Error saving user data: $e');
      return false;
    }
  }

  Future<bool> updateUserInfo({
    required String name,
    required int age,
    required double height,
    required double weight,
  }) async {
    // Input validation
    if (name.isEmpty) {
      debugPrint('Invalid name');
      return false;
    }
    if (age <= 0 || age > 120) {
      debugPrint('Invalid age');
      return false;
    }
    if (height <= 0 || height > 300) { // Max height in cm
      debugPrint('Invalid height');
      return false;
    }
    if (weight <= 0 || weight > 500) { // Max weight in kg
      debugPrint('Invalid weight');
      return false;
    }

    debugPrint('Updating user info:');
    debugPrint('Name: $name');
    debugPrint('Age: $age');
    debugPrint('Height: $height cm');
    debugPrint('Weight: $weight kg');

    _name = name;
    _age = age;
    _height = height;
    _weight = weight;

    return saveUserData();
  }

  Future<bool> setHealthConditions(List<String> conditions) async {
    if (conditions.any((condition) => condition.isEmpty)) {
      debugPrint('Invalid health conditions: empty string found');
      return false;
    }
    
    debugPrint('Setting health conditions: $conditions');
    _healthConditions = conditions;
    return saveUserData();
  }

  Future<bool> setDietaryRestrictions(List<String> restrictions) async {
    if (restrictions.any((restriction) => restriction.isEmpty)) {
      debugPrint('Invalid dietary restrictions: empty string found');
      return false;
    }

    debugPrint('Setting dietary restrictions: $restrictions');
    _dietaryRestrictions = restrictions;
    return saveUserData();
  }

  Future<bool> clearUserData() async {
    try {
      if (_prefs == null) {
        _prefs = await SharedPreferences.getInstance();
      }
      
      final success = await _prefs!.remove(_userKey);
      if (success) {
        _name = null;
        _age = null;
        _weight = null;
        _height = null;
        _healthConditions = [];
        _dietaryRestrictions = [];
        notifyListeners();
        debugPrint('User data cleared successfully');
      }
      return success;
    } catch (e) {
      debugPrint('Error clearing user data: $e');
      return false;
    }
  }

  bool get hasData => _name != null && _age != null && _weight != null && _height != null;

  // Add unit constants
  static const String heightUnit = 'cm';
  static const String weightUnit = 'kg';

  // Add BMI calculation
  double? get bmi {
    if (_height == null || _weight == null) return null;
    final heightInMeters = _height! / 100; // Convert cm to meters
    return _weight! / (heightInMeters * heightInMeters);
  }
}
