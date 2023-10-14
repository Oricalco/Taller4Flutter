import 'package:flutter/material.dart';

class DonarPage extends StatelessWidget {
  const DonarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Ayúdanos a continuar nuestra labor!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
              },
              child: const Text('Donar Ahora'),
            ),
          ],
        ),
      ),
    );
  }
}
