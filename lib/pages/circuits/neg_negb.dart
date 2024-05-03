import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as Constants;

class NegNegClipper extends StatefulWidget {
  // final int circuitkey;

  const NegNegClipper({Key? key}) : super(key: key);
  @override
  _NegNegClipperState createState() => _NegNegClipperState();
}

class _NegNegClipperState extends State<NegNegClipper> {
  final double _capacitorValue = 0.0;
  String _showValue = '';
  double _resistorVal = 0.0;

  late final String _apiUrl;
  double _sourceVoltVal = 0.0;
  double _resistorValue = 0.0;
  double _biasedVolt = 0.0;
  final _formKey = GlobalKey<FormState>();
  List<double> timeData = [];
  List<double> n1Data = [];
  List<double> n2Data = [];
  bool _showPopup = false;
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

  Future<void> _onFormSubmitted() async {
    final validation = _formKey.currentState!.validate();
    if (!validation) {
      return;
    }
    _formKey.currentState!.save();
    // _showValue = 'Resistor: $_resistorValue Ω, Capacitor: $_capacitorValue F';
    _closePopup();
  }

  @override
  void initState() {
    super.initState();
    _apiUrl = '${Constants.apiUrl}/api/bclipper/4';
  }

  Future<void> fetchData() async {
    final uri = Uri.parse(_apiUrl);
    final response = await http.post(uri,
        body: jsonEncode({
          "resistorV": _resistorValue,
          "sourceVolt": _sourceVoltVal,
          "biasedVoltVal": _biasedVolt
        }));
    // final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        timeData = List<double>.from(data['time']);
        n1Data = List<double>.from(data['yi']); //input data
        n2Data = List<double>.from(data['yo']); //output data
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed"),
          duration: Duration(seconds: 3),
        ),
      );
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
        title: const Text(" Negative Bias Negative Clipper"),
      ),
      body: Stack(
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('assets/images/neg_posbias.png'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await fetchData();
                },
                child: const Text('Fetch Data'),
              ),
              const SizedBox(height: 20),
              if (timeData.isNotEmpty && n1Data.isNotEmpty && n2Data.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    height: 450,
                    width: 550,
                    child: buildLineChart(),
                  ),
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
                    child: Form(
                      key: _formKey,
                      child: Container(
                        width: 250.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize:
                                MainAxisSize.min, // Avoid exceeding screen size
                            children: [
                              const Text(
                                'Enter Values',
                                style: TextStyle(fontSize: 18.0),
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Resistor Value (Ω)',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  setState(() {
                                    _resistorValue =
                                        double.tryParse(value!) ?? 0.0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Input Voltage(V)',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  setState(() {
                                    _sourceVoltVal =
                                        double.tryParse(value!) ?? 0.0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Biasing Voltage(V)',
                                ),
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  setState(() {
                                    _biasedVolt =
                                        double.tryParse(value!) ?? 0.0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              ElevatedButton(
                                onPressed: () {
                                  _onFormSubmitted();
                                  // sendData();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPopup,
        child: const Icon(Icons.add),
      ),
    );
  }
}
