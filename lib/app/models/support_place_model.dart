class SupportPlace {
  final String id;
  final String nome;
  final double latitude;
  final double longitude;
  final String fotoUrl;
  final String telefone;
  final String endereco;
  final String horarios;
  final String servicos;
  final String tipo;

  SupportPlace({
    required this.id,
    required this.nome,
    required this.latitude,
    required this.longitude,
    required this.fotoUrl,
    required this.telefone,
    required this.endereco,
    required this.horarios,
    required this.servicos,
    required this.tipo,
  });

  factory SupportPlace.fromFirestore(String id, Map<String, dynamic> json) {
    return SupportPlace(
      id: id,
      nome: json['nome'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      fotoUrl: json['fotoUrl'],
      telefone: json['telefone'],
      endereco: json['endereco'],
      horarios: json['horarios'],
      servicos: json['servicos'],
      tipo: json['tipo'],
    );
  }
}
