import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elomae/app/models/support_place_model.dart';

class MapViewModel extends ChangeNotifier {
  Position? currentPosition;
  List<SupportPlace> supportPlaces = [];

  /// Obtém a localização atual do usuário
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

  /// Busca os locais cadastrados no Firebase
  Future<void> fetchSupportPlacesFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('locais')
          .get();

      supportPlaces = snapshot.docs.map((doc) {
        final data = doc.data();

        return SupportPlace(
          id: doc.id,
          nome: data['nome'] ?? '',
          endereco: data['endereco'] ?? '',
          telefone: data['telefone'] ?? '',
          latitude: data['latitude'],
          longitude: data['longitude'],
          horarios: data['horarios'] ?? '',
          fotoUrl: data['fotoUrl'] ?? '',
          servicos: data['servicos'] ?? '',
          tipo: data['tipo'] ?? '',
        );
      }).toList();

      notifyListeners();
    } catch (e) {
      print('Erro ao buscar locais do Firebase: $e');
    }
  }

  /// Busca os detalhes de um local pelo ID no Firebase
  Future<SupportPlace?> getPlaceById(String placeId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('locais')
          .doc(placeId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        return SupportPlace(
          id: doc.id,
          nome: data['nome'] ?? '',
          endereco: data['endereco'] ?? '',
          telefone: data['telefone'] ?? '',
          latitude: data['latitude'],
          longitude: data['longitude'],
          horarios: data['horarios'] ?? '',
          fotoUrl: data['fotoUrl'] ?? '',
          servicos: data['servicos'] ?? '',
          tipo: data['tipo'] ?? '',
        );
      }
    } catch (e) {
      print('Erro ao buscar local por ID: $e');
    }

    return null;
  }
}
