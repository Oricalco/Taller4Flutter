import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AnimalUploadForm extends StatefulWidget {
  @override
  _AnimalUploadFormState createState() => _AnimalUploadFormState();
}

class _AnimalUploadFormState extends State<AnimalUploadForm> {
  File? _image;
  final picker = ImagePicker();
  String? _animalName;
  String? _animalBreed;
  String? _animalDescription;
  String? _animalIngressDate;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cargar Animal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: getImage,
              child: Text('Seleccionar Imagen'),
            ),
            _image == null
                ? Text('No se ha seleccionado ninguna imagen')
                : Image.file(_image!),
            TextField(
              onChanged: (value) => _animalName = value,
              decoration: InputDecoration(labelText: 'Nombre del Animal'),
            ),
            TextField(
              onChanged: (value) => _animalBreed = value,
              decoration: InputDecoration(labelText: 'Raza del Animal'),
            ),
            TextField(
              onChanged: (value) => _animalDescription = value,
              decoration: InputDecoration(labelText: 'Descripción del Animal'),
            ),
            TextField(
              onChanged: (value) => _animalIngressDate = value,
              decoration: InputDecoration(labelText: 'Fecha de Ingreso'),
            ),
            ElevatedButton(
              onPressed: () => uploadAnimal(),
              child: Text('Añadir Mascota'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadAnimal() async {
    try {
      if (_image != null &&
          _animalName != null &&
          _animalBreed != null &&
          _animalDescription != null &&
          _animalIngressDate != null) {
        final storage = FirebaseStorage.instance;
        final storageRef = storage.ref().child('animal_images/${DateTime.now()}.png');
        await storageRef.putFile(_image!);

        final downloadUrl = await storageRef.getDownloadURL();

        final firestore = FirebaseFirestore.instance;
        firestore.collection('animals').add({
          'name': _animalName,
          'breed': _animalBreed,
          'description': _animalDescription,
          'ingressDate': _animalIngressDate,
          'imageUrl': downloadUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Animal subido con éxito'),
          ),
        );

        setState(() {
          _image = null;
          _animalName = null;
          _animalBreed = null;
          _animalDescription = null;
          _animalIngressDate = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, complete todos los campos y seleccione una imagen'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al subir el animal: $e'),
        ),
      );
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AnimalUploadForm(),
  ));
}
