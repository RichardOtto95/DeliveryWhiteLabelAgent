import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_maps/maps.dart';
import 'dart:convert';

import '../../../core/models/directions_model.dart';

class NetworkHelper {
  NetworkHelper({
    required this.startLng,
    required this.startLat,
    required this.endLng,
    required this.endLat,
  });

  final String url = 'https://api.openrouteservice.org/v2/directions/';
  final String apiKey =
      '5b3ce3597851110001cf62480554d2fded59421a8a6a8f5c1a04099f';
  final String pathParam = 'driving-car'; // Change it if you want
  final double startLng;
  final double startLat;
  final double endLng;
  final double endLat;

  Future<Map> getData() async {
    // print('network_helper getData');
    http.Response response = await http.get(Uri.parse(
        '$url$pathParam?api_key=$apiKey&start=$startLng,$startLat&end=$endLng,$endLat'));

    // print('http.Response: $response');
    // print('http.Response.statusCode: ${response.statusCode}');
    if (response.statusCode == 200) {
      String data = response.body;

      var responseJson = jsonDecode(data);
      print(
          'responseJson: ${responseJson['features'][0]['properties']['summary']['duration']}');
      print(
          'responseJson: ${responseJson['features'][0]['properties']['summary']['distance']}');
      String distance = "";
      String duration = "";

      num durationSeconds =
          responseJson['features'][0]['properties']['summary']['duration'];
      num distanceM =
          responseJson['features'][0]['properties']['summary']['distance'];

      print("durationSeconds: $durationSeconds");

      if (durationSeconds > 60) {
        num durationMinutes = durationSeconds / 60;

        if (durationMinutes < 60) {
          duration = durationMinutes.toStringAsFixed(0) + "m";
        } else {
          num durationHour = durationMinutes / 60;

          duration = durationHour.toStringAsFixed(0) + "h";
        }
      } else {
        duration = durationSeconds.toStringAsFixed(0) + "s";
      }

      print("distanceM: $distanceM");

      if (distanceM > 1000) {
        num distanceKm = distanceM / 1000;
        print("distanceKm: $distanceKm");
        distance = distanceKm.toStringAsFixed(1) + "Km";
      } else {
        if (distanceM < 10) {
          distance = "Chegou";
        } else {
          distance = distanceM.toStringAsFixed(1) + "m";
        }
      }

      // print('responseJson: ${responseJson['features'][0]['bbox']}');

      List<dynamic> bbox = responseJson['features'][0]['bbox'];
      MapLatLng northeastOSM = MapLatLng(bbox[3], bbox[2]);
      MapLatLng southwestOSM = MapLatLng(bbox[1], bbox[0]);
      LatLng northeastGM = LatLng(bbox[3], bbox[2]);
      LatLng southwestGM = LatLng(bbox[1], bbox[0]);

      List<dynamic> coordinates =
          responseJson['features'][0]['geometry']['coordinates'];

      LineString ls = LineString(coordinates);

      List<MapLatLng> _polyPointsOSM = [];
      List<LatLng> _polyPointsGM = [];

      for (int i = 0; i < ls.lineString.length; i++) {
        _polyPointsOSM.add(MapLatLng(ls.lineString[i][1], ls.lineString[i][0]));
        _polyPointsGM.add(LatLng(ls.lineString[i][1], ls.lineString[i][0]));
      }

      return {
        "status": "SUCCESS",
        "error-code": null,
        "direction-OSM": DirectionsOSMap.fromOSMap(
          distance: distance,
          distanceValue: distanceM,
          duration: duration,
          durationValue: durationSeconds,
          northeast: northeastOSM,
          southwest: southwestOSM,
          polyPoints: _polyPointsOSM,
        ),
        "direction-googleMap": DirectionsGoogleMap.fromMap(
          distance: distance,
          distanceValue: distanceM,
          duration: duration,
          durationValue: durationSeconds,
          northeast: northeastGM,
          southwest: southwestGM,
          polyPoints: _polyPointsGM,
        ),
      };
    } else {
      // print(response.statusCode);
      // print("error on network helper");
      return {
        "status": "FAILED",
        "error-code": response.statusCode,
        "direction": null,
      };
    }
  }
}

class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}
