import 'package:circuit_simulator/pages/circuit_list.dart';
import 'package:circuit_simulator/pages/circuits/opamp_hpf.dart';
import 'package:circuit_simulator/pages/tests/form_post.dart';
import 'package:circuit_simulator/pages/tests/freqtest.dart';
import 'package:circuit_simulator/pages/tests/listtest.dart';
import 'package:flutter/material.dart';

import 'widgets/fabtest.dart';
// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:http/http.dart' as http;

// import './api.dart';
// import './widgets/op_chart.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: const Text("Circuit Simulator"),
          ),
          body: MyMenu(),
        ),
      ),
    );
  }
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Circuit Simulator"),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMenu(),
                    ),
                  );
                },
                child: Text("Start Simulate"))
          ],
        ),
      ),
    );
  }
}
