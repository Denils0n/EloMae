import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Criar Conta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              Text(
                'Crie sua conta e comece a receber apoio e informações importantes.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              const SizedBox(height: 20),
              Form(
                child: Column(
                  children: [
                    TextField(
                      
                    ),
                    SizedBox(
                      width: 340,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => GoRouter.of(context).push(
                          '/login',
                        ), //por enquanto que não tem autenticação, vou direcionar para a tela de login.
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
