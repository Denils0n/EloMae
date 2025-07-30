import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elomae/app/models/support_place_model.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  Future<List<Map<String, dynamic>>> carregarTelefones() async {
    final docDelegacia = await FirebaseFirestore.instance
        .collection('locais')
        .doc('delegacia_igarassu')
        .get();

    final docConselhoTutelar = await FirebaseFirestore.instance
        .collection('locais')
        .doc('conselho_igarassu')
        .get();

  String telefoneDelegacia = 'Não disponível';
  String telefoneConselho = 'Não disponível';

  if (docDelegacia.exists && docDelegacia.data() != null) {
    final delegacia = SupportPlace.fromFirestore(docDelegacia.id, docDelegacia.data()!);
    telefoneDelegacia = delegacia.telefone;
  }

  if (docConselhoTutelar.exists && docConselhoTutelar.data() != null) {
    final conselho = SupportPlace.fromFirestore(docConselhoTutelar.id, docConselhoTutelar.data()!);
    telefoneConselho = conselho.telefone;
  }

   return [
    {'icon': Icons.pregnant_woman, 'title': 'Central de Atendimento à Mulher', 'Numero': '180'},
    {'icon': Icons.local_police, 'title': 'Policia Militar', 'Numero': '190'},
    {'icon': Icons.local_hospital, 'title': 'Samu-Ambulância', 'Numero': '192'},
    {'icon': Icons.shield, 'title': 'Delegacia da mulher', 'Numero': telefoneDelegacia},
    {'icon': Icons.family_restroom, 'title': 'Conselho tutelar', 'Numero': telefoneConselho},
    {'icon': Icons.record_voice_over, 'title': 'Disque direitos humanos', 'Numero': '100'},
  ];
}

  void _makePhoneCall(String phoneNumber, BuildContext context) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber); // Cria uma URI (link) do tipo tel: com o número de telefone.
    if (await canLaunchUrl(launchUri)) { // Verifica se o sistema consegue lidar com essa URI (ou seja, se existe um app de telefone que possa fazer a chamada).
      await launchUrl(launchUri, mode: LaunchMode.externalApplication); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível fazer a ligação')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.0,
        leading: IconButton(
            onPressed: () {
                  context.go('/profile');
            }, icon: Icon(Icons.arrow_back_ios_rounded, size: 25),
          ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>( //Espere carregarTelefones() terminar, que retorna uma List<Map<String, dynamic>>, e quando terminar, exiba o resultado na tela."
        future: carregarTelefones(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

         if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar dados.'));
        }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma informação disponível.'));
          }

          final items = snapshot.data!;  
      
      return Padding(padding: EdgeInsets.only(top: 5.0),
      child: Column(
        children: [
          Center(
            child: Text('Segurança e Apoio para Mães Solo',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
            ),),
          ),
          SizedBox(height: 25.0),

     Expanded(
       child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          return Card(
            margin: EdgeInsetsDirectional.symmetric(horizontal: 40, vertical: 20),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(item['icon'], color: Color(0xFF8566E0)),
                    SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'],),
                        SizedBox(height: 3),
                         Text('Número: ${item['Numero']}'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                   onPressed: () {
                      final numero = item['Numero'].toString();
                        _makePhoneCall(numero, context);
                    },
                   child: Text('Ligar')),    
                ],
              ),
            ),
          );
        } ,
        ),
     ),
        ],
      ),
      );
    },
      ),
    );
  }
}




