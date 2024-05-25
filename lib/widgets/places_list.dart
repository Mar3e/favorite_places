import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place.dart';
import 'package:favorite_places/screens/place_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({
    super.key,
    required this.placesList,
  });

  final List<Place> placesList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: placesList.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(placesList[index].id),
          onDismissed: (direction) =>
              ref.read(placesProvider.notifier).removePlace(placesList[index]),
          child: ListTile(
            leading: Hero(
              tag: placesList[index].id,
              child: CircleAvatar(
                radius: 24.0,
                backgroundImage: FileImage(
                  placesList[index].image,
                ),
              ),
            ),
            title: Text(
              placesList[index].name,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            subtitle: Text(
              placesList[index].location.address,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PlaceDetailsScreen(placesList[index]),
            )),
          ),
        );
      },
    );
  }
}
