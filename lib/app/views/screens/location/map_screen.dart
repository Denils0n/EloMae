import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:elomae/app/view_models/map_viewmodel.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (_) => MapViewModel()..getCurrentLocation(),
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
              ),
              ...viewModel.supportPlaces.map((place) => Marker(
                markerId: MarkerId(place.name),
                position: LatLng(place.latitude, place.longitude),
                infoWindow: InfoWindow(title: place.name),
              )),
            };

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Pesquisar: CRAS, ONG...",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final keyword = _searchController.text;
                          if (keyword.isNotEmpty) {
                            viewModel.searchSupportPlaces(keyword);
                          }
                        },
                        child: Text("Buscar"),
                      )
                    ],
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
        bottomNavigationBar: const Navigationbar(currentIndex: 0),
      ),
    );
  }
}