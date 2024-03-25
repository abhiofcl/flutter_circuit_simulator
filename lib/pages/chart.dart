import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

class MyChartPage extends StatefulWidget {
  final int circuitkey;

  const MyChartPage({Key? key, required this.circuitkey}) : super(key: key);
  @override
  _MyChartPageState createState() => _MyChartPageState();
}

class _MyChartPageState extends State<MyChartPage> {
  List<double> timeData = [];
  List<double> n1Data = [];
  List<double> n2Data = [];
  late final String _apiUrl;
  bool _showPopup = false;
  double _resistorValue = 0.0;
  double _capacitorValue = 0.0;
  String _showValue = '';
  void _openPopup() {
    setState(() {
      _showPopup = true;
    });
  }

  void _closePopup() {
    setState(() {
      _showPopup = false;
    });
  }

  void _onFormSubmitted() {
    // Handle form submission logic here (e.g., print values or send to backend)
    print('Resistor: $_resistorValue, Capacitor: $_capacitorValue');
    _showValue = 'Resistor: $_resistorValue Ω, Capacitor: $_capacitorValue F';
    _closePopup();
  }

  @override
  void initState() {
    super.initState();
    _apiUrl = 'http://192.168.71.214:5000/api/${widget.circuitkey}';
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(_apiUrl));

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.circuitkey == 1
              ? "Negative Clipper"
              : (widget.circuitkey == 2
                  ? "Positive Clipper"
                  : (widget.circuitkey == 3 ? "Positive Clamper" : "Title")),
        ),
      ),
      body: Stack(
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(
                  widget.circuitkey == 1
                      ? 'assets/images/circuit.png'
                      : 'assets/images/circuit2.png',
                ),
              ),
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Go back"),
              ),
            ],
          ),
          _showPopup
              ? Positioned(
                  // Adjust positioning based on your needs
                  top: 100.0,
                  left: 50.0,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 250.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize:
                              MainAxisSize.min, // Avoid exceeding screen size
                          children: [
                            Text(
                              'Enter Values',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Resistor Value (Ω)',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _resistorValue =
                                      double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Input Voltage(V)',
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _capacitorValue =
                                      double.tryParse(value) ?? 0.0;
                                });
                              },
                            ),
                            SizedBox(height: 10.0),
                            ElevatedButton(
                              onPressed: _onFormSubmitted,
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPopup,
        child: const Icon(Icons.add),
      ),
    );
  }
}
