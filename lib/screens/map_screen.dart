import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_point.dart';
import '../models/route_model.dart';
import '../services/location_service.dart';
import '../services/route_service.dart';
import '../utils/permissions.dart';
import '../widgets/map_view_widget.dart';
import '../widgets/control_panel_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final LocationService _locationService = LocationService();

  StreamSubscription<LocationPoint>? _locationSub;
  List<LocationPoint> _points = [];
  bool _isTracking = false;
  DateTime? _startTime;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  double get _distance => RouteService.calculateDistance(_points);
  double get _speed => _points.isEmpty ? 0 : _points.last.speed * 3.6;
  ActivityType get _activity => _isTracking
      ? RouteService.detectActivity(_points)
      : ActivityType.standing;

  Future<void> _toggle() async {
    _isTracking ? await _stop() : await _start();
  }

  Future<void> _start() async {
    final ok = await Permissions.requestLocation();
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Waiting for permission')),
      );
      return;
    }
    setState(() {
      _isTracking = true;
      _points = [];
      _startTime = DateTime.now();
      _elapsed = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed = DateTime.now().difference(_startTime!));
    });
    _locationSub = _locationService.getLocationStream().listen((point) {
      setState(() => _points.add(point));
      _mapController.move(
        LatLng(point.latitude, point.longitude),
        _mapController.camera.zoom,
      );
    });
  }

  Future<void> _stop() async {
    _locationSub?.cancel();
    _timer?.cancel();
    setState(() => _isTracking = false);
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // ✅ مفيش زرار history
      ),
      body: Column(
        children: [
          Expanded(
            child: MapViewWidget(
              points: _points,
              mapController: _mapController,
            ),
          ),
          ControlPanelWidget(
            isTracking: _isTracking,
            distanceKm: _distance,

            activityType: _activity,
            onStartStop: _toggle,
          ),
        ],
      ),
    );
  }
}