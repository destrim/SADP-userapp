import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/network_helper.dart';
import 'choose_data_presentation.dart';

class ChooseSensor extends StatefulWidget {
  const ChooseSensor({Key? key}) : super(key: key);

  @override
  State<ChooseSensor> createState() => _ChooseSensorState();
}

class _ChooseSensorState extends State<ChooseSensor> {
  List<String> _sensorNames = [];
  final NetworkHelper _networkHelper = NetworkHelper();
  String? chosenSensorName;
  late bool _isSensorNameChosen;

  @override
  void initState() {
    _isSensorNameChosen = false;
    getSensorNames();
    super.initState();
  }

  void getSensorNames() async {
    var response =
        await _networkHelper.get('http://sadp-server.herokuapp.com/sensor/all');
    List<String> tmp = sensorNamesFromJson(response.body);
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
                    value: chosenSensorName,
                    iconSize: 36,
                    isExpanded: true,
                    items: _sensorNames.map(buildMenuItem).toList(),
                    onChanged: (value) {
                      setState(() => chosenSensorName = value);
                      setState(() => _isSensorNameChosen = true);
                    },
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    child: const Text('Refresh'),
                    onPressed: () {
                      getSensorNames();
                      if (_sensorNames.isEmpty) {
                        _isSensorNameChosen = false;
                      }
                    },
                  ),
                ),
                Container(
                  child: ElevatedButton(
                    child: const Text('Next'),
                    onPressed: _isSensorNameChosen
                        ? () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChooseDataPresentation(sensorName: chosenSensorName!,)));
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
