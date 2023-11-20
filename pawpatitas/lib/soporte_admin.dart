import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'consejos.dart';
import 'comentario.dart';
//import 'consejos_usuario.dart';

class SoportePageAdmin extends StatefulWidget {
  const SoportePageAdmin({Key? key}) : super(key: key);

  @override
  _SoportePageAdminState createState() => _SoportePageAdminState();
}

class _SoportePageAdminState extends State<SoportePageAdmin> {
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
          child: Text('Soporte', style: TextStyle(fontSize: 45)),
        ),
      ),
      body: Center(
        child: Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            const Text('Enviar un comentario a nuestro correo'),
                        content: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: EmailForm(),
                        ),
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
                          child: ConsejosPage(), // Vista de admin
                          //child: ConsejosUsuario(), // Vista de usuario
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
      home: SoportePageAdmin(),
    ),
  );
}
