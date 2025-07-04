class OnboardModel {
  final String image, title, description;

  OnboardModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardModel> demo_data = [
  OnboardModel(
    image: 'assets/images/onboarding/image1.svg',
    title: 'Conheça seus direitos',
    description:
        'Tenha acesso rápido a direitos garantidos por lei, benefícios sociais e orientações essenciais para mães solo.',
  ),
  OnboardModel(
    image: 'assets/images/onboarding/image2.svg',
    title: 'Rede de apoio real',
    description:
        'Conecte-se com outras mães, compartilhe vivências, tire dúvidas e encontre apoio em grupos temáticos e espaços seguros.',
  ),
  OnboardModel(
    image: 'assets/images/onboarding/image3.svg',
    title: 'Encontre apoio onde estiver',
    description:
        'Visualize no mapa instituições como CRAS, ONGs, Delegacias da Mulher e creches públicas próximas à sua localização.',
  ),
  OnboardModel(
    image: 'assets/images/onboarding/image4.svg',
    title: 'Sua rotina, com mais cuidado',
    description:
        'Agende compromissos importantes e receba lembretes sobre consultas, audiências, pagamentos e muito mais.',
  ),
  OnboardModel(
    image: 'assets/images/onboarding/image1.svg',
    title: 'Acolhimento, apoio e informação',
    description:
        'Com o EloMãe, você tem uma plataforma feita para entender, ouvir e ajudar. Seu caminho começa aqui.',
  ),
];