import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class DirectionsGoogleMap {
  final LatLngBounds bounds;
  final String totalDistance;
  final String totalDuration;
  final num distanceValue;
  final num durationValue;
  final List<LatLng> polyPoints;

  const DirectionsGoogleMap({
    required this.bounds,
    required this.polyPoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceValue,
    required this.durationValue,
  });

  factory DirectionsGoogleMap.fromMap({
    required LatLng northeast,
    required LatLng southwest,
    required String distance,
    required String duration,
    required num distanceValue,
    required num durationValue,
    required List<LatLng> polyPoints,
  }) {
    LatLngBounds bounds = LatLngBounds(
      northeast: northeast,
      southwest: southwest,
    );

    return DirectionsGoogleMap(
      bounds: bounds,
      totalDistance: distance,
      totalDuration: duration,
      distanceValue: distanceValue,
      durationValue: durationValue, 
      polyPoints: polyPoints,
    );
  }
}

class DirectionsOSMap {
  final MapLatLngBounds bounds;
  final String totalDistance;
  final String totalDuration;
  final num distanceValue;
  final num durationValue;
  final List<MapLatLng> polyPoints;

  const DirectionsOSMap({
    required this.bounds,
    required this.polyPoints,
    required this.totalDistance,
    required this.totalDuration,
    required this.distanceValue,
    required this.durationValue,
  });

  factory DirectionsOSMap.fromOSMap({
    required MapLatLng northeast,
    required MapLatLng southwest,
    required String distance,
    required String duration,
    required num distanceValue,
    required num durationValue,
    required List<MapLatLng> polyPoints,
  }) {
    MapLatLngBounds bounds = MapLatLngBounds(
      northeast, 
      southwest,
    );

    return DirectionsOSMap(
      bounds: bounds,
      totalDistance: distance,
      totalDuration: duration,
      distanceValue: distanceValue,
      durationValue: durationValue, 
      polyPoints: polyPoints,
    );
  }
}
