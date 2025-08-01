import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:elomae/app/models/user_model.dart';
import 'package:elomae/app/utils/validators/user_validator.dart';
import 'package:elomae/services/auth_service.dart';
import 'package:elomae/services/biometric_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _credentials = UserModel();
  final _validator = UserValidator();
  final _bioService = BiometricService();

  bool _biometricAvailable = false;
  bool _hasSavedCredentials = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    _loadSavedCredentials();
  }

  Future<void> _checkBiometricAvailability() async {
    final canBio = await _bioService.canAuthenticateBiometrics();
    setState(() => _biometricAvailable = canBio);
  }

  Future<void> _loadSavedCredentials() async {
    final saved = await _bioService.readCredentials();
    setState(() => _hasSavedCredentials = saved != null);
  }

  Future<void> _onNormalLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await AuthService().loginUser(
      email: _credentials.email,
      password: _credentials.password,
    );

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    // salva sempre para o login biométrico
    await _bioService.saveCredentials(
      _credentials.email,
      _credentials.password,
    );

    GoRouter.of(context).go('/home');
  }

  Future<void> _onBiometricLogin() async {
    print('Entrar com digital pressionado');
    final ok = await _bioService.authenticate();
    print('authenticate result: $ok');
    if (!ok) return;

    final creds = await _bioService.readCredentials();
    if (creds == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhuma credencial salva')),
      );
      return;
    }

    final error = await AuthService().loginUser(
      email: creds['email']!,
      password: creds['password']!,
    );

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    GoRouter.of(context).go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Entrar',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),



                const SizedBox(height: 16),
                Text(
                  'Use sua conta para continuar recebendo apoio, informações e participar da comunidade.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 40),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: _credentials.setEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validator.byField(_credentials, 'email'),
                  decoration: InputDecoration(
                    hintText: 'exemplo@dominio.com',
                    filled: true,
                    fillColor: const Color(0xFFF2F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Senha',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  onChanged: _credentials.setPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: _validator.byField(_credentials, 'password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Sua senha',
                    filled: true,
                    fillColor: const Color(0xFFF2F2F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () =>
                        GoRouter.of(context).push('/forgot_password'),
                    child: const Text('Esqueci minha senha'),
                  ),
                ),

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _onNormalLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8566E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),

                if (_hasSavedCredentials && _biometricAvailable) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint, size: 20),
                    label: const Text('Entrar com digital'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: _onBiometricLogin,
                  ),
                ],

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não tem conta?'),
                    TextButton(
                      onPressed: () => GoRouter.of(context).push('/register'),
                      child: const Text('Criar Conta'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
