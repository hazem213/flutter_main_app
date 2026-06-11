import 'package:flutter/material.dart';
import '../models/route_model.dart';

class ControlPanelWidget extends StatelessWidget {
  final bool isTracking;
  final double distanceKm;       // محتفظ بيه علشان الـ parent
  // محتفظ بيه علشان الـ parent
  final ActivityType activityType;
  final VoidCallback onStartStop;

  const ControlPanelWidget({
    super.key,
    required this.isTracking,
    required this.distanceKm,
    required this.activityType,
    required this.onStartStop,
  });

  String get _activityLabel {
    switch (activityType) {
      case ActivityType.standing: return 'Standing';  // ✅ ضيف
      case ActivityType.running:  return 'Running';
      case ActivityType.jogging:  return 'Jogging';
      case ActivityType.walking: return 'Walking';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ نوع النشاط بس
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_run, size: 20, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                _activityLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // ✅ زرار البدء/الإيقاف
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStartStop,
              icon: Icon(isTracking ? Icons.stop : Icons.play_arrow),
              label: Text(isTracking ? 'Stop' : 'Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isTracking ? Colors.red : Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}