import 'package:flutter/material.dart';
import 'auth.dart'; // Importa tu clase Auth aquí
import 'home.dart';
import 'admin_screen.dart'; // Importa la pantalla de administrador

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController adminCodeController = TextEditingController();
  bool isLogin = true;
  bool isAdmin = false;

  void toggleLoginRegistration() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void toggleAdmin() {
    setState(() {
      isAdmin = !isAdmin;
    });
  }

  void showSnackBar(BuildContext? context, String message) {
    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  Future<void> verifyAdminCode(BuildContext context) async {
    String enteredCode = adminCodeController.text.trim();

    if (enteredCode == 'pawpatitas123') {
      // Código de administrador correcto, permitir el registro
      await register(context);
    } else {
      // Código de administrador incorrecto, mostrar un mensaje de error
      showSnackBar(context, 'Código de administrador incorrecto. Verifica el código e intenta nuevamente.');
    }
  }

  Future<void> register(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      Auth auth = Auth();
      bool registered = await auth.registerWithEmailAndPassword(email, password, isAdmin ? 'admin' : 'usuario');

      if (registered) {
        showSnackBar(context, 'Registro exitoso. Ahora puedes iniciar sesión.');
        toggleLoginRegistration();
      } else {
        showSnackBar(context, 'Error durante el registro. Inténtalo de nuevo.');
      }
    } else {
      showSnackBar(context, 'Por favor, completa todos los campos.');
    }
  }

  void login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (isLogin) {
      if (email.isNotEmpty && password.isNotEmpty) {
        Auth auth = Auth();
        bool loggedIn = await auth.signInWithEmailAndPassword(email, password);

        if (loggedIn) {
          String? role = auth.getRole();
          if (role == 'admin') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const AdminScreen(),
              ),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          }
        } else {
          showSnackBar(context, 'Inicio de sesión fallido. Verifica tus credenciales.');
        }
      } else {
        showSnackBar(context, 'Por favor, completa todos los campos.');
      }
    } else {
      if (isAdmin) {
        // Si el usuario elige registrarse como administrador, solicitar el código de administrador
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: const Text('Verificar Código de Administrador'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Ingresa el código de administrador proporcionado por el cliente:'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: adminCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Código de Administrador',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await verifyAdminCode(context);
                      },
                      child: const Text('Verificar'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Si el usuario no elige registrarse como administrador, proceder con el registro
        await register(context);
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
                        if (!isLogin) // Mostrar el interruptor solo durante el registro
                          const SizedBox(height: 10),
                        if (!isLogin)
                          SwitchListTile(
                            title: Text('Registrarse como Admin'),
                            value: isAdmin,
                            onChanged: (value) {
                              setState(() {
                                isAdmin = value;
                              });
                            },
                          ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => login(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          child: Text(isLogin ? 'Iniciar Sesión' : 'Registrar'),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: toggleLoginRegistration,
                          child: Text(
                            isLogin ? '¿No tienes una cuenta? Regístrate' : '¿Ya tienes una cuenta? Inicia Sesión',
                            style: const TextStyle(
                              color: Colors.red,
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
