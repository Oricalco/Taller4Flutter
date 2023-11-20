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
        title: Text('Consejos para los animales'),
      ),
      body: FirestoreConsejos(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddConsejoForm(),
              ));
            },
            child: Icon(Icons.add),
          ),
          SizedBox(width: 16), // Espacio entre los botones
          //FloatingActionButton(
          //  onPressed: () {
          //    _removeConsejo(); // Lógica para quitar el consejo
          //  },
          //  child: Icon(Icons.remove),
          //),
        ],
      ),
    );
  }
}

class FirestoreConsejos extends StatefulWidget {
  @override
  _FirestoreConsejosState createState() => _FirestoreConsejosState();
}

class _FirestoreConsejosState extends State<FirestoreConsejos> {
  PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final contenido = data['Contenido'] ?? 'Contenido no disponible';

              return Column(
                children: [
                  ListTile(
                    title: Text('Consejo:'),
                    subtitle: Text(contenido),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          if (index > 0) {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      Text('${index + 1} / ${docs.length}'),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {
                          if (index < docs.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
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

// Función para quitar el consejo actual
void _removeConsejo() {
  // Obtén la referencia al consejo actual y elimínalo de la base de datos
  // Puedes usar la referencia del documento actual o alguna lógica específica para tu aplicación
  // Ejemplo: FirebaseFirestore.instance.collection('consejos').doc('ID_DEL_DOCUMENTO').delete();
}
