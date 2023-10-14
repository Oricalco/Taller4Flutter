import 'package:flutter/material.dart';
import 'auth.dart'; // Importa tu clase Auth aquí
import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLogin = true; // Variable para controlar si estamos en la pantalla de inicio de sesión o registro

  void toggleLoginRegistration() {
    setState(() {
      isLogin = !isLogin; // Cambia el valor de isLogin al opuesto
    });
  }

  void login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isLogin) {
      // Realiza el inicio de sesión si estamos en la pantalla de inicio de sesión
      if (email.isNotEmpty && password.isNotEmpty) {
        Auth auth = Auth();
        bool loggedIn = await auth.signInWithEmailAndPassword(email, password);

        if (loggedIn) {
          // Redirige al usuario a la pantalla de inicio (HomeScreen) si el inicio de sesión fue exitoso
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        } else {
          // Maneja aquí el caso de inicio de sesión fallido
          // Por ejemplo, muestra un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inicio de sesión fallido. Verifica tus credenciales.'),
            ),
          );
        }
      } else {
        // Maneja aquí el caso de campos vacíos
        // Por ejemplo, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, completa todos los campos.'),
          ),
        );
      }
    } else {
      // Realiza el registro si estamos en la pantalla de registro
      if (email.isNotEmpty && password.isNotEmpty) {
        Auth auth = Auth();
        bool registered = await auth.registerWithEmailAndPassword(email, password);

        if (registered) {
          // Redirige al usuario a la pantalla de inicio de sesión después del registro exitoso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registro exitoso. Ahora puedes iniciar sesión.'),
            ),
          );
          toggleLoginRegistration(); // Cambia de nuevo a la pantalla de inicio de sesión
        } else {
          // Maneja aquí el caso de registro fallido
          // Por ejemplo, muestra un mensaje de error
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error durante el registro. Inténtalo de nuevo.'),
            ),
          );
        }
      } else {
        // Maneja aquí el caso de campos vacíos
        // Por ejemplo, muestra un mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, completa todos los campos.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Iniciar Sesión' : 'Registro'),
      ),
      body: Stack(
        children: [
          FractionalTranslation(
            translation: const Offset(0.0, -0.65),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/testeo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/aaaa.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 8,
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          isLogin ? 'Iniciar Sesión' : 'Registro',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo Electrónico',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => login(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red,
                          ),
                          child: Text(isLogin ? 'Iniciar Sesión' : 'Registrar'),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: toggleLoginRegistration,
                          child: Text(
                            isLogin ? '¿No tienes una cuenta? Regístrate' : '¿Ya tienes una cuenta? Inicia Sesión',
                            style: const TextStyle(
                              color: Colors.red, // Cambia el color del texto del botón switch
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
