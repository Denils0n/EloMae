import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/support_place_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MapViewModel extends ChangeNotifier {
  Position? currentPosition;
  List<SupportPlace> supportPlaces = [];

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return;

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    notifyListeners();
  }

  Future<void> searchSupportPlaces(String keyword) async {
    if (currentPosition == null) return;

    final lat = currentPosition!.latitude;
    final lng = currentPosition!.longitude;
    final radius = 3000; // 3km
    final apiKey = dotenv.env['GOOGLE_API_KEY'];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&keyword=$keyword&key=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final results = jsonData['results'];

      supportPlaces = results.map<SupportPlace>((place) {
        final location = place['geometry']['location'];
        return SupportPlace(
          placeId: place['place_id'], // ADICIONADO
          name: place['name'],
          latitude: location['lat'],
          longitude: location['lng'],
        );
      }).toList();

      notifyListeners();
    } else {
      print("Erro ao buscar lugares: ${response.body}");
    }
  }

  // NOVA FUNÇÃO: Buscar detalhes completos do local
  Future<SupportPlace?> fetchPlaceDetails(String placeId) async {
    final apiKey = dotenv.env['GOOGLE_API_KEY'];

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId'
      '&fields=place_id,name,geometry,formatted_address,formatted_phone_number,opening_hours,rating,user_ratings_total,website,photos'
      '&key=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = data['result'];

        if (result != null) {
          final location = result['geometry']['location'];

          return SupportPlace(
            placeId: result['place_id'],
            name: result['name'],
            address: result['formatted_address'],
            phoneNumber: result['formatted_phone_number'],
            latitude: location['lat'],
            longitude: location['lng'],
            openingHours: result['opening_hours']?['weekday_text']?.join('\n'),
            rating: result['rating']?.toDouble(),
            userRatingsTotal: result['user_ratings_total'],
            website: result['website'],
            photoUrl: result['photos'] != null && result['photos'].isNotEmpty
              ? result['photos'][0]['photo_reference']
              : null,
          );
        }
      } else {
        print('Erro ao buscar detalhes do local: ${response.statusCode}');
      }
    } catch (e) {
      print('Exceção ao buscar detalhes do local: $e');
    }

    return null;
  }
}
