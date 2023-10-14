import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> registerWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
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
}
