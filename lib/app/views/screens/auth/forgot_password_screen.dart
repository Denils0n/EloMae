import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elomae/app/models/user_model.dart';
import 'package:elomae/app/utils/validators/user_validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreen();

}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
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
                    'Insira seu número',
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
                  const SizedBox(height: 20),
                  ListenableBuilder(
                    listenable: credentials,
                    builder: (context, child) {
                      return SizedBox(
                        width: 340,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            formKey.currentState?.validate();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8566E0),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Continuar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 340,
                    height: 48,
                    child: TextButton(
                      onPressed: () => GoRouter.of(context).push('/login'),
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                      ),
                      child: const Text(
                        'Voltar',
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
            ),
          ),
        ),
      ),
    );
  }
}
