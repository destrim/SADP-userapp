import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/service/network_helper.dart';

import '../model/sensor_data.dart';

class LiveData extends StatefulWidget {
  const LiveData({Key? key, required this.sensorName}) : super(key: key);

  final String sensorName;

  @override
  State<LiveData> createState() => _LiveDataState();
}

class _LiveDataState extends State<LiveData> {
  final NetworkHelper _networkHelper = NetworkHelper();
  final List<String> charTypes = ["temp", "hum"];

  String? value;
  SensorData latestSensorData = SensorData(name: "", timestamp: DateTime.fromMicrosecondsSinceEpoch(0), temp: 0.0, hum: 0.0);

  @override
  void initState() {
    getLatestSensorData();
    setState(() {
      Timer.periodic(const Duration(seconds: 5), (Timer t) => getLatestSensorData());
    });
    super.initState();
  }

  void getLatestSensorData() async {
    var response = await _networkHelper.get(
        'http://sadp-server.herokuapp.com/sensor/' +
            widget.sensorName +
            '/latest'
    );
    SensorData tmp = sensorDataFromJson(response.body);
    setState(() {
      latestSensorData = tmp;
    });
  }

  SensorData sensorDataFromJson(String str) => SensorData.fromJson(json.decode(str));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LIVE data'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                Text('temperature: ' + latestSensorData.temp.toString() + "°C"),
                Text('humidity: ' + latestSensorData.hum.toString() + "%"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: const TextStyle(fontSize: 20),
      ));
}
