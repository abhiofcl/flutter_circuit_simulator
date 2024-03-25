import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class InputScreen extends StatefulWidget {
  const InputScreen({Key? key}) : super(key: key);

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();
  double _resistorValue = 0.0;
  double _capacitorValue = 0.0;

  Future<void> _sendData() async {
    // ... rest of the _sendData function remains the same ...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Values'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Resistor Value (Ω)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // ... rest of the validation logic ...
                      },
                      onSaved: (newValue) {
                        // ... rest of the onSaved logic ...
                      },
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Capacitor Value (F)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // ... rest of the validation logic ...
                      },
                      onSaved: (newValue) {
                        // ... rest of the onSaved logic ...
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0), // Spacing after text fields
              ElevatedButton(
                onPressed: _sendData,
                child: Text('Send Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
