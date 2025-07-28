import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elomae/app/models/support_place_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:elomae/app/views/widgets/navigationbar.dart';


class PlaceDetailsScreen extends StatefulWidget {
  final SupportPlace place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetailsScreen> {
  bool showFullText = false;
  final int charLimit = 120; // limite de caracteres

  @override
  Widget build(BuildContext context) {

    final place = widget.place;
    final servicos = place.servicos ?? 'Não informado';

    final isLongText = servicos.length > charLimit;
    final displayText = showFullText || !isLongText
        ? servicos
        : '${servicos.substring(0, charLimit)}...';

    return Scaffold(
      appBar: AppBar(title: Text(place.nome)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            if (place.fotoUrl != null)
              ClipRRect(
                // borderRadius: BorderRadius.circular(8),
                child: Image.network(place.fotoUrl!),
              ),
            const SizedBox(height: 24),

            // Nome acima da imagem
            Text(
              place.nome,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            //Telefone
             Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Telefone: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: place.telefone ?? 'Não informado'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Informações
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Endereço: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: place.endereco ?? 'Não informado'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Horários: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: place.horarios ?? 'Não informado'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Serviços: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: displayText),
                ],
              ),
            ),
          if (isLongText)
              TextButton(
                onPressed: () {
                  setState(() {
                    showFullText = !showFullText;
                  });
                },
                child: Text(showFullText ? 'Ler menos' : 'Ler mais'),
              ),
          ],
        ),
      ),
       bottomNavigationBar: const Navigationbar(currentIndex: 0),
    );
  }

  Widget infoText(String label, String? value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value ?? 'Não informado'),
        ],
      ),
    );
  }
}