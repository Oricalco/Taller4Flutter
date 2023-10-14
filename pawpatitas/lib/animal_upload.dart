import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos de Firestore'),
      ),
      body: FirestoreData(),
    );
  }
}

class FirestoreData extends StatefulWidget {
  @override
  _FirestoreDataState createState() => _FirestoreDataState();
}

class _FirestoreDataState extends State<FirestoreData> {
  final TextEditingController nameController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  void saveNameToFirestore() async {
    final name = nameController.text;
    if (name.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('people').add({'name': name});
        nameController.clear(); // esto es para poder limpiar el formulario luego de escribir el nombre
        _showSnackBar('Guardado exitosamente');
      } catch (e) {
        print('Error al guardar en Firestore: $e');
      }
    }
  }

 void _showSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message))
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // en esta parte esta el formulario
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
            ),
            ElevatedButton(
              onPressed: saveNameToFirestore,
              child: Text('Guardar Nombre en Firestore'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('people').snapshots(),
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
                    child: Text('No hay datos disponibles'),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  children: docs.map((DocumentSnapshot document) {
                    final data = document.data() as Map<String, dynamic>;
                    final name = data['name'] ?? 'Nombre no disponible';
                    return ListTile(
                      title: Text(name),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
