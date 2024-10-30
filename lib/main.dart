// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/user_provider.dart';
import './screens/onboarding/welcome_screen.dart';
import './screens/onboarding/user_info_screen.dart';
import './screens/main_layout.dart';
import 'config/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        title: 'NutriAge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          // Add other theme configurations
        ),
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}