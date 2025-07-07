import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucid_validation/lucid_validation.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserRegister({
    required String name,
    required String number,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await userCredential.user!.updateDisplayName(name);
  }

  // Login de usuário
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      return _handleFirebaseError(e);
    }
  }

  // Retorna o usuário atual
  User? get currentUser => _firebaseAuth.currentUser;

  // Verifica se está logado
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  // Desloga o usuário
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Mapeia erros do Firebase para mensagens amigáveis
  String _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'Esse email já está em uso.';
      case 'invalid-email':
        return 'Email inválido.';
      case 'weak-password':
        return 'A senha é muito fraca.';
      default:
        return 'Erro: ${e.message}';
    }
  }
}
