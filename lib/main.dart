import 'package:flutter/material.dart';
import 'package:sale_agent/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen()
    );
  }
}
  // Function to create sliders for volume, pitch, and rate

