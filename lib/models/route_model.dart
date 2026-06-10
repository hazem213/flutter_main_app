import 'dart:convert';
import 'location_point.dart';

enum ActivityType { stationary , walk, jog, run }

class RouteModel {
  final int? id;
  final String name;
  final DateTime startTime;
  final DateTime? endTime;
  final List<LocationPoint> points;
  final double distanceKm;
  final ActivityType activityType;

  const RouteModel({
    this.id,
    required this.name,
    required this.startTime,
    this.endTime,
    required this.points,
    required this.distanceKm,
    required this.activityType,
  });

  Duration get duration =>
      (endTime ?? DateTime.now()).difference(startTime);

  double get avgSpeedKmh {
    if (points.isEmpty) return 0;
    final avg = points.map((p) => p.speed).reduce((a, b) => a + b) / points.length;
    return avg * 3.6;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'startTime': startTime.millisecondsSinceEpoch,
    'endTime': endTime?.millisecondsSinceEpoch,
    'points': jsonEncode(points.map((p) => p.toMap()).toList()),
    'distanceKm': distanceKm,
    'activityType': activityType.name,
  };

  factory RouteModel.fromMap(Map<String, dynamic> map) => RouteModel(
    id: map['id'],
    name: map['name'],
    startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
    endTime: map['endTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(map['endTime'])
        : null,
    points: (jsonDecode(map['points']) as List)
        .map((p) => LocationPoint.fromMap(p))
        .toList(),
    distanceKm: map['distanceKm'],
    activityType: ActivityType.values.byName(map['activityType']),
  );
}