import 'package:flutter/material.dart';

class MetricTypes {
  static const String bloodPressure = 'Blood Pressure';
  static const String bloodSugar = 'Blood Sugar';
  static const String weight = 'Weight';
  static const String heartRate = 'Heart Rate';

  static const Map<String, String> units = {
    bloodPressure: 'mmHg',
    bloodSugar: 'mg/dL',
    weight: 'kg',
    heartRate: 'bpm',
  };

  static const Map<String, IconData> icons = {
    bloodPressure: Icons.favorite,
    bloodSugar: Icons.water_drop,
    weight: Icons.monitor_weight,
    heartRate: Icons.heart_broken,
  };

  static const Map<String, Color> colors = {
    bloodPressure: Colors.red,
    bloodSugar: Colors.blue,
    weight: Colors.green,
    heartRate: Colors.purple,
  };
}

class HealthMetric {
  final String id;
  final String type;
  final dynamic value;
  final String unit;
  final DateTime timestamp;
  final String icon;
  final String color;

  HealthMetric({
    required this.id,
    required this.type,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value is Map ? value.toString() : value.toString(),
      'unit': unit,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'icon': icon,
      'color': color,
    };
  }

  factory HealthMetric.fromMap(Map<String, dynamic> map) {
    return HealthMetric(
      id: map['id'],
      type: map['type'],
      value: map['value'],
      unit: map['unit'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      icon: map['icon'],
      color: map['color'],
    );
  }

  String getDisplayValue() {
    if (value is Map) {
      return '${value['systolic']}/${value['diastolic']}';
    }
    return value.toString();
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return timestamp.toString().substring(0, 10);
    }
  }
}