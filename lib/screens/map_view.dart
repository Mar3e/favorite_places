import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('map from tomtom'),
      ),
      body: FlutterMap(
        options: const MapOptions(
            initialCenter: LatLng(21.4241, 39.8173), initialZoom: 13),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            // 'https://api.tomtom.com/map/1/tile/basic/main/{z}/{x}/{y}.png?key=O4fV1WwCYTJwXeCOMAl6GPacBYzewjHv',
            userAgentPackageName: 'com.example.app',
          ),
        ],
      ),
    );
  }
}
