import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: AprovarFormulario(),
  ));
}

class AprovarFormulario extends StatefulWidget {
  @override
  _AprovarFormularioState createState() => _AprovarFormularioState();
}

class _AprovarFormularioState extends State<AprovarFormulario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aprobar Formulario'),
      ),
      body: FirestoreData(collectionName: 'formulario'),
    );
  }
}

class FirestoreData extends StatelessWidget {
  final String collectionName;

  FirestoreData({required this.collectionName});

  Future<void> aprobarFormulario(String documentId) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .update({
      'estado': 'Aprobado',
    });
    print('Formulario aprobado: $documentId');
  }

  Future<void> rechazarFormulario(String documentId) async {
    await FirebaseFirestore.instance
        .collection(collectionName)
        .doc(documentId)
        .update({
      'estado': 'Reprobado',
    });
    print('Formulario rechazado: $documentId');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
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
            child: Text(
                'No hay datos disponibles en la colección "$collectionName"'),
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
            final nombreMascota =
                data['nombre_mascota'] ?? 'Nombre de mascota no disponible';
            final correo = data['correo'] ?? 'Correo no disponible';
            final estado = data['estado'] ?? 'En revision';

            return ListTile(
              title: Text('Nombres: $nombres'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apellidos: $apellidos'),
                  Text('Dirección: $direccion'),
                  Text('Teléfono: $telefono'),
                  Text('Rut: $rut'),
                  Text('Nombre de mascota: $nombreMascota'),
                  Text('Correo: $correo'),
                  Text('Estado: $estado'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () => aprobarFormulario(document.id),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => rechazarFormulario(document.id),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
