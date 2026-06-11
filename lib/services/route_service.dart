import 'dart:math';
import '../models/location_point.dart';
import '../models/route_model.dart';

class RouteService {

  static double calculateDistance(List<LocationPoint> points) {
    if (points.length < 2) return 0;
    double total = 0;
    for (int i = 0; i < points.length - 1; i++) {
      total += _haversine(
        points[i].latitude, points[i].longitude,
        points[i + 1].latitude, points[i + 1].longitude,
      );
    }
    return total / 1000; // متر → كيلومتر
  }

  // Haversine formula - لحساب المسافة بين نقطتين على الكرة الأرضية
  static double _haversine(
      double lat1, double lon1, double lat2, double lon2) {

     const r = 6371000.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  static double _rad(double deg) => deg * pi / 180;

  static ActivityType detectActivity(List<LocationPoint> points) {
    if (points.length < 2) return ActivityType.standing;
    final p1 = points[points.length - 2];
    final p2 = points[points.length - 1];

         final dist = _haversine(
      p1.latitude, p1.longitude,
      p2.latitude, p2.longitude,
    );



    final seconds = p2.timestamp.difference(p1.timestamp).inMilliseconds / 1000.0;
    if (seconds <= 0) return ActivityType.standing;
    final kmh = (dist / seconds) * 3.6;

    if (kmh < 1.0)  return ActivityType.standing;

    if (kmh < 7.0)  return ActivityType.walking;
    if (kmh < 12.0) return ActivityType.jogging;
    return ActivityType.running;
  }
}