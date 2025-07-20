import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:elomae/app/view_models/map_view_model.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>(
      create: (_) => MapViewModel()
        ..getCurrentLocation()
        ..loadSupportPlacesNearby(),
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
              ...viewModel.supportPlaces.map(
                (place) => Marker(
                  markerId: MarkerId(place.name),
                  position: LatLng(place.latitude, place.longitude),
                  infoWindow: InfoWindow(title: place.name),
                ),
              ),
            };

            return GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentLatLng,
                zoom: 14,
              ),
              myLocationEnabled: true,
              markers: markers,
              onMapCreated: (controller) {},
            );
          },
        ),
      ),
    );
  }
}
