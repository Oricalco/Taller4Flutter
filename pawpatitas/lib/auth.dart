import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> registerWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((authResult) {
        authResult.user?.updateProfile(displayName: role);
      });

      return true;
    } catch (e) {
      print('Error durante el registro: $e');
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return true;
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
      return false;
    }
  }

  String? getRole() {
    return _auth.currentUser?.displayName;
  }
}
