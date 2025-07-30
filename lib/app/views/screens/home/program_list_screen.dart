import 'package:flutter/material.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  State<ProgramListScreen> createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  final List<GlobalKey> _cardKeys = List.generate(8, (index) => GlobalKey()); //  Cria 8 chaves únicas (uma pra cada card)
  late final ScrollController _scrollController; // Um Scroll controlador que permite rolar a tela programaticamente.

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
       controller: _scrollController,
      children: [
       _buildExpansionTile(
        context,
          title: 'Programas de Transferência de Renda',
          items: ['Bolsa Família', 'Benefício de Prestação Continuada (BPC)', 'Auxílio Gás'],
           key: _cardKeys[0],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas de Apoio à Primeira Infância',
          items: ['Programa Criança Feliz', 'Rede Cegonha'],
            key: _cardKeys[1],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas Habitacionais e de Infraestrutura',
          items: ['Minha Casa, Minha Vida', 'Tarifa Social de Energia Elétrica'],
            key: _cardKeys[2],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas de Inclusão Produtiva e Empreendedorismo',
          items: ['Auxílio Inclusão Produtiva Rural', 'Programas de Microcrédito'],  
            key: _cardKeys[3],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas Educacionais e Profissionalizantes',
          items: ['ProUni e FIES', 'Cursos Profissionalizantes Gratuitos'],
            key: _cardKeys[4],
        ),
        _buildExpansionTile(
          context,
          title: 'Serviços de Saúde e Assistência Social',
          items: ['Unidades Básicas de Saúde (UBS)', 'Centro de Referência de Assistência Social (CRAS)'],
            key: _cardKeys[5],
        ),
        _buildExpansionTile(
          context,
          title: 'Medidas Protetivas e Direitos Legais',
          items: ['Lei Maria da Penha', 'Delegacia Especializada de Atendimento à Mulher (DEAMs)'],
            key: _cardKeys[6],
        ),
        _buildExpansionTile(
          context,
          title: 'Outros Benefícios e Programas',
          items: ['Isenção de IPTU', 'Programa Mães do Brasil'],
            key: _cardKeys[7],
        ),
      ],
    );
  }

  Widget _buildExpansionTile(BuildContext context, {required String title, required List<String> items,
  required GlobalKey key}) {
  return Card(
    key: key,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsetsDirectional.only(bottom: 30),
    child: Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: StatefulBuilder( // Permite usar setState localmente apenas neste widget, sem precisar de um StatefulWidget completo.
        builder: (context, setState) {
          return ExpansionTile(
            iconColor: const Color(0xFF8566E0),
            collapsedIconColor: const Color.fromARGB(255, 77, 77, 77),
            title: Text(
              title, // O title passado pelo paramento da function, (o card clicado)
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey[900],),
            ),
            onExpansionChanged: (expanded) async { // É um callback (função que será chamada automaticamente) toda vez que o ExpansionTile muda de estado 
              if (expanded) {
                await Future.delayed(const Duration(milliseconds: 200)); // Espera 200ms para deixar a animação do ExpansionTile terminar
                final keyContext = key.currentContext; // Pega o BuildContext associado à GlobalKey.
                if (keyContext != null) {
                  Scrollable.ensureVisible( // Essa função rola automaticamente a tela até o widget identificado por esse BuildContext.
                    keyContext, 
                    duration: const Duration(milliseconds: 200),
                    alignment: 0.1, // 0.0 = topo, 1.0 = fundo, indica que o widget deve aparecer um pouco abaixo do topo da tela.
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            children: items.map((item) { // Para cada string em items, cria um ListTile.
              return ListTile(
                title: Text(item),
                onTap: () {
                  print('Selecionado: $item');
                },
              );
            }).toList(),
          );
        },
      ),
    ),
  );
}
}