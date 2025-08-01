import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Verifica suporte a biometria (hardware + cadastramento)
  Future<bool> canAuthenticateBiometrics() async {
    try {
      // 1. O dispositivo tem suporte a biometria?
      final isSupported = await _auth.isDeviceSupported();

      // 2. O usuário tem alguma digital/padrão cadastrado?
      final canCheck   = await _auth.canCheckBiometrics;

      return isSupported && canCheck;
    } catch (e) {
      print('Erro ao checar biometria: $e');
      return false;
    }
  }

  /// Dispara o prompt de biometria
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print('Erro na autenticação biométrica: $e');
      return false;
    }
  }

  /// Salva email e senha
  Future<void> saveCredentials(String email, String password) async {
    await _storage.write(key: 'bio_email', value: email);
    await _storage.write(key: 'bio_pwd',   value: password);
  }

  /// Lê credenciais, retorna null se não existir
  Future<Map<String, String>?> readCredentials() async {
    final email = await _storage.read(key: 'bio_email');
    final pwd   = await _storage.read(key: 'bio_pwd');
    if (email != null && pwd != null) {
      return {'email': email, 'password': pwd};
    }
    return null;
  }

  /// Limpa credenciais
  Future<void> clearCredentials() async {
    await _storage.delete(key: 'bio_email');
    await _storage.delete(key: 'bio_pwd');
  }
}
