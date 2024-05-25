import 'dart:io';

import 'package:favorite_places/models/place.dart';
import 'package:favorite_places/providers/place.dart';
import 'package:favorite_places/widgets/image_picker.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final newPlaceController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _addNewPlace() {
    final enteredTitle = newPlaceController.text;
    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some inputs are missing'),
        ),
      );
      return;
    }

    ref.read(placesProvider.notifier).addPlace(
        title: enteredTitle,
        image: _selectedImage!,
        location: _selectedLocation!);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    newPlaceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Place!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
              decoration: const InputDecoration(
                label: Text('title'),
              ),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
              controller: newPlaceController,
            ),
            const SizedBox(height: 16.0),
            ImageInput(
              onPickImage: (image) => _selectedImage = image,
            ),
            const SizedBox(height: 16.0),
            LocationInput(
              onSelectLocation: (location) => _selectedLocation = location,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: _addNewPlace,
              icon: const Icon(Icons.add),
              label: const Text('Add Place!'),
            )
          ]),
        ),
      ),
    );
  }
}
