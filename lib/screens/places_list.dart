import 'package:favorite_places/providers/place.dart';
import 'package:favorite_places/screens/map_view.dart';
import 'package:favorite_places/screens/new_place.dart';
import 'package:favorite_places/widgets/places_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesListScreen extends ConsumerStatefulWidget {
  const PlacesListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlacesListScreenState();
}

class _PlacesListScreenState extends ConsumerState<PlacesListScreen> {
  late Future<void> _placesFuture;
  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final placesList = ref.watch(placesProvider);
    Widget content = Center(
      child: Text(
        'No Places add yet!',
        style: Theme.of(context)
            .textTheme
            .bodyLarge
            ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );

    if (placesList.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapShot) =>
              snapShot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : PlacesList(placesList: placesList),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const NewPlaceScreen(),
              ),
            ),
            icon: const Icon(
              Icons.add,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MapViewScreen(),
                ));
              },
              icon: const Icon(Icons.map))
        ],
      ),
      body: content,
    );
  }
}
