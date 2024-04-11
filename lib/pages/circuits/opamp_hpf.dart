import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'constants.dart' as Constants;

class HPF extends StatefulWidget {
  const HPF({Key? key}) : super(key: key);

  @override
  _HPFState createState() => _HPFState();
}

class _HPFState extends State<HPF> {
  late final String _apiUrl;
  double _resistorValue = 0.0;
  double _sourceVoltVal = 0.0;
  double _biasedVolt = 0.0;
  List<DataPoint> timeData = [];
  List<DataPoint> n1Data = [];
  List<DataPoint> n2Data = [];
  bool _showPopup = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _apiUrl = '${Constants.apiUrl}/api/clamper/1';
  }

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
    // var validation = _formKey.currentState?.validate();
    // if (!validation!) {
    //   return;
    // }
    _formKey.currentState?.save();
    // _showValue = 'Resistor: $_resistorValue Ω, Capacitor: $_capacitorValue F';
    _closePopup();
  }

  Future<void> fetchData() async {
    final uri = Uri.parse(_apiUrl);
    final response = await http.get(uri);
    // final response = await http.post(
    //   uri,
    //   body: jsonEncode({
    //     "resistorV": _resistorValue,
    //     "sourceVolt": _sourceVoltVal,
    //     "biasedVoltVal": _biasedVolt,
    //   }),
    // );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        timeData = List<DataPoint>.from(
          data['time'].map((x) => DataPoint(x.toDouble(), 0.0)),
        );
        n1Data = List<DataPoint>.from(
          data['yi'].map((x) => DataPoint(x.toDouble(), 0.0)),
        );
        n2Data = List<DataPoint>.from(
          data['yo'].map((x) => DataPoint(x.toDouble(), 0.0)),
        );
      });
    } else {
      print("Some error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Charts test"),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  await fetchData();
                },
                child: const Text('Fetch Data'),
              ),
              if (timeData.isNotEmpty && n1Data.isNotEmpty && n2Data.isNotEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
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
                ),
            ],
          ),
          _showPopup
              ? Positioned(
                  top: 100.0,
                  left: 50.0,
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    child: Form(
                      child: Container(
                        width: 250.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                onChanged: (value) {
                                  setState(() {
                                    _resistorValue =
                                        double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Input Voltage(V)',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _sourceVoltVal =
                                        double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Biasing Voltage(V)',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    _biasedVolt = double.tryParse(value) ?? 0.0;
                                  });
                                },
                              ),
                              const SizedBox(height: 10.0),
                              ElevatedButton(
                                onPressed: () {
                                  _onFormSubmitted();
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
        onPressed: () {
          setState(() {
            _showPopup = !_showPopup;
          });
        },
        child: const Icon(Icons.add),
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
