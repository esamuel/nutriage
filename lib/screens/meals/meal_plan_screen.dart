// lib/screens/meals/meal_plan_screen.dart

import 'package:flutter/material.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: const Center(
        child: Text('Meal Plan Screen'),
      ),
    );
  }
}

