import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FormularioAdopcion extends StatefulWidget {
  final String nombreAnimal;

  FormularioAdopcion({required this.nombreAnimal});

  @override
  _FormularioAdopcionState createState() => _FormularioAdopcionState();
}

class _FormularioAdopcionState extends State<FormularioAdopcion> {
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController rutController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController calleController = TextEditingController();
  final TextEditingController numeroCasaController = TextEditingController();
  final TextEditingController ciudadController = TextEditingController();

  void _submitForm(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String direccion =
          '${ciudadController.text}, ${calleController.text}, ${numeroCasaController.text}';

      await FirebaseFirestore.instance.collection('formulario').add({
        'nombres': nombresController.text,
        'apellidos': apellidosController.text,
        'rut': rutController.text,
        'telefono': '+569${telefonoController.text}', // Agregar +569 telefono
        'correo': user.email,
        'direccion': direccion,
        'nombre_mascota': widget.nombreAnimal,
      });
      _showConfirmationSnackBar(context);
    } else {
      print('Error: Usuario no autenticado');
    }
  }

  void _showConfirmationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Formulario enviado exitosamente'),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Adopción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nombresController,
              decoration: InputDecoration(labelText: 'Nombres'),
            ),
            TextFormField(
              controller: apellidosController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextFormField(
              controller: rutController,
              decoration: InputDecoration(labelText: 'RUT'),
            ),
            TextFormField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: calleController,
              decoration: InputDecoration(labelText: 'Calle'),
            ),
            TextFormField(
              controller: numeroCasaController,
              decoration: InputDecoration(labelText: 'Número de Casa'),
            ),
            TextFormField(
              controller: ciudadController,
              decoration: InputDecoration(labelText: 'Ciudad'),
            ),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Enviar Formulario'),
            ),
          ],
        ),
      ),
    );
  }
}
