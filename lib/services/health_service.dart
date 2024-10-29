import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HealthService {
  static const String _healthDataKey = 'health_data';
  static const String _medicationKey = 'medication_data';
  static const String _waterIntakeKey = 'water_intake';
  static const String _stepsKey = 'steps_data';
  
  final SharedPreferences _prefs;

  HealthService(this._prefs);

  Future<void> saveHealthMetrics({
    required int systolic,
    required int diastolic,
    required double bloodSugar,
  }) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'systolic': systolic,
      'diastolic': diastolic,
      'bloodSugar': bloodSugar,
    };

    final List<String> healthData = _prefs.getStringList(_healthDataKey) ?? [];
    healthData.add(json.encode(data));
    await _prefs.setStringList(_healthDataKey, healthData);
  }

  Future<List<Map<String, dynamic>>> getHealthMetrics() async {
    final List<String> healthData = _prefs.getStringList(_healthDataKey) ?? [];
    return healthData
        .map((String data) => json.decode(data) as Map<String, dynamic>)
        .toList();
  }

  Future<void> clearData() async {
    await _prefs.clear();
  }
}