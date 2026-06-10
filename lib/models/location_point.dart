class LocationPoint {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final DateTime timestamp;

  const LocationPoint({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'latitude': latitude,
    'longitude': longitude,
    'altitude': altitude,
    'speed': speed,
    'timestamp': timestamp.millisecondsSinceEpoch,
  };

  factory LocationPoint.fromMap(Map<String, dynamic> map) => LocationPoint(
    latitude: map['latitude'],
    longitude: map['longitude'],
    altitude: map['altitude'] ?? 0.0,
    speed: map['speed'] ?? 0.0,
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
  );
}