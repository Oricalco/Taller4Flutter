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
              _sendEmail();
            },
            child: Text('Enviar Correo'),
          ),
        ],
      ),
    );
  }

  void _sendEmail() {
    //Print para test de la funcion
    print(
        'Enviando correo a ${_toController.text} con asunto "${_subjectController.text}" y cuerpo "${_bodyController.text}"');
  }
}
