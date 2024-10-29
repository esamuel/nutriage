import 'package:shared_preferences/shared_preferences.dart';
import './meal_service.dart';
import './health_service.dart';

class ServiceLocator {
  static MealService? _mealService;
  static HealthService? _healthService;

  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _mealService = MealService();
      _healthService = HealthService(prefs);
    } catch (e) {
      print('Error initializing services: $e');
      rethrow;
    }
  }

  static MealService get mealService {
    if (_mealService == null) {
      throw Exception('MealService not initialized');
    }
    return _mealService!;
  }

  static HealthService get healthService {
    if (_healthService == null) {
      throw Exception('HealthService not initialized');
    }
    return _healthService!;
  }
}