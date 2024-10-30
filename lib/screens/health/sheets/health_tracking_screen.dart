import 'package:flutter/material.dart';

class HealthTrackingScreen extends StatelessWidget {
  const HealthTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracking'),
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
            _buildMetricCard(
              icon: Icons.favorite,
              title: 'Heart Rate',
              onAdd: () {
                // Add heart rate tracking logic
              },
            ),
            _buildMetricCard(
              icon: Icons.directions_walk,
              title: 'Steps',
              onAdd: () {
                // Add steps tracking logic
              },
            ),
            _buildMetricCard(
              icon: Icons.local_dining,
              title: 'Blood Sugar',
              onAdd: () {
                // Add blood sugar tracking logic
              },
            ),
            _buildMetricCard(
              icon: Icons.speed,
              title: 'Blood Pressure',
              onAdd: () {
                // Add blood pressure tracking logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String title,
    required VoidCallback onAdd,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: const Text('Not measured yet'),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: onAdd,
        ),
      ),
    );
  }
} 