import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    home: ConsejosPage(),
  ));
}

class ConsejosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consejos de Firestore'),
      ),
      body: FirestoreConsejos(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddConsejoForm(),
          ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FirestoreConsejos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('consejos').snapshots(),
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
            child:
                Text('No hay consejos disponibles en la colección "consejos"'),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: docs.map((DocumentSnapshot document) {
            final data = document.data() as Map<String, dynamic>;
            final contenido = data['Contenido'] ?? 'Contenido no disponible';

            return ListTile(
              title: Text('Consejo:'),
              subtitle: Text(contenido),
            );
          }).toList(),
        );
      },
    );
  }
}

class AddConsejoForm extends StatefulWidget {
  @override
  _AddConsejoFormState createState() => _AddConsejoFormState();
}

class _AddConsejoFormState extends State<AddConsejoForm> {
  final TextEditingController contenidoController = TextEditingController();

  void _submitForm(BuildContext context) {
    FirebaseFirestore.instance.collection('consejos').add({
      'Contenido': contenidoController.text,
    });

    Navigator.of(context).pop();
    _showConfirmationSnackBar(context);
  }

  void _showConfirmationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Consejo guardado exitosamente'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Consejo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: contenidoController,
              decoration: InputDecoration(labelText: 'Contenido del Consejo'),
            ),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Guardar Consejo'),
            ),
          ],
        ),
      ),
    );
  }
}
