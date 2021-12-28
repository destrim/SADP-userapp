import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:test_app/network_helper.dart';

import 'sensor_data.dart';

class LiveChart extends StatefulWidget {
  const LiveChart({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LiveChart> createState() => _LiveChartState();
}

class _LiveChartState extends State<LiveChart> {
  List<SensorData> _sensorData = [];
  bool loading = true;
  final NetworkHelper _networkHelper = NetworkHelper();
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    getSensorData();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    setState(() {
      Timer.periodic(const Duration(seconds: 5), (Timer t) => getSensorData());
    });
    super.initState();
  }

  void getSensorData() async {
    var response = await _networkHelper.get('http://192.168.0.101:8080/sensor');
    List<SensorData> tmp = sensorDataFromJson(response.body);
    setState(() {
      _sensorData = tmp;
      loading = false;
    });
  }

  List<SensorData> sensorDataFromJson(String str) => List<SensorData>.from(
      json.decode(str).map((x) => SensorData.fromJson(x)));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Live data'),
          centerTitle: true,
        ),
        body: SfCartesianChart(
          title: ChartTitle(text: 'data'),
          legend: Legend(isVisible: true),
          series: <ChartSeries>[
            LineSeries<SensorData, DateTime>(
              name: 'temp',
              dataSource: _sensorData,
              xValueMapper: (SensorData data, _) => data.timestamp,
              yValueMapper: (SensorData data, _) => data.temp,
            )
          ],
          primaryXAxis: DateTimeAxis(
            dateFormat: DateFormat('hh:mm:ss'),
          ),
          primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
          enableAxisAnimation: true,
          zoomPanBehavior: _zoomPanBehavior,
        ),
      ),
    );
  }
}
