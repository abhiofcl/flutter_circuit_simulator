import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../circuits/constants.dart' as Constants;

class LineChartPage extends StatefulWidget {
  @override
  _LineChartPageState createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage> {
  Future<List<Map<String, dynamic>>>? _dataFuture;

  @override
  void initState() {
    super.initState();
    try {
      _dataFuture = fetchData();
    } catch (identifier) {
      print("some isues");
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response =
        await http.get(Uri.parse('${Constants.apiUrl}/api/clamper/1'));
    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);
      return List<Map<String, dynamic>>.from(dataList);
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Line Chart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final List<Map<String, dynamic>> dataList = snapshot.data!;
            final List<DataPoint> chartData = dataList.map((map) {
              final double time = map['time']!.toDouble();
              final double yo = map['yo']!.toDouble();
              return DataPoint(time, yo);
            }).toList();
            return Container(
              height: 300,
              width: 300,
              child: charts.LineChart(
                _createSeries(chartData),
                animate: false,
                defaultRenderer: charts.LineRendererConfig(
                  includePoints: true,
                ),
                domainAxis: charts.NumericAxisSpec(
                  tickProviderSpec: charts.BasicNumericTickProviderSpec(
                    zeroBound: false,
                  ),
                ),
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec: charts.BasicNumericTickProviderSpec(
                    zeroBound: false,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<charts.Series<DataPoint, double>> _createSeries(List<DataPoint> data) {
    return [
      charts.Series<DataPoint, double>(
        id: 'yo',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (DataPoint data, _) => data.x,
        measureFn: (DataPoint data, _) => data.y,
        data: data,
      ),
    ];
  }
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}
