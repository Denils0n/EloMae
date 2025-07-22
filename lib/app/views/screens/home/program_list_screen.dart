import 'package:flutter/material.dart';

class ProgramListScreen extends StatelessWidget {
  const ProgramListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
       _buildExpansionTile(
        context,
          title: 'Programas de Transferência de Renda',
          items: ['Bolsa Família', 'Benefício de Prestação Continuada (BPC)', 'Auxílio Gás'],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas de Apoio à Primeira Infância',
          items: ['Programa Criança Feliz', 'Rede Cegonha'],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas Habitacionais e de Infraestrutura',
          items: ['Minha Casa, Minha Vida', 'Tarifa Social de Energia Elétrica'],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas de Inclusão Produtiva e Empreendedorismo',
          items: ['Auxílio Inclusão Produtiva Rural', 'Programas de Microcrédito'],
        ),
        _buildExpansionTile(
          context,
          title: 'Programas Educacionais e Profissionalizantes',
          items: ['ProUni e FIES', 'Cursos Profissionalizantes Gratuitos'],
        ),
        _buildExpansionTile(
          context,
          title: 'Serviços de Saúde e Assistência Social',
          items: ['Unidades Básicas de Saúde (UBS)', 'Centro de Referência de Assistência Social (CRAS)'],
        ),
        _buildExpansionTile(
          context,
          title: 'Medidas Protetivas e Direitos Legais',
          items: ['Lei Maria da Penha', 'Delegacia Especializada de Atendimento à Mulher (DEAMs)'],
        ),
        _buildExpansionTile(
          context,
          title: 'Outros Benefícios e Programas',
          items: ['Isenção de IPTU', 'Programa Mães do Brasil'],
        ),
      ],
    );
  }

  Widget _buildExpansionTile(BuildContext context, {required String title, required List<String> items}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsetsDirectional.only(bottom: 25),
      child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
           iconColor: Color(0xFF8566E0),
          collapsedIconColor: Color.fromARGB(255, 68, 68, 68),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
          children: items.map((item) {
            return ListTile(
              title: Text(item),
              onTap: () {
                print('Selecionado: $item'); // Aqui vai ser a navegaçÃo para outras pages
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}