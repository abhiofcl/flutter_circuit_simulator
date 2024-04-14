import 'dart:convert';
import 'dart:math' as math;

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../circuits/constants.dart' as Constants;

class BodePlot extends StatefulWidget {
  @override
  _BodePlotState createState() => _BodePlotState();
}

class _BodePlotState extends State<BodePlot> {
  List<DataPoint> frequencyData = [];
  late final String _apiUrl;

  @override
  void initState() {
    super.initState();
    _apiUrl = '${Constants.apiUrl}/api/freqres/1';
    // Fetch data from the Flask server when the widget initializes
  }

  void fetchData() async {
    final uri = Uri.parse('${Constants.apiUrl}/api/opamp/hpf/1');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        frequencyData = responseData
            .map<DataPoint>(
                (item) => DataPoint(item['frequency'], item['magnitude']))
            .toList();
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bode Plot Magnitude Graph'),
      ),
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: () {
                fetchData();
              },
              child: Text("fetch")),
          Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: charts.LineChart(
                _createSeries(),
                animate: true,
                defaultRenderer: charts.LineRendererConfig(
                  includePoints: true,
                ),
                domainAxis: const charts.NumericAxisSpec(
                  tickProviderSpec: charts.StaticNumericTickProviderSpec(
                    // Provide custom tick values for the x-axis
                    [
                      charts.TickSpec(1, label: '10'),
                      charts.TickSpec(2, label: '100'),
                      charts.TickSpec(3, label: '1000'),
                      charts.TickSpec(4, label: '10000'),
                      charts.TickSpec(5, label: '100000'),
                      // Add more tick values as needed
                    ],
                  ),
                  renderSpec: charts.GridlineRendererSpec(
                    labelRotation: 45,
                    labelAnchor: charts.TickLabelAnchor.after,
                  ),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec: charts.BasicNumericTickProviderSpec(
                    zeroBound: false,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<DataPoint, double>> _createSeries() {
    return [
      charts.Series<DataPoint, double>(
        id: 'Magnitude',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint data, _) =>
            math.log(data.frequency) / math.log(10),
        measureFn: (DataPoint data, _) => data.magnitude,
        data: frequencyData,
      ),
    ];
  }
}

class DataPoint {
  final double frequency;
  final double magnitude;

  DataPoint(this.frequency, this.magnitude);
}
