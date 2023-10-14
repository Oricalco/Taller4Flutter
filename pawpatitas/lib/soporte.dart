import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SoportePage extends StatefulWidget {
  const SoportePage({super.key});

  @override
  _SoportePageState createState() => _SoportePageState();
}

class _SoportePageState extends State<SoportePage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController contactoController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  final PageController _pageController = PageController();
  final List<String> consejos = [
    'Proporciona una alimentación equilibrada y adecuada para tu mascota.',
    'Asegúrate de que tu mascota tenga suficiente ejercicio y actividad física.',
    'Programa revisiones veterinarias regulares para mantener la salud de tu mascota.',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text('Soporte', style: TextStyle(fontSize: 45))),
      ),
      body: Center(
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
                              decoration:
                                  const InputDecoration(labelText: 'Contacto'),
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
                      content: SizedBox(
                        height: 200.0,
                        width: 300.0,
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: consejos.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading:
                                        const Icon(Icons.lightbulb_outline),
                                    title: Text('Consejo ${index + 1}'),
                                    subtitle: Text(consejos[index]),
                                  );
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    _pageController.previousPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
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
