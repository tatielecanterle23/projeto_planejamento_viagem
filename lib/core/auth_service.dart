import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _authInstance = FirebaseAuth.instance;

  Future<UserCredential?> login(String email, String senha) async {
    try {
      UserCredential usuario = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      return usuario;
    } on FirebaseAuthException catch (ex) {
      print(ex);
    }
  }

  Future<UserCredential> novaConta(String email, String senha) {
    return _authInstance.createUserWithEmailAndPassword(
        email: email, password: senha);
  }
}
