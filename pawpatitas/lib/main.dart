import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Configura las opciones de Firebase aquí
    options: const FirebaseOptions(
      apiKey: "AIzaSyB7tb_RuD26PCHR_8TAs76ALekpDRxs_pw",
      projectId: "flutter-test-a1515",
      messagingSenderId: "734184596643",
      appId: "1:734184596643:android:390a216637044063cacb16",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomePage(),
    );
  }
}
