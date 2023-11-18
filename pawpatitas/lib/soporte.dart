import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'consejos.dart';

class SoportePage extends StatefulWidget {
  const SoportePage({Key? key}) : super(key: key);

  @override
  _SoportePageState createState() => _SoportePageState();
}

class _SoportePageState extends State<SoportePage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Soporte', style: TextStyle(fontSize: 45))),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.8, // Utiliza el 80% del ancho de la pantalla
          height: screenHeight *
              0.6, // Define un porcentaje de altura (en este caso, 60%)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Dejar un Comentario'),
                        content: const Text('Agrega tu comentario aquí.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const ListTile(
                  title: Text('Dejar un Comentario'),
                  leading: Icon(Icons.comment),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Notificar Animal en Abandono'),
                        content: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nombreController,
                                decoration:
                                    const InputDecoration(labelText: 'Nombre'),
                              ),
                              TextFormField(
                                controller: contactoController,
                                decoration: const InputDecoration(
                                    labelText: 'Contacto'),
                              ),
                              TextFormField(
                                controller: descripcionController,
                                decoration: const InputDecoration(
                                    labelText: 'Descripción'),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Enviar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const ListTile(
                  title: Text('Notificar Animal en Abandono'),
                  leading: Icon(Icons.report),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Consejos Cuidado Animal'),
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: ConsejosPage(),
                        ),
                      );
                    },
                  );
                },
                child: const ListTile(
                  title: Text('Consejos Cuidado Animal'),
                  leading: Icon(Icons.lightbulb),
                ),
              ),
              const Divider(),
              InkWell(
                onTap: () {
                  const phoneNumber = '+56912345678';
                  launch('tel:$phoneNumber');
                },
                child: const ListTile(
                  title: Text('Contáctanos'),
                  leading: Icon(Icons.phone),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: SoportePage(),
    ),
  );
}
