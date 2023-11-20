import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: TestPage(),
  ));
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Firestore'),
      ),
      body: FirestoreData(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddAnimalForm(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FirestoreData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('animales').snapshots(),
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
            child: Text('No hay datos disponibles en la colección "animales"'),
          );
        }

        final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

        return ListView(
          shrinkWrap: true,
          children: docs.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            final nombre = data['nombre'] ?? 'Nombre no disponible';
            final edad = data['edad'] ?? 'Edad no disponible';
            final sexo = data['sexo'] ?? 'Sexo no disponible';
            final raza = data['raza'] ?? 'Raza no disponible';
            final descripcion =
                data['descripcion'] ?? 'Descripción no disponible';

            final fechaTimestamp = data['fecha_ingreso'] as Timestamp;
            final fechaIngreso = dateFormatter.format(fechaTimestamp.toDate());

            return ListTile(
              title: Text('Nombre: $nombre'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edad: $edad'),
                  Text('Sexo: $sexo'),
                  Text('Raza: $raza'),
                  Text('Descripción: $descripcion'),
                  Text('Fecha de Ingreso: $fechaIngreso'),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class AddAnimalForm extends StatefulWidget {
  @override
  _AddAnimalFormState createState() => _AddAnimalFormState();
}

class _AddAnimalFormState extends State<AddAnimalForm> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController sexoController = TextEditingController();
  final TextEditingController razaController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  void _submitForm(BuildContext context) {
    FirebaseFirestore.instance.collection('animales').add({
      'nombre': nombreController.text,
      'edad': edadController.text,
      'sexo': sexoController.text,
      'raza': razaController.text,
      'descripcion': descripcionController.text,
      'fecha_ingreso': Timestamp.now(),
    });

    Navigator.of(context).pop();
    _showConfirmationSnackBar(context);
  }

  void _showConfirmationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registro guardado exitosamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: edadController,
              decoration: InputDecoration(labelText: 'Edad'),
            ),
            TextFormField(
              controller: sexoController,
              decoration: InputDecoration(labelText: 'Sexo'),
            ),
            TextFormField(
              controller: razaController,
              decoration: InputDecoration(labelText: 'Raza'),
            ),
            TextFormField(
              controller: descripcionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
