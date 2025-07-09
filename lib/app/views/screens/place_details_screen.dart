import 'package:flutter/material.dart';
import 'package:elomae/app/models/place_info_model.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final PlaceInfo place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Localll'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Endereço:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(place.displayName),
            SizedBox(height: 16),
            Text('Latitude: ${place.latitude}'),
            Text('Longitude: ${place.longitude}'),
          ],
        ),
      ),
    );
  }
}
