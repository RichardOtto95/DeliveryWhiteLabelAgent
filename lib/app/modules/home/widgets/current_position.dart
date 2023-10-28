import 'package:delivery_agent_white_label/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:geolocator/geolocator.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../main/main_store.dart';

class CurrentPosition extends StatefulWidget {
  const CurrentPosition({Key? key}) : super(key: key);

  @override
  State<CurrentPosition> createState() => _CurrentPositionState();
}

class _CurrentPositionState extends State<CurrentPosition> {
  final MainStore mainStore = Modular.get();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DefaultAppBar("Localização atual"),
          Expanded(
            child: Observer(
              builder: (context) {
                if (mainStore.agentMap.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Map<String, dynamic> position = mainStore.agentMap["position"];
                return SfMaps(
                  layers: [
                    MapTileLayer(
                      initialFocalLatLng: MapLatLng(
                        position["latitude"]!,
                        position["longitude"]!,
                      ),
                      initialZoomLevel: 15,
                      initialMarkersCount: 1,
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      markerBuilder: (BuildContext context, int index) {
                        return MapMarker(
                          latitude: position["latitude"]!,
                          longitude: position["longitude"]!,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red[800],
                          ),
                          size: const Size(20, 20),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),

      // StreamBuilder<Position>(
      //   stream: Geolocator.getPositionStream(),
      //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapchat) {
      //     if (snapchat.hasData) {
      //       final Position currentLocation = snapchat.data;
      //       return SfMaps(
      //         layers: [
      //           MapTileLayer(
      //             initialFocalLatLng: MapLatLng(
      //                 currentLocation.latitude, currentLocation.longitude),
      //             initialZoomLevel: 5,
      //             initialMarkersCount: 1,
      //             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      //             markerBuilder: (BuildContext context, int index) {
      //               return MapMarker(
      //                 latitude: currentLocation.latitude,
      //                 longitude: currentLocation.longitude,
      //                 child: Icon(
      //                   Icons.location_on,
      //                   color: Colors.red[800],
      //                 ),
      //                 size: const Size(20, 20),
      //               );
      //             },
      //           ),
      //         ],
      //       );
      //     }
      //     return const Center(child: const CircularProgressIndicator());
      //   },
      // ),
    );
  }
}
