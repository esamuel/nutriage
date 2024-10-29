import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Form Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Selected values for lists
  final List<String> _selectedHealthConditions = [];
  final List<String> _selectedDietaryRestrictions = [];

  // Available options
  final List<String> _healthConditions = [
    'Diabetes',
    'High Blood Pressure',
    'Heart Disease',
    'High Cholesterol',
    'Arthritis',
    'Osteoporosis',
    'None of the above'
  ];

  final List<String> _dietaryRestrictions = [
    'Vegetarian',
    'Vegan',
    'Gluten-Free',
    'Dairy-Free',
    'Low-Sodium',
    'Low-Sugar',
    'No restrictions'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _saveUserInfo() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        final userProvider = Provider.of<UserProvider>(context, listen: false);

        // Save user data
        await userProvider.updateUserInfo(
          name: _nameController.text,
          age: int.parse(_ageController.text),
          height: double.parse(_heightController.text),
          weight: double.parse(_weightController.text),
        );

        await userProvider.setHealthConditions(_selectedHealthConditions);
        await userProvider.setDietaryRestrictions(_selectedDietaryRestrictions);

        if (mounted) {
          // Remove loading dialog
          Navigator.pop(context);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Information saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to main screen
          Navigator.pushReplacementNamed(context, '/main');
        }
      } catch (e) {
        if (mounted) {
          // Remove loading dialog
          Navigator.pop(context);

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _currentStep--;
                  });
                },
              )
            : null,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep++;
            });
          } else {
            _saveUserInfo();
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
            content: _buildBasicInfoForm(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Health Conditions'),
            content: _buildHealthConditionsForm(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Dietary Restrictions'),
            content: _buildDietaryRestrictionsForm(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
            ),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageController,
            decoration: const InputDecoration(
              labelText: 'Age',
              hintText: 'Enter your age',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your age';
              }
              final age = int.tryParse(value!);
              if (age == null || age < 1 || age > 120) {
                return 'Please enter a valid age';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _heightController,
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              hintText: 'Enter your height in centimeters',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your height';
              }
              final height = double.tryParse(value!);
              if (height == null || height < 50 || height > 250) {
                return 'Please enter a valid height';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _weightController,
            decoration: const InputDecoration(
              labelText: 'Weight (kg)',
              hintText: 'Enter your weight in kilograms',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter your weight';
              }
              final weight = double.tryParse(value!);
              if (weight == null || weight < 20 || weight > 300) {
                return 'Please enter a valid weight';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHealthConditionsForm() {
    return Column(
      children: _healthConditions.map((condition) {
        return CheckboxListTile(
          title: Text(condition),
          value: _selectedHealthConditions.contains(condition),
          onChanged: (bool? value) {
            setState(() {
              if (value ?? false) {
                if (condition == 'None of the above') {
                  _selectedHealthConditions.clear();
                } else {
                  _selectedHealthConditions.remove('None of the above');
                }
                _selectedHealthConditions.add(condition);
              } else {
                _selectedHealthConditions.remove(condition);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildDietaryRestrictionsForm() {
    return Column(
      children: _dietaryRestrictions.map((restriction) {
        return CheckboxListTile(
          title: Text(restriction),
          value: _selectedDietaryRestrictions.contains(restriction),
          onChanged: (bool? value) {
            setState(() {
              if (value ?? false) {
                if (restriction == 'No restrictions') {
                  _selectedDietaryRestrictions.clear();
                } else {
                  _selectedDietaryRestrictions.remove('No restrictions');
                }
                _selectedDietaryRestrictions.add(restriction);
              } else {
                _selectedDietaryRestrictions.remove(restriction);
              }
            });
          },
        );
      }).toList(),
    );
  }
}