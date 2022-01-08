import 'package:flutter/material.dart';
import 'view/choose_sensor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SADP App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChooseSensor(),
    );
  }
}
