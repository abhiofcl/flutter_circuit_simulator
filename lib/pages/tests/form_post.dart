import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormPost extends StatefulWidget {
  const FormPost({super.key});

  @override
  State<FormPost> createState() => _FormPostState();
}

class _FormPostState extends State<FormPost> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String finalresponse = '';
  late final String _apiUrl;
  void initState() {
    super.initState();
    _apiUrl = 'http://192.168.98.214:5000/api/1';
  }

  Future<void> savingData() async {
    final validation = _formKey.currentState!.validate();
    if (!validation) {
      return;
    }
    _formKey.currentState!.save();
  }

  Future<void> sendData() async {
    final uri = Uri.parse(_apiUrl);
    final response = await http.post(uri,
        body: jsonEncode({
          "name": name,
        }));
  }

  Future<void> fetchData() async {
    final uri = Uri.parse(_apiUrl);
    final response = await http.get(uri);
    final decoded = json.decode(response.body) as Map<String, dynamic>;
    setState(() {
      finalresponse = decoded['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (value) {
              name = value;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                savingData();
                sendData();
              }),
          ElevatedButton(
              child: const Text("Fetch data"),
              onPressed: () {
                fetchData();
              }),
          const Text("THis will be the fetched data"),
          Text(finalresponse)
        ],
      ),
    );
  }
}
