import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'galeria.dart';
import 'soporte.dart';
import 'donar.dart';
import 'login.dart';
import 'respuesta.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final screens = [
    GaleriaPage(),
    SoportePage(),
    DonarPage(),          
    ResultadoFormulario(),    

  
  ];

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Cierra la sesión
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 60),
        child: SafeArea(
          child: Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 99, 99, 99),
                  blurRadius: 5.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/banner3.png', fit: BoxFit.fill),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _logout(context), // Llama a la función de cierre de sesión
                ),
              ],
            ),
          ),
        ),
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: GNav(
        activeColor: Colors.white,
        color: Colors.grey,
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        selectedIndex: _currentIndex,
        onTabChange: (index) => {
          setState(() => _currentIndex = index),
        },
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'home',
          ),
          GButton(
            icon: Icons.catching_pokemon,
            text: 'soporte',
          ),
          GButton(
            icon: Icons.monetization_on,
            text: 'Donaciones',
          ),
          GButton(
            icon: Icons.check,
            text: 'Resultados',
          ),
                
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}
