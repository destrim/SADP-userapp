import 'package:flutter/material.dart';
import 'package:test_app/date_range_chart.dart';
import 'package:test_app/live_data.dart';

class ChooseDataPresentation extends StatefulWidget {
  const ChooseDataPresentation({Key? key, required this.sensorName}) : super(key: key);

  final String sensorName;

  @override
  State<ChooseDataPresentation> createState() => _ChooseDataPresentationState();
}

class _ChooseDataPresentationState extends State<ChooseDataPresentation> {

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
                child: const Text("date range chart"),
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
                child: const Text("LIVE data"),
                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            LiveData(sensorName: widget.sensorName)
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
