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
    // Obtener el usuario autenticado
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Concatenar la dirección como un solo campo de texto
      String direccion =
          '${ciudadController.text}, ${calleController.text}, ${numeroCasaController.text}';

      // Guardar los datos en la base de datos
      await FirebaseFirestore.instance.collection('formulario').add({
        'nombres': nombresController.text,
        'apellidos': apellidosController.text,
        'rut': rutController.text,
        'telefono': '+569${telefonoController.text}', // Agregar +569 al número ingresado
        'correo': user.email, // Usar el correo del usuario autenticado
        'direccion': direccion,
        'nombre_mascota': widget.nombreAnimal, // Agregar el nombre de la mascota
      });

      // Mostrar mensaje de confirmación y redirigir
      _showConfirmationSnackBar(context);
    } else {
      // Manejar el caso en el que no se encuentra un usuario autenticado
      print('Error: Usuario no autenticado');
    }
  }

  void _showConfirmationSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Formulario enviado exitosamente'),
      ),
    );

    // Añadir la redirección a la página de inicio después de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Cierra la página actual (formulario.dart)
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
