import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  final double lat;
  final double lon;
  final String address;

  PlaceLocation({required this.lat, required this.lon, required this.address});
}

class Place {
  Place({
    String? id,
    required this.name,
    required this.image,
    required this.location,
  }) : id = id ?? uuid.v4();

  final String id;
  final String name;
  final File image;
  final PlaceLocation location;
}
