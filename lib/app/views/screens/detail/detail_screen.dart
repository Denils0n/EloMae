import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailProgramScreen extends StatefulWidget {

  final String itemName;

  const DetailProgramScreen({super.key, required this.itemName});

  @override
  State<DetailProgramScreen> createState() => _DetailProgramScreenState();
}

class _DetailProgramScreenState extends State<DetailProgramScreen> {
   final PageController _pageController = PageController();

// late: Indica que a variável será inicializada depois, mas antes de ser usada.
//Future<...>: tipo que representa um valor assíncrono, como dados vindos do Firestore.
//DocumentSnapshot<Map<String, dynamic>>: representa um documento único do Firestore contendo dados como mapa (Map<String, dynamic>).
   late Future<DocumentSnapshot<Map<String, dynamic>>> _programData;

   String _formatarId(String texto) {
  return texto
    .toLowerCase()
    .replaceAll(' ', '_')  // Substitui espaços por _
    .replaceAll(RegExp(r'[áàâãä]'), 'a')
    .replaceAll(RegExp(r'[éèêë]'), 'e')
    .replaceAll(RegExp(r'[íìîï]'), 'i')
    .replaceAll(RegExp(r'[óòôõö]'), 'o')
    .replaceAll(RegExp(r'[úùûü]'), 'u')
    .replaceAll('ç', 'c')
    .replaceAll(RegExp(r'[^\w]'), '');  // Remove outros caracteres especiais
}

@override
  void initState () { // Busca no Firestore o documento com o nome do programa clicado. toLowerCase().replaceAll(' ', '_'): transforma "Bolsa Família" em "bolsa_familia" para bater com o nome do documento no Firestore. 
    super.initState(); // .get() retorna um Future com os dados do documento.
  _programData = FirebaseFirestore.instance
  .collection('programas_beneficios')
  .doc(_formatarId(widget.itemName))
  .get();
}

void _launchURL(String url) async {
  final uri = Uri.parse(url); // Transforma a string em uma URI válida
  if (await canLaunchUrl(uri)) {  // Verifica se a URL pode ser aberta
    await launchUrl(uri, mode: LaunchMode.externalApplication); // Abre a URL no navegador externo (fora do app)
  } else {
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Não foi possível abrir o link: $url')),
      );
  }
}

Widget _buildTextWithLink(String text) {
  final urlRegex = RegExp(r'(https?:\/\/[^\s]+)');  // Expressão que procura por links
  final match = urlRegex.firstMatch(text); // Procura o primeiro link no texto

  if (match != null) {
    final url = match.group(0)!;  // O link completo
    final preText = text.substring(0, match.start);  // Texto antes do link
    final postText = text.substring(match.end);      // Texto depois do link

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black),
        children: [
          TextSpan(text: "• $preText"), // Mostra o texto antes do link
          TextSpan(
            text: url,  // O próprio link
            style: const TextStyle(
              color: Colors.blue, 
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
            // Quando clica no link, chama a função que abre o navegador
          ),
          TextSpan(text: postText), // Mostra o texto depois do link
        ],
      ),
    );
  } else {
    // Se não tiver link, mostra normalmente
    return Text("• $text", style: const TextStyle(fontSize: 18));
  }
}

int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(  // FutureBuilder espera pelo resultado assíncrono de _programData
        future: _programData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) { 
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!.data();  // Crio uma variavel data que armazena os dados do snapshot.data que tem id, tem tudo da coleção, mas queremos converter para chave e valor, e utilizamos .data()
          if (data == null) {
            return const Center(child: Text("Dados não encontrados"));
          }

          final etapas = [
            data['etapa_1'],
            data['etapa_2'],
            data['etapa_3'],
          ];

          return Column(
            children: [
            SizedBox(height: 10.0),
            Center(
               child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // cor da sombra
                    spreadRadius: 3,  // expansão da sombra
                    blurRadius: 6,   // desfoque
                    offset: Offset(0, 4), // deslocamento (horizontal, vertical)
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(data['img_url']),
                radius: 80,
                ),
            ),
            ),
              SizedBox(height: 40.0),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: etapas.length,
                onPageChanged: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final etapa =  Map<String, dynamic>.from(etapas[index]);
                  return ListView(
                    padding:const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                      children: [
                        if (index == 0) ...[
                          Text(etapa['sobre'], 
                          style: TextStyle(fontSize: 18),),
                          SizedBox(height: 30.0),
                          Text('Quem criou?', 
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          SizedBox(height: 5.0),
                          Text(etapa['quem_criou'],
                          style: TextStyle(fontSize: 18),),
                          SizedBox(height: 30.0),
                          Text('Objetivos principais',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5.0,),
                          ...(etapa['objtivos_principais'] as List)
                        .map<Widget>((item) =>Padding(
                          padding: const EdgeInsets.only(bottom: 10.0), 
                          child: Text("• $item", style: const TextStyle(fontSize: 18)),
                        ))
                      
                        ]
                        else if (index == 1) ...[
                          Text('Quem NÃO pode receber',
                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                           SizedBox(height: 5.0),
                           ...(etapa['nao_requesitos'] as List)
                           .map<Widget>((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10.0), 
                            child: Text("• $item", style: const TextStyle(fontSize: 18)), 
                            )),
                            SizedBox(height: 30.0),

                            Text('Requesitos minimos para poder receber', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10.0),

                            ...(etapa['requesitos'] as List).map<Widget>((requesito) {
                                final req = requesito as Map<String, dynamic>;

                                final itens = req.entries
                                .where((entry) => entry.key.startsWith('iten_'))
                                .map((entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: Text("• ${entry.value}", style: const TextStyle(fontSize: 18)),
                                    ));
                          
                                return Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          req['titulo'] ?? '',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0),
                                        ...itens,
                                      ],
                                    ),
                                  );
                            }), 
                        ]
                        else if (index == 2) ...[
                              Text('Como se escrever', 
                               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10.0),

                              ...(etapa['inscrever'] as List).map<Widget>((inscrever) {
                                final insc = inscrever as Map<String, dynamic>;

                                final itens = insc.entries
                                .where((entry) => entry.key.startsWith('iten_'))
                                .map((entry) => Padding(
                                      padding: const EdgeInsets.only(bottom: 10.0),
                                      child: _buildTextWithLink(entry.value),
                                    ));
                          
                                return Padding(
                                    padding: const EdgeInsets.only(bottom: 20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          insc['titulo'] ?? '',
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0),
                                        ...itens,
                                      ],
                                    ),
                                  );
                            }), 
                        ]
                      ],
                    );
                },
                ),
                ),
                            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: _selectedIndex > 0
                      ? () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null, // desativa se já está na primeira página
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                ),
                TextButton.icon(
                  onPressed: _selectedIndex < etapas.length - 1
                      ? () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      : null, // desativa se já está na última página
                  icon: const Text('Próximo'),
                  label: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            ],
          );
        },
      ),
    );
  }
}