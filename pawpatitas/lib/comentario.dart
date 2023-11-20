import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Enviar Correo'),
        ),
        body: EmailForm(),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  @override
  _EmailFormState createState() => _EmailFormState();
}

class _EmailFormState extends State<EmailForm> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _toController,
            decoration: InputDecoration(labelText: 'Para'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(labelText: 'Asunto'),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: _bodyController,
            maxLines: 5,
            decoration: InputDecoration(labelText: 'Cuerpo del Correo'),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              // Aquí puedes implementar la lógica para enviar el correo.
              // Puedes usar la información en _toController.text, _subjectController.text, y _bodyController.text.
              // Por ejemplo, podrías llamar a una función que maneje el envío del correo.
              _sendEmail();
            },
            child: Text('Enviar Correo'),
          ),
        ],
      ),
    );
  }

  // Esta función es un marcador de posición para la lógica de envío de correo.
  void _sendEmail() {
    // Aquí implementarías la lógica real para enviar el correo.
    // Puedes usar las direcciones de correo electrónico y el contenido del cuerpo del correo desde los controladores.
    print(
        'Enviando correo a ${_toController.text} con asunto "${_subjectController.text}" y cuerpo "${_bodyController.text}"');
  }
}
