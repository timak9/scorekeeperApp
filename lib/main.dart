import 'package:flutter/material.dart';
import 'JsonReader.dart'; // Fichier contenant la fonction readJson
import 'HomePage.dart'; // Fichier contenant le widget HomePage
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
