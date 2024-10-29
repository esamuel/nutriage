import 'package:flutter/foundation.dart';

class MealProvider with ChangeNotifier {
  List<Map<String, dynamic>> _meals = [];
  Map<String, dynamic>? _selectedMeal;

  List<Map<String, dynamic>> get meals => _meals;
  Map<String, dynamic>? get selectedMeal => _selectedMeal;

  void setMeals(List<Map<String, dynamic>> meals) {
    _meals = meals;
    notifyListeners();
  }

  void selectMeal(Map<String, dynamic> meal) {
    _selectedMeal = meal;
    notifyListeners();
  }
}