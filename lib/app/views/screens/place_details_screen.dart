import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elomae/app/models/place_info_model.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final PlaceInfo place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  Map<String, dynamic>? firebaseData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFirebaseDetails();
  }

  Future<void> fetchFirebaseDetails() async {
    try {
      final latitude = widget.place.latitude;
      final longitude = widget.place.longitude;
      const delta = 0.0005;

      final querySnapshot = await FirebaseFirestore.instance
          .collection('locais')
          .where('latitude', isGreaterThanOrEqualTo: latitude - delta)
          .where('latitude', isLessThanOrEqualTo: latitude + delta)
          .get();

      final results = querySnapshot.docs.where((doc) {
        final lon = doc['longitude'];
        return lon >= longitude - delta && lon <= longitude + delta;
      }).toList();

      if (results.isNotEmpty) {
        setState(() {
          firebaseData = results.first.data();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false; // Nenhum resultado
        });
      }
    } catch (e) {
      print('Erro ao buscar detalhes no Firebase: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      appBar: AppBar(title: Text('Detalhes do Local')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    firebaseData?['nome'] ?? place.displayName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  firebaseData?['fotoUrl'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            firebaseData!['fotoUrl'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Imagem do Local',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                        ),

                  SizedBox(height: 20),

                  Text('Endereço:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(firebaseData?['endereco'] ?? place.displayName),

                  SizedBox(height: 16),

                  Text('Telefone:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(firebaseData?['telefone'] ?? 'Não informado'),

                  SizedBox(height: 16),

                  Text('Horário de Funcionamento:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(firebaseData?['horarios'] ?? 'Não informado'),

                  SizedBox(height: 16),

                  Text('Serviços Disponíveis:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(firebaseData?['servicos'] ?? 'Não informado'),

                  SizedBox(height: 20),
                  Divider(),

                  Text('Coordenadas:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Latitude: ${place.latitude}'),
                  Text('Longitude: ${place.longitude}'),
                ],
              ),
            ),
    );
  }
}
