import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart' as Constants;

class LineChartPage extends StatefulWidget {
  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  List<DataPoint> timeData = [];
  List<DataPoint> n1Data = [];
  List<DataPoint> n2Data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('${Constants.apiUrl}/api/clamper/1'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        timeData = List<DataPoint>.from(
          data['time'].map<DataPoint>((x) => DataPoint(x.toDouble(), 0.0)),
        );
        n1Data = List<DataPoint>.from(
          data['yi'].map<DataPoint>((x) => DataPoint(x.toDouble(), 0.0)),
        );
        n2Data = List<DataPoint>.from(
          data['yo'].map<DataPoint>((x) => DataPoint(x.toDouble(), 0.0)),
        );
      });
    } else {
      print("Failed to load data. Status code: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (timeData.isNotEmpty && n1Data.isNotEmpty && n2Data.isNotEmpty)
              Container(
                height: 300,
                width: 300,
                child: charts.LineChart(
                  _createSeries(),
                  animate: true,
                  defaultRenderer: charts.LineRendererConfig(
                    includePoints: true,
                  ),
                  domainAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      desiredTickCount: 5,
                    ),
                  ),
                  primaryMeasureAxis: charts.NumericAxisSpec(
                    tickProviderSpec: charts.BasicNumericTickProviderSpec(
                      desiredTickCount: 5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<DataPoint, double>> _createSeries() {
    return [
      charts.Series<DataPoint, double>(
        id: 'yi',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint data, _) => data.x,
        measureFn: (DataPoint data, _) => data.y,
        data: n1Data,
      ),
      charts.Series<DataPoint, double>(
        id: 'yo',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DataPoint data, _) => data.x,
        measureFn: (DataPoint data, _) => data.y,
        data: n2Data,
      ),
    ];
  }
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}
