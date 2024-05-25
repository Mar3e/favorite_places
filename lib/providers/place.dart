import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPath;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _connectToDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'Places.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE favorite_places(id TEXT PRIMARY KEY,title TEXT, image TEXT, lat REAL,lng REAL,address TEXT)');
    },
    version: 1,
  );
  return db;
}

class PlaceNotifier extends StateNotifier<List<Place>> {
  PlaceNotifier() : super(const []);
  Future<void> loadPlaces() async {
    final db = await _connectToDataBase();
    final data = await db.query('favorite_places');

    final places = data
        .map(
          (record) => Place(
            id: record['id'] as String,
            name: record['title'] as String,
            image: File(record['image'] as String),
            location: PlaceLocation(
                address: record['address'] as String,
                lat: record['lat'] as double,
                lon: record['lng'] as double),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace({
    required String title,
    required File image,
    required PlaceLocation location,
  }) async {
    final appDir = await sysPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');
    final newPlace = Place(
      name: title,
      image: copiedImage,
      location: location,
    );
    final db = await _connectToDataBase();
    db.insert('favorite_places', {
      'id': newPlace.id,
      'title': newPlace.name,
      'image': newPlace.image.path,
      'lat': newPlace.location.lat,
      'lng': newPlace.location.lon,
      'address': newPlace.location.address,
    });
    state = [...state, newPlace];
  }

  void removePlace(Place place) {
    state = state.where((element) => element.id != place.id).toList();
  }
}

final placesProvider = StateNotifierProvider<PlaceNotifier, List<Place>>(
  (ref) => PlaceNotifier(),
);
