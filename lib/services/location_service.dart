import 'package:geolocator/geolocator.dart';
import '../models/location_point.dart';

class LocationService {
  Stream<LocationPoint> getLocationStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).map((position) => LocationPoint(
      latitude: position.latitude,
      longitude: position.longitude,
      altitude: position.altitude,
      speed: position.speed < 0 ? 0 : position.speed,
      timestamp: DateTime.now(),
    ));
  }
}