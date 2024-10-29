import 'package:http/http.dart' as http;
import 'dart:convert';

class MealService {
  static const String apiKey = 'YOUR_SPOONACULAR_API_KEY';
  static const String baseUrl = 'https://api.spoonacular.com/recipes';

  Future<List<Map<String, dynamic>>> getDailyMeals({
    required int targetCalories,
    List<String> diet = const [],
    List<String> exclude = const [],
  }) async {
    try {
      // Placeholder for API integration
      return [
        {
          'id': 1,
          'title': 'Breakfast',
          'calories': 300,
          'time': '8:00 AM'
        },
        {
          'id': 2,
          'title': 'Lunch',
          'calories': 500,
          'time': '12:00 PM'
        },
        {
          'id': 3,
          'title': 'Dinner',
          'calories': 600,
          'time': '6:00 PM'
        }
      ];
    } catch (e) {
      throw Exception('Failed to load meals: $e');
    }
  }

  Future<Map<String, dynamic>> getMealDetails(int mealId) async {
    try {
      // Placeholder for meal details
      return {
        'id': mealId,
        'title': 'Sample Meal',
        'calories': 300,
        'protein': 20,
        'carbs': 40,
        'fat': 10
      };
    } catch (e) {
      throw Exception('Failed to load meal details: $e');
    }
  }
}