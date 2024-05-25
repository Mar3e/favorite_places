import 'dart:convert';

import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  String get locationImageUrl {
    if (_pickedLocation != null) {
      final lat = _pickedLocation!.lat;
      final lon = _pickedLocation!.lon;

      return 'https://api.tomtom.com/map/1/staticimage?key=O4fV1WwCYTJwXeCOMAl6GPacBYzewjHv&zoom=16&center=$lon,$lat&format=jpg&layer=basic&style=main&width=600&height=300';
    }
    return '';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    final lat = locationData.latitude;
    final lon = locationData.longitude;

    if (lat == null || lon == null) {
      print('coordinates is missing');

      return;
    }

    final url = Uri.parse(
        'https://api.tomtom.com/search/2/reverseGeocode/$lat,$lon.json?key=O4fV1WwCYTJwXeCOMAl6GPacBYzewjHv&radius=100');

    final response = await http.get(url);

    final resDate = json.decode(response.body);

    final address = resDate['addresses'][0]['address']['freeformAddress'];

    setState(() {
      _pickedLocation = PlaceLocation(
        lat: lat,
        lon: lon,
        address: address,
      );
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location chosen',
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }
    return Column(
      children: [
        Container(
            height: 170,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current Location'),
            ),
          ],
        )
      ],
    );
  }
}
