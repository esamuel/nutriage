import 'package:flutter/material.dart';

class HealthTrackerScreen extends StatelessWidget {
  const HealthTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Health Metrics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Add your health tracking widgets here
            // This is a placeholder for now
            Card(
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('Heart Rate'),
                subtitle: const Text('Not measured yet'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Add functionality to record heart rate
                  },
                ),
              ),
            ),
            // Add more health metrics as needed
          ],
        ),
      ),
    );
  }
} 