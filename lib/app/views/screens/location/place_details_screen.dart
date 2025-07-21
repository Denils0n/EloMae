import 'package:elomae/app/views/widgets/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:elomae/app/models/support_place_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final SupportPlace place;

  const PlaceDetailsScreen({super.key, required this.place});

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (place.photoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(place.photoUrl!),
              ),
            SizedBox(height: 16),
            Text("Nome: ${place.name}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("Latitude: ${place.latitude}"),
            Text("Longitude: ${place.longitude}"),
            if (place.address != null) ...[
              SizedBox(height: 8),
              Text("Endereço: ${place.address}"),
            ],
            if (place.phoneNumber != null) ...[
              SizedBox(height: 8),
              Text("Telefone: ${place.phoneNumber}"),
            ],
            if (place.website != null) ...[
              SizedBox(height: 8),
              GestureDetector(
                onTap: () => _launchURL(place.website!),
                child: Text(
                  "Website: ${place.website}",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
            ],
            if (place.openNow != null) ...[
              SizedBox(height: 8),
              Text("Aberto agora: ${place.openNow! ? 'Sim' : 'Não'}"),
            ],
            if (place.openingHours != null) ...[
              SizedBox(height: 8),
              Text("Horários de funcionamento:"),
              ...place.openingHours!.map((hour) => Text("- $hour")),
            ],
            if (place.rating != null) ...[
              SizedBox(height: 8),
              Text("Avaliação: ${place.rating}"),
            ],
            if (place.userRatingsTotal != null) ...[
              SizedBox(height: 4),
              Text("Total de avaliações: ${place.userRatingsTotal}"),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const Navigationbar(currentIndex: 0),
    );
  }
}