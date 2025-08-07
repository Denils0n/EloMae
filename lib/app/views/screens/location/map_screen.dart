import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:elomae/app/view_models/map_viewmodel.dart';
import 'package:elomae/app/views/screens/location/place_details_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedTipo; // Armazena a opção escolhida

  final List<String> _tipos = [
    "Todos",
    "cras",
    "ongs",
    "creas",
    "prefeitura",
    "usf",
    "delegacia",
    "Creche Pública",
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (_) => MapViewModel()
        ..getCurrentLocation()
        ..fetchSupportPlacesFromFirestore(), // Carrega todos no início
      child: Scaffold(
        appBar: AppBar(title: Text("Mapa de Apoio")),
        body: Consumer<MapViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.currentPosition == null) {
              return Center(child: CircularProgressIndicator());
            }

            final LatLng currentLatLng = LatLng(
              viewModel.currentPosition!.latitude,
              viewModel.currentPosition!.longitude,
            );

            Set<Marker> markers = {
              Marker(
                markerId: MarkerId("me"),
                position: currentLatLng,
                infoWindow: InfoWindow(title: "Você está aqui"),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
              ),
              ...viewModel.supportPlaces.map(
                (place) => Marker(
                  markerId: MarkerId(place.nome),
                  position: LatLng(place.latitude, place.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
                  infoWindow: InfoWindow(title: place.nome),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PlaceDetailsScreen(place: place),
                      ),
                    );
                  },
                ),
              ),
            };

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedTipo,
                    hint: Text("Selecione o tipo de local"),
                    isExpanded: true,
                    items: _tipos.map((String tipo) {
                      return DropdownMenuItem<String>(
                        value: tipo,
                        child: Text(tipo),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedTipo = value);

                      // Se for "Todos", carrega todos
                      if (value == "Todos") {
                        viewModel.fetchSupportPlacesFromFirestore();
                      } else {
                        viewModel.fetchSupportPlacesFromFirestore(keyword: value);
                      }
                    },
                  ),
                ),
                Expanded(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: currentLatLng,
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    markers: markers,
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const Navigationbar(currentIndex: 1),
      ),
    );
  }
}
