import 'package:flutter/material.dart';

class GaleriaPage extends StatelessWidget {
  final List<String> imagenes = [
    'assets/imagen1.jpeg',
    'assets/imagen2.jpg',
    'assets/imagen3.jpg',
  ];

  final List<String> nombres = [
    'Balto',
    'Luna',
    'Max',
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Galería de Imágenes'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
        ),
        itemCount: imagenes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DetalleImagen(
                    imagenUrl: imagenes[index],
                    nombreImagen: nombres[index], 
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagenes[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class DetalleImagen extends StatelessWidget {
  final String imagenUrl;
  final String nombreImagen;

  const DetalleImagen({super.key, required this.imagenUrl, required this.nombreImagen});

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
            child: Row(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                 
                },
              ),
              const Text('0'),//aca van los megusta a futuro
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