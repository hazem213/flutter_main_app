import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/location_point.dart';

class MapViewWidget extends StatelessWidget {
  final List<LocationPoint> points;
  final MapController mapController;

  const MapViewWidget({
    super.key,
    required this.points,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    final latLngPoints = points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: LatLng(29.3084, 30.8428),
        initialZoom: 15,
        minZoom: 12,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'assets/tiles/{z}/{x}/{y}.png',
          tileProvider: AssetTileProvider(),
          errorTileCallback: (tile, error, context) {},
        ),
        if (latLngPoints.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: latLngPoints,
                color: Colors.blue,
                strokeWidth: 4,
              ),
            ],
          ),
        if (latLngPoints.isNotEmpty)
          MarkerLayer(
            markers: [
              Marker(
                point: latLngPoints.first,
                child: const Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 16,
                ),
              ),
              Marker(
                point: latLngPoints.last,
                child: const Icon(
                  Icons.circle,
                  color: Colors.blue,
                  size: 28,
                ),
              ),
            ],
          ),
      ],
    );
  }
}