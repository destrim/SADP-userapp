import 'package:flutter/material.dart';
import 'package:test_app/date_range_chart.dart';
import 'package:test_app/live_chart.dart';

class ChooseChart extends StatefulWidget {
  const ChooseChart({Key? key, required this.sensorName}) : super(key: key);

  final String sensorName;

  @override
  State<ChooseChart> createState() => _ChooseChartState();
}

class _ChooseChartState extends State<ChooseChart> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Choose chart type'),
      centerTitle: true,
    ),
    body: Center(
      child: Container(
        width: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: ElevatedButton(
                child: const Text("Date range chart"),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          DateRangeChart(sensorName: widget.sensorName)));
                },
              )
            ),
            Container(
              child: ElevatedButton(
                child: const Text("LIVE chart"),
                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            LiveChart(sensorName: widget.sensorName)
                        ));
                },
              )
            ),
          ],
        ),
      ),
    ),
  );
}
