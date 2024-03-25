import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Popup Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPopup,
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          // Your main content goes here
          Center(
            child: Text(_showValue),
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
                                labelText: 'Capacitor Value (F)',
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
    );
  }
}
