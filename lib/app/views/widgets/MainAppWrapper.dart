import 'package:flutter/material.dart';
import 'package:elomae/app/views/widgets/VLibrasOverlay.dart';

class MainAppWrapper extends StatelessWidget {
  final Widget child; 

  const MainAppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,               
        const VLibrasOverlay(), // O botão VLibras que fica por cima da pagina
      ],
    );
  }
}
