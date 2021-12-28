import 'package:flutter/material.dart';
import 'package:test_app/live_chart.dart';
import 'live_chart.dart';
import 'choose_sensor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChooseSensor(title: 'Flutter Demo Home Page'),
    );
  }
}
