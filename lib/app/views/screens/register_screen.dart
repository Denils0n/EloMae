import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elomae/app/models/user_model.dart';
import 'package:elomae/app/utils/validators/user_validator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final credentials = UserModel();
  final validator = UserValidator();
  final formKey = GlobalKey<FormState>();

  bool isValid(){
    final result = validator.validate(credentials);
    return result.isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Crie sua conta e comece a receber apoio e informações importantes.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xff2F2F2F),
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        'Nome Completo',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: credentials.setName,
                    validator: validator.byField(credentials, 'name'),
                    // Na documentacao mostra esse jeito que serve como um "required"
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Insira seu nome completo';
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFECECEC),
                      hintText: 'Ex: Maria Luiza',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: credentials.setName,
                    validator: validator.byField(credentials, 'email'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFECECEC),
                      hintText: 'Ex: marialuiza@gmail.com',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        'Número',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: credentials.setName,
                    validator: validator.byField(credentials, 'number'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFECECEC),
                      hintText: '(DDD) 00000 - 0000',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text(
                        'Senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: credentials.setName,
                    validator: validator.byField(credentials, 'password'),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFECECEC),
                      hintText: 'Senha',
                      hintStyle: TextStyle(
                        color: Color(0xff838383),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListenableBuilder(
                    listenable: credentials,
                    builder: (context, child) {
                      return SizedBox(
                        width: 340,
                        height: 48,
                        child: Builder(
                          builder: (context) {
                            return ElevatedButton(
                              onPressed: () {
                                //GoRouter.of(context).push('/login'); //por enquanto que não tem autenticação, vou direcionar para a tela de login.
                                formKey.currentState?.validate();
                              },
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
                            );
                          }
                        ),
                      );
                    }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Já tem uma conta?', style: TextStyle(fontSize: 15)),
                      TextButton(
                        onPressed: () => GoRouter.of(context).push('/login'),
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF8566E0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
