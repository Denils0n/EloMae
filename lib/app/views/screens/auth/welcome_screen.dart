import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Seja bem-vinda!',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
              ),
              SvgPicture.asset('assets/images/img1.svg', width: 100, height: 350),
              const SizedBox(height: 20),
              Text(
                'Encontre apoio, informação e uma comunidade segura para caminhar junto com você.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  SizedBox(
                    width: 340,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => GoRouter.of(context).push('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8566E0),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Criar Conta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 340,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => GoRouter.of(context).push('/login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(side: BorderSide(color: const Color(0xFF8566E0), width: 2), borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(
                          color: Color(0xFF8566E0),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
