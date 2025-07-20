import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:elomae/app/models/place_info_model.dart';
import 'package:elomae/app/views/screens/place_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupportPlacesMap extends StatefulWidget {
  const SupportPlacesMap({super.key});
  @override
  State<SupportPlacesMap> createState() => _SupportPlacesMapState();
}

class _SupportPlacesMapState extends State<SupportPlacesMap> {
  LatLng? _userLocation;
  List<Marker> _markers = [];
  String _searchQuery = '';
  final List<String> _suggestions = [
    'CRAS',
    'CREAS',
    'Escola Municipal',
    'Creche Municipal',
    'Delegacia da Mulher',
    'Hospital',
    'Posto de Saúde',
    'Defensoria pública',
    'Coordenadoria da mulher',

  ];
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _userLocation = userLatLng;
      _markers = [
        Marker(
          point: userLatLng,
          child: Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
        ),
      ];
    });
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

  Future<void> _searchByQuery(String query) async {
    if (_userLocation == null || query.isEmpty) return;

    final lat = _userLocation!.latitude;
    final lon = _userLocation!.longitude;

    final url =
        'https://nominatim.openstreetmap.org/search?format=json&limit=10&extratags=1'
        '&q=$query'
        '&viewbox=${lon - 0.03},${lat + 0.03},${lon + 0.03},${lat - 0.03}'
        '&bounded=1';

    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'flutter-app-mapa-locais-apoio'},
    );

    List<dynamic> results = [];

    if (response.statusCode == 200) {
      results = json.decode(response.body);
    }

    // Limpa marcadores antigos, exceto o do usuário
    setState(() {
      _markers = _markers
          .where(
            (m) =>
                m.child is Icon &&
                (m.child as Icon).icon == Icons.person_pin_circle,
          )
          .toList();
    });

    if (results.isNotEmpty) {
      for (final item in results) {
        final lat = double.tryParse(item['lat'] ?? '');
        final lon = double.tryParse(item['lon'] ?? '');
        if (lat != null && lon != null) {
          final place = PlaceInfo.fromJson(item);
          _addMarkerFromPlace(place, lat, lon);
        }
      }
    } else {
      // Busca no Firestore pelo tipo igual ao termo
      final snapshot = await FirebaseFirestore.instance
          .collection('locais')
          .where('tipo', isEqualTo: query.toLowerCase())
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final lat = data['latitude'];
        final lon = data['longitude'];
        final nome = data['nome'] ?? query;

        if (lat != null && lon != null) {
          final place = PlaceInfo(
            displayName: nome,
            latitude: lat.toDouble(),
            longitude: lon.toDouble(),
          );
          _addMarkerFromPlace(place, lat.toDouble(), lon.toDouble());
        }
      }

      if (snapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nenhum local "$query" encontrado na região.'),
          ),
        );
      }
    }
  }

  void _addMarkerFromPlace(PlaceInfo place, double lat, double lon) {
    setState(() {
      _markers.add(
        Marker(
          point: LatLng(lat, lon),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailsScreen(place: place),
                ),
              );
            },
            child: Tooltip(
              message: place.displayName,
              child: Icon(
                Icons.location_on,
                color: const Color.fromARGB(255, 244, 54, 171),
                size: 32,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Locais de Apoio')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RawAutocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _suggestions.where(
                  (option) => option.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              textEditingController: _textController,
              onSelected: (String selection) {
                _searchQuery = selection;
                _searchByQuery(selection);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar locais...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        _searchQuery = value;
                      },
                      onSubmitted: (value) {
                        _searchQuery = value;
                        _searchByQuery(value);
                      },
                      textInputAction: TextInputAction.search,
                    );
                  },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);
                        return ListTile(
                          title: Text(option),
                          onTap: () => onSelected(option),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: _userLocation == null
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
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
