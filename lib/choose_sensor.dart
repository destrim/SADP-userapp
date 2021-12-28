import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/network_helper.dart';
import 'choose_chart.dart';

class ChooseSensor extends StatefulWidget {
  const ChooseSensor({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ChooseSensor> createState() => _ChooseSensorState();
}

class _ChooseSensorState extends State<ChooseSensor> {
  List<String> _sensorNames = [];
  final NetworkHelper _networkHelper = NetworkHelper();
  String? value;
  late bool _sensorNameChosen;

  @override
  void initState() {
    _sensorNameChosen = false;
    getSensorNames();
    // setState(() {
    //   Timer.periodic(
    //       const Duration(seconds: 10), (Timer t) {
    //         if(_sensorNames.isNotEmpty) {
    //           t.cancel();
    //         } else {
    //           getSensorNames();
    //         }
    //       });
    // });
    super.initState();
  }

  void getSensorNames() async {
    var response =
        await _networkHelper.get('http://192.168.0.101:8080/sensor/all');
    List<String> tmp = sensorNamesFromJson(response.body);
    tmp.sort();
    setState(() => _sensorNames = tmp);
  }

  List<String> sensorNamesFromJson(String str) =>
      List<String>.from(json.decode(str));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Choose sensor name'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: DropdownButton<String>(
                    value: value,
                    iconSize: 36,
                    isExpanded: true,
                    items: _sensorNames.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      setState(() => this.value = value);
                      setState(() => _sensorNameChosen = true);
                    },
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    child: const Text('Refresh'),
                    onPressed: () {
                      getSensorNames();
                    },
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    child: const Text('Next'),
                    onPressed: _sensorNameChosen
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ChooseChart(title: "title")));
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontSize: 20),
      ));
}
