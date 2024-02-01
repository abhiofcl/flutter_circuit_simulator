import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

// import './api.dart';
// import './widgets/op_chart.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String? url;

  // var Data;

  // String QueryText = 'Query';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Circuit Simulator App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: MyChartPage(),
        ),
      ),
    );
  }
}

class MyChartPage extends StatefulWidget {
  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  List<double> timeData = [];
  List<double> n1Data = [];
  List<double> n2Data = [];

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.64.214:5000/api'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        timeData = List<double>.from(data['time']);
        n1Data = List<double>.from(data['yi']); //input data
        n2Data = List<double>.from(data['yo']); //output data
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  LineChart buildLineChart() {
    double maxYValue =
        n1Data.followedBy(n2Data).reduce((a, b) => a > b ? a : b);
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(timeData.length, (index) {
              return FlSpot(timeData[index], n1Data[index]);
            }),
            isCurved: true,
            color: Colors.blue,
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: List.generate(timeData.length, (index) {
              return FlSpot(timeData[index], n2Data[index]);
            }),
            isCurved: true,
            color: Colors.red,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        titlesData: const FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await fetchData();
            },
            child: const Text('Fetch Data'),
          ),
          const SizedBox(height: 20),
          if (timeData.isNotEmpty && n1Data.isNotEmpty)
            Container(
              height: 300,
              width: 300,
              child: buildLineChart(),
            ),
        ],
      ),
    );
  }
}
