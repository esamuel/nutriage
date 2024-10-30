import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProvider with ChangeNotifier {
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

  Future<void> saveUserData({
    required String name,
    required int age,
    required double weight,
    required double height,
    required List<String> healthConditions,
    required List<String> dietaryRestrictions,
  }) async {
    _name = name;
    _age = age;
    _weight = weight;
    _height = height;
    _healthConditions = healthConditions;
    _dietaryRestrictions = dietaryRestrictions;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final userData = {
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
      'healthConditions': healthConditions,
      'dietaryRestrictions': dietaryRestrictions,
    };
    await prefs.setString('userData', json.encode(userData));
    notifyListeners();
  }

  Future<bool> loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString('userData');
      
      if (savedData != null) {
        final userData = json.decode(savedData) as Map<String, dynamic>;
        
        _name = userData['name'] as String;
        _age = userData['age'] as int;
        _weight = (userData['weight'] as num).toDouble();
        _height = (userData['height'] as num).toDouble();
        _healthConditions = List<String>.from(userData['healthConditions']);
        _dietaryRestrictions = List<String>.from(userData['dietaryRestrictions']);
        
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error loading user data: $e');
      return false;
    }
  }

  void clearData() {
    _name = null;
    _age = null;
    _weight = null;
    _height = null;
    _healthConditions = [];
    _dietaryRestrictions = [];
    notifyListeners();
  }
}