import 'package:flutter/foundation.dart';
import '../models/health_metrics.dart';

class HealthProvider extends ChangeNotifier {
  List<HealthMetric> _metrics = [];

  List<HealthMetric> get metrics => List.unmodifiable(_metrics);

  void addMetric(HealthMetric metric) {
    _metrics.add(metric);
    // Sort metrics by timestamp, most recent first
    _metrics.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  void deleteMetric(String id) {
    _metrics.removeWhere((metric) => metric.id == id);
    notifyListeners();
  }
}