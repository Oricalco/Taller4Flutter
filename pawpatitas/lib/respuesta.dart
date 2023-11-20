import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultadoFormulario extends StatefulWidget {
  @override
  _ResultadoFormularioState createState() => _ResultadoFormularioState();
}

class _ResultadoFormularioState extends State<ResultadoFormulario> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    User? user = _auth.currentUser;

    if (user == null) {
      UserCredential? userCredential = await _auth.signInAnonymously();
      user = userCredential.user;
    }

    setState(() {
      _user = user!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utiliza _user para obtener el usuario actual
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultados de Formulario'),
      ),
      body: FutureBuilder(
        future: _auth.authStateChanges().first,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('Error al obtener el usuario'),
            );
          }

          final User user = snapshot.data!;
          _user = user; // Almacena el usuario en _user

          return FirestoreData(collectionName: 'formulario', userEmail: user.email!);
        },
      ),
    );
  }
}

class FirestoreData extends StatelessWidget {
  final String collectionName;
  final String userEmail;

  FirestoreData({required this.collectionName, required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(collectionName)
          .where('correo', isEqualTo: userEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final docs = snapshot.data?.docs;

        if (docs == null || docs.isEmpty) {
          return Center(
            child: Text('No hay datos disponibles en la colección "$collectionName" para el usuario actual'),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: docs.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;

            final nombres = data['nombres'] ?? 'Nombres no disponibles';
            final apellidos = data['apellidos'] ?? 'Apellidos no disponibles';
            final direccion = data['direccion'] ?? 'Dirección no disponible';
            final telefono = data['telefono'] ?? 'Teléfono no disponible';
            final rut = data['rut'] ?? 'Rut no disponible';
            final nombreMascota = data['nombre_mascota'] ?? 'Nombre de mascota no disponible';
            final correo = data['correo'] ?? 'Correo no disponible';
            final estado = data['estado'] ?? 'En Revision';

            // Define el color de fondo según el estado
            Color backgroundColor = Colors.transparent;
            if (estado == 'Aprobado') {
              backgroundColor = Colors.lightGreen[100] ?? Colors.transparent;
            } else if (estado == 'Reprobado') {
              backgroundColor = Colors.red[100] ?? Colors.transparent;
            }

            return Container(
              color: backgroundColor,
              child: ListTile(
                title: Text('Nombre: $nombres'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Apellido: $apellidos'),
                    Text('Dirección: $direccion'),
                    Text('Teléfono: $telefono'),
                    Text('Rut: $rut'),
                    Text('Nombre de mascota: $nombreMascota'),
                    Text('Correo: $correo'),
                    Text('Estado: $estado'),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}