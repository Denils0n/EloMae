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
}
