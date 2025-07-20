import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/support_place_model.dart';

class MapViewModel extends ChangeNotifier {
  Position? currentPosition;
  List<SupportPlace> supportPlaces = [];

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    notifyListeners();
  }

  Future<void> loadSupportPlacesNearby() async {
    // Exemplo com dados estáticos
    supportPlaces = [
      SupportPlace(name: "CRAS Central", latitude: -23.56, longitude: -46.65),
      SupportPlace(name: "Delegacia da Mulher", latitude: -23.57, longitude: -46.64),
    ];
    notifyListeners();
  }
}
