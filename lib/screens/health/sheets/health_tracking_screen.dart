import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/health_metrics.dart';
import '../../../providers/health_provider.dart';

class HealthTrackingScreen extends StatelessWidget {
  const HealthTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Health Tracking',
                style: TextStyle(color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHealthMetrics(context),
                const SizedBox(height: 24),
                _buildMedicationReminders(context),
                const SizedBox(height: 24),
                _buildExerciseTracking(context),
                const SizedBox(height: 24),
                _buildHealthGoals(context),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMetricDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
 Widget _buildHealthMetrics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Health Metrics',
            onAdd: () => _showAddMetricDialog(context)),
        const SizedBox(height: 16),
        Consumer<HealthProvider>(
          builder: (context, healthProvider, child) {
            final metrics = healthProvider.metrics;
            
            if (metrics.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No health metrics recorded yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return Column(
              children: metrics.map((metric) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: _MetricCard(
                    title: metric.type,
                    value: metric.getDisplayValue(),
                    unit: metric.unit,
                    time: metric.getTimeAgo(),
                    icon: MetricTypes.icons[metric.type] ?? Icons.favorite,
                    color: MetricTypes.colors[metric.type] ?? Colors.blue,
                    onTap: () {},
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMedicationReminders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Medication Reminders', 
          onAdd: () => _showAddMedicationDialog(context)),
        const SizedBox(height: 16),
        _MedicationCard(
          name: 'Vitamin D',
          dosage: '1000 IU',
          time: '8:00 AM',
          taken: true,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _MedicationCard(
          name: 'Blood Pressure Medicine',
          dosage: '50mg',
          time: '9:00 PM',
          taken: false,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildExerciseTracking(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Exercise Tracking', 
          onAdd: () => _showAddExerciseDialog(context)),
        const SizedBox(height: 16),
        _ExerciseCard(
          type: 'Walking',
          duration: '30 min',
          calories: '150',
          time: 'Today, 10:00 AM',
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _ExerciseCard(
          type: 'Stretching',
          duration: '15 min',
          calories: '45',
          time: 'Today, 8:00 AM',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildHealthGoals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Health Goals', 
          onAdd: () => _showAddGoalDialog(context)),
        const SizedBox(height: 16),
        _GoalCard(
          title: 'Daily Steps',
          target: '10,000',
          current: '7,500',
          unit: 'steps',
          progress: 0.75,
          onTap: () {},
        ),
        const SizedBox(height: 8),
        _GoalCard(
          title: 'Water Intake',
          target: '8',
          current: '6',
          unit: 'glasses',
          progress: 0.75,
          onTap: () {},
        ),
      ],
    );
  }
 Widget _buildSectionHeader(String title, {VoidCallback? onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (onAdd != null)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onAdd,
          ),
      ],
    );
  }

  void _showAddMetricDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddMetricSheet(
        onMetricAdded: (metric) {
          context.read<HealthProvider>().addMetric(metric);
        },
      ),
    );
  }

  void _showAddMedicationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AddMedicationSheet(),
    );
  }

  void _showAddExerciseDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AddExerciseSheet(),
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _AddGoalSheet(),
    );
  }
}

// Card Widgets
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String time;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.time,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    const SizedBox(height: 4),
                    Text(
                      '$value $unit',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Medication Card
class _MedicationCard extends StatelessWidget {
  final String name;
  final String dosage;
  final String time;
  final bool taken;
  final VoidCallback onTap;

  const _MedicationCard({
    required this.name,
    required this.dosage,
    required this.time,
    required this.taken,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: taken ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  taken ? Icons.check_circle : Icons.alarm,
                  color: taken ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name),
                    const SizedBox(height: 4),
                    Text(
                      dosage,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Exercise Card
class _ExerciseCard extends StatelessWidget {
  final String type;
  final String duration;
  final String calories;
  final String time;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.type,
    required this.duration,
    required this.calories,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.directions_run, color: Colors.blue),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(type),
                        const SizedBox(height: 4),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '$calories cal',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Goal Card
class _GoalCard extends StatelessWidget {
  final String title;
  final String target;
  final String current;
  final String unit;
  final double progress;
  final VoidCallback onTap;

  const _GoalCard({
    required this.title,
    required this.target,
    required this.current,
    required this.unit,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
                  Text(
                    '$current/$target $unit',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 // Add Metric Sheet
class _AddMetricSheet extends StatefulWidget {
  final Function(HealthMetric)? onMetricAdded;

  const _AddMetricSheet({this.onMetricAdded});

  @override
  State<_AddMetricSheet> createState() => _AddMetricSheetState();
}

class _AddMetricSheetState extends State<_AddMetricSheet> {
  String? _selectedMetricType;
  final _formKey = GlobalKey<FormState>();
  
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final metric = _createMetric();
      widget.onMetricAdded?.call(metric);
      Navigator.pop(context);
    }
  }

  HealthMetric _createMetric() {
    dynamic value;
    if (_selectedMetricType == MetricTypes.bloodPressure) {
      value = {
        'systolic': int.parse(_systolicController.text),
        'diastolic': int.parse(_diastolicController.text),
      };
    } else {
      value = double.parse(_valueController.text);
    }

    return HealthMetric(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedMetricType!,
      value: value,
      unit: MetricTypes.units[_selectedMetricType]!,
      timestamp: DateTime.now(),
      icon: MetricTypes.icons[_selectedMetricType].toString(),
      color: MetricTypes.colors[_selectedMetricType].toString(),
    );
  }

  String? _validateNumericField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Health Metric',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Metric Type',
                border: OutlineInputBorder(),
              ),
              value: _selectedMetricType,
              items: [
                MetricTypes.bloodPressure,
                MetricTypes.bloodSugar,
                MetricTypes.weight,
                MetricTypes.heartRate,
              ].map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              )).toList(),
              validator: (value) =>
                value == null ? 'Please select a metric type' : null,
              onChanged: (value) {
                setState(() {
                  _selectedMetricType = value;
                  _systolicController.clear();
                  _diastolicController.clear();
                  _valueController.clear();
                });
              },
            ),
            const SizedBox(height: 16),
            if (_selectedMetricType == MetricTypes.bloodPressure) ...[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _systolicController,
                      decoration: const InputDecoration(
                        labelText: 'Systolic',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateNumericField(value, 'systolic value'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolicController,
                      decoration: const InputDecoration(
                        labelText: 'Diastolic',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => _validateNumericField(value, 'diastolic value'),
                    ),
                  ),
                ],
              ),
            ] else if (_selectedMetricType != null) ...[
              TextFormField(
                controller: _valueController,
                decoration: InputDecoration(
                  labelText: 'Value',
                  border: const OutlineInputBorder(),
                  suffixText: MetricTypes.units[_selectedMetricType],
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumericField(value, 'value'),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Add Metric'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// Add Medication Sheet
class _AddMedicationSheet extends StatelessWidget {
  const _AddMedicationSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Medication',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add form fields here
        ],
      ),
    );
  }
}

// Add Exercise Sheet
class _AddExerciseSheet extends StatelessWidget {
  const _AddExerciseSheet();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Exercise',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add form fields here
        ],
      ),
    );
  }
}

// Add Goal Sheet
class _AddGoalSheet extends StatelessWidget {
  const _AddGoalSheet();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Add Health Goal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Add form fields here
        ],
      ),
    );
  }
} 