import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class SupportPlacesMap extends StatefulWidget {
  const SupportPlacesMap({super.key});
  @override
  State<SupportPlacesMap> createState() => _SupportPlacesMapState();
}

class _SupportPlacesMapState extends State<SupportPlacesMap> {
  LatLng? _userLocation;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadLocationAndPlaces();
  }

  Future<void> _loadLocationAndPlaces() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _userLocation = userLatLng;
      _markers.add(
        Marker(
          point: userLatLng,
          child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
        ),
      );
    });

    await _searchNearbyPlaces(userLatLng);
  }

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<void> _searchNearbyPlaces(LatLng location) async {
    final categorias = [
      'police', // delegacia
      'social_facility', // CRAS/ONGs
      'kindergarten', // creche
    ];

    for (final categoria in categorias) {
      final url =
          'https://nominatim.openstreetmap.org/search?format=json&limit=10&extratags=1&bounded=1'
          '&q=$categoria&lat=${location.latitude}&lon=${location.longitude}&radius=3000';

      final response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': 'flutter-app-mapa-locais-apoio'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        for (final item in data) {
          final lat = double.tryParse(item['lat'] ?? '');
          final lon = double.tryParse(item['lon'] ?? '');
          final nome = item['display_name'] ?? categoria;

          if (lat != null && lon != null) {
            _markers.add(
              Marker(
                point: LatLng(lat, lon),
                child: Tooltip(
                  message: nome,
                  child: Icon(Icons.location_on, color: Colors.red, size: 32),
                ),
              ),
            );
          }
        }
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locais de Apoio')),
      body: _userLocation == null
          ? Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: MapOptions(
                initialCenter: _userLocation!,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
    );
  }
}
