import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:test_app/network_helper.dart';

import 'sensor_data.dart';

class DateRangeChart extends StatefulWidget {
  const DateRangeChart({Key? key, required this.sensorName}) : super(key: key);

  final String sensorName;

  @override
  State<DateRangeChart> createState() => _DateRangeChartState();
}

class _DateRangeChartState extends State<DateRangeChart> {
  final NetworkHelper _networkHelper = NetworkHelper();
  final List<String> charTypes = ["temp", "hum"];
  bool loading = true;

  List<SensorData> _sensorData = [];
  String? value;

  late ZoomPanBehavior _zoomPanBehavior;
  // late DateTime dateRangeMin;
  // late DateTime dateRangeMax;
  late DateTime selectedMinDate;
  late DateTime selectedMaxDate;

  @override
  void initState() {
    // getDateRange();
    // selectedMinDate = dateRangeMin;
    // selectedMaxDate = dateRangeMax;
    selectedMinDate = DateTime.now();
    selectedMaxDate = DateTime.now();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    super.initState();
  }

  void getSensorData() async {
    var response = await _networkHelper.get(
        'http://192.168.0.101:8080/sensor/' +
            widget.sensorName +
            '/datainrange?min=' +
            selectedMinDate.toString().split(' ')[0] +
            '&max=' +
            selectedMaxDate.toString().split(' ')[0]);

    List<SensorData> tmp = sensorDataFromJson(response.body);
    setState(() {
      _sensorData = tmp;
      loading = false;
    });
  }

  List<SensorData> sensorDataFromJson(String str) => List<SensorData>.from(
      json.decode(str).map((x) => SensorData.fromJson(x)));

  // void getDateRange() async {
  //   var response = await _networkHelper.get('http://192.168.0.101:8080/sensor/daterange/' + widget.sensorName);
  //   List<DateTime> dateRange = dateRangeFromJson(response.body);
  //   setState(() {
  //     dateRangeMin = dateRange[0];
  //     dateRangeMax = dateRange[1];
  //   }
  //   );
  // }
  //
  // List<DateTime> dateRangeFromJson(String str) {
  //   List<String> stringList = List<String>.from(json.decode(str));
  //   List<DateTime> dateTimeList = [DateTime.parse(stringList[0]), DateTime.parse(stringList[1])];
  //   return dateTimeList;
  // }


  Future<void> _selectMinDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedMinDate,
        // firstDate: DateTime(dateRangeMin.year, dateRangeMin.month),
        // lastDate: DateTime(dateRangeMax.year, dateRangeMax.month)
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now()
    );

    if (picked != null && picked != selectedMinDate) {
      setState(() {
        selectedMinDate = picked;
      });
    }
  }

  Future<void> _selectMaxDate(BuildContext context) async {

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedMaxDate,
        // firstDate: DateTime(dateRangeMin.year, dateRangeMin.month),
        // lastDate: DateTime(dateRangeMax.year, dateRangeMax.month)
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now()
    );

    if (picked != null && picked != selectedMaxDate) {
      setState(() {
        selectedMaxDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('date range chart'),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${selectedMinDate.toLocal()}".split(' ')[0]),
                        const SizedBox(height: 20.0,),
                        RaisedButton(
                          onPressed: () => _selectMinDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("${selectedMaxDate.toLocal()}".split(' ')[0]),
                        const SizedBox(height: 20.0,),
                        RaisedButton(
                          onPressed: () => _selectMaxDate(context),
                          child: const Text('Select date'),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                    child: ElevatedButton(
                      child: const Text("Show"),
                      onPressed: () {
                        getSensorData();
                      },
                    )
                ),
                Container(
                  width: 100,
                  child: DropdownButton<String>(
                    value: value,
                    iconSize: 36,
                    isExpanded: true,
                    items: charTypes.map(buildMenuItem).toList(),
                    onChanged: (value) => setState(() => this.value = value),
                  ),
                ),
                if (value == "temp") Expanded(
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'temp'),
                    // legend: Legend(isVisible: true),
                    series: <ChartSeries>[
                      LineSeries<SensorData, DateTime>(
                        name: 'temp',
                        dataSource: _sensorData,
                        xValueMapper: (SensorData data, _) => data.timestamp,
                        yValueMapper: (SensorData data, _) => data.temp,
                      )
                    ],
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat('yyyy-MM-dd\nHH:mm:ss'),
                    ),
                    primaryYAxis: NumericAxis(labelFormat: '{value}°C'),
                    enableAxisAnimation: true,
                    zoomPanBehavior: _zoomPanBehavior,
                  ),
                ),
                if (value == "hum") Expanded(
                  child: SfCartesianChart(
                    title: ChartTitle(text: 'hum'),
                    // legend: Legend(isVisible: true),
                    series: <ChartSeries>[
                      LineSeries<SensorData, DateTime>(
                        name: 'hum',
                        dataSource: _sensorData,
                        xValueMapper: (SensorData data, _) => data.timestamp,
                        yValueMapper: (SensorData data, _) => data.hum,
                      )
                    ],
                    primaryXAxis: DateTimeAxis(
                      dateFormat: DateFormat('yyyy-MM-dd\nHH:mm:ss'),
                    ),
                    primaryYAxis: NumericAxis(labelFormat: '{value}%'),
                    enableAxisAnimation: true,
                    zoomPanBehavior: _zoomPanBehavior,
                  ),
                ),
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
