import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> registerWithEmailAndPassword(String email, String password, String role) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).then((authResult) {
        // Agrega el rol a la base de datos al registrar
        authResult.user?.updateProfile(displayName: role);
      });

      // Registro exitoso
      return true;
    } catch (e) {
      print('Error durante el registro: $e');
      return false; // Registro fallido
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Inicio de sesión exitoso
      return true;
    } catch (e) {
      print('Error durante el inicio de sesión: $e');
      return false; // Inicio de sesión fallido
    }
  }

  // Obtén el rol del usuario actual
  String? getRole() {
    return _auth.currentUser?.displayName;
  }
}
