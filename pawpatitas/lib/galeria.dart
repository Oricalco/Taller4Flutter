import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GaleriaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Imágenes'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('animales').snapshots(),
        builder: (context, snapshot) {
          final animalData = snapshot.data?.docs;
          if (animalData == null) {
            return CircularProgressIndicator();
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: animalData.length,
            itemBuilder: (context, index) {
              final animal = animalData[index];
              final nombre = animal['nombre'] ?? 'Sin nombre';
              final descripcion = animal['descripcion'] ?? 'Sin descripción';
              final edad = animal['edad'] ?? 'Sin edad';
              final sexo = animal['sexo'] ?? 'Sin sexo';

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetalleImagen(
                        nombreImagen: nombre,
                        descripcion: descripcion,
                        edad: edad,
                        sexo: sexo,
                        imagenUrl: 'assets/imagen$index.jpg',
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/imagen$index.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetalleImagen extends StatelessWidget {
  final String nombreImagen;
  final String descripcion;
  final String edad;
  final String sexo;
  final String imagenUrl;

  const DetalleImagen({
    required this.nombreImagen,
    required this.descripcion,
    required this.edad,
    required this.sexo,
    required this.imagenUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pawpatitas'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imagenUrl,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Nombre:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      nombreImagen,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Descripción:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      descripcion,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Edad:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      edad,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Sexo:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sexo,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                 
                },
              ),
              const Text('0'),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: GaleriaPage(),
  ));
}
