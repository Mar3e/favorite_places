import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaceDetailsScreen extends ConsumerWidget {
  const PlaceDetailsScreen(this.place, {super.key});
  final Place place;

  String get locationImageUrl {
    final lat = place.location.lat;
    final lon = place.location.lon;

    return 'https://api.tomtom.com/map/1/staticimage?key=O4fV1WwCYTJwXeCOMAl6GPacBYzewjHv&zoom=15&center=$lon,$lat&format=jpg&layer=basic&style=main&width=600&height=300';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: Text(place.name),
        ),
        body: Stack(
          children: [
            Hero(
              tag: place.id,
              child: Image.file(
                place.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70.0,
                    backgroundImage: NetworkImage(locationImageUrl),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black54,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      place.location.address,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
