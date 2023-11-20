import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'galeria.dart';
import 'aprob_form.dart';
import 'soporte_admin.dart';
import 'donar.dart';
import 'metrica.dart';
import 'login.dart';
import 'animal_upload.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;
  final screens = [
    GaleriaPage(),
    SoportePageAdmin(),
    DonarPage(),
    PaginaMetricas(),
    TestPage(),
    AprovarFormulario(),
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
                Padding(
                  padding: const EdgeInsets.only(
                      right: 16.0), // Ajusta este valor según tus necesidades
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _logout(
                        context), // Llama a la función de cierre de sesión
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          return GNav(
            activeColor: Colors.white,
            color: Colors.grey,
            backgroundColor: const Color.fromARGB(255, 34, 34, 34),
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 600 ? 40 : 10,
              vertical: 18,
            ),
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
                icon: Icons.bar_chart,
                text: 'metrica',
              ),
              GButton(
                icon: Icons.pets,
                text: 'Subir mascota',
              ),
              GButton(
                icon: Icons.check,
                text: 'Aprobar formularios',
              ),
            ],
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminScreen(),
  ));
}
