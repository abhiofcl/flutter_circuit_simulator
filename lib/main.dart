// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import './api.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? url;

  var Data;

  String QueryText = 'Query';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Circuit Simulator App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  onChanged: (value) {
                    url = 'http://10.0.2.2:5000/api?Query=$value';
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        Data = await GetData(Uri.parse(url!));

                        var DecodedData = jsonDecode(Data);

                        setState(() {
                          QueryText = DecodedData['Query'];
                        });
                      },
                      child: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  QueryText,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
