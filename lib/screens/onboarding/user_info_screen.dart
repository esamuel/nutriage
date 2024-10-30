import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/session_manager.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  // Health conditions and dietary restrictions
  final List<String> _selectedHealthConditions = [];
  final List<String> _selectedDietaryRestrictions = [];

  final List<String> _healthConditions = [
    'Diabetes',
    'High Blood Pressure',
    'Heart Disease',
    'Arthritis',
    'Osteoporosis',
  ];

  final List<String> _dietaryRestrictions = [
    'Low-Salt',
    'Low-Sugar',
    'Low-Fat',
    'Vegetarian',
    'Dairy-Free',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _nameController.text.isNotEmpty && _ageController.text.isNotEmpty;
      case 1:
        return _weightController.text.isNotEmpty && _heightController.text.isNotEmpty;
      case 2:
        return true; // Optional selections
      default:
        return false;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.saveUserData(
          name: _nameController.text,
          age: int.parse(_ageController.text),
          weight: double.parse(_weightController.text),
          height: double.parse(_heightController.text),
          healthConditions: _selectedHealthConditions,
          dietaryRestrictions: _selectedDietaryRestrictions,
        );

        await SessionManager.setLoggedIn(true);
        
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving data: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.health_and_safety),
            onPressed: () {
              Navigator.pushNamed(context, '/health-tracker');
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            if (_currentStep < 2) {
              if (_validateCurrentStep()) {
                setState(() {
                  _currentStep++;
                });
              }
            } else {
              _submitForm();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() {
                _currentStep--;
              });
            }
          },
          steps: [
            Step(
              title: const Text('Basic Information'),
              content: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter your name' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter your age' : null,
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: const Text('Physical Measurements'),
              content: Column(
                children: [
                  TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(labelText: 'Weight (kg)'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter your weight' : null,
                  ),
                  TextFormField(
                    controller: _heightController,
                    decoration: const InputDecoration(labelText: 'Height (cm)'),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter your height' : null,
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: const Text('Health Information'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Health Conditions:'),
                  ..._healthConditions.map((condition) => CheckboxListTile(
                        title: Text(condition),
                        value: _selectedHealthConditions.contains(condition),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedHealthConditions.add(condition);
                            } else {
                              _selectedHealthConditions.remove(condition);
                            }
                          });
                        },
                      )),
                  const SizedBox(height: 16),
                  const Text('Dietary Restrictions:'),
                  ..._dietaryRestrictions.map((restriction) => CheckboxListTile(
                        title: Text(restriction),
                        value: _selectedDietaryRestrictions.contains(restriction),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value ?? false) {
                              _selectedDietaryRestrictions.add(restriction);
                            } else {
                              _selectedDietaryRestrictions.remove(restriction);
                            }
                          });
                        },
                      )),
                ],
              ),
              isActive: _currentStep >= 2,
            ),
          ],
        ),
      ),
    );
  }
}