// import 'package:circuit_simulator/pages/chatbot/chat_page.dart';
import 'package:circuit_simulator/pages/chatbot/consts.dart';
import 'package:circuit_simulator/pages/tests/listtest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

// import './api.dart';
// import './widgets/op_chart.dart';
void main() {
  Gemini.init(apiKey: GEMINI_API_KEY);
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
                      builder: (context) => const MyMenu(),
                    ),
                  );
                },
                child: const Text("Start Simulate"))
          ],
        ),
      ),
    );
  }
}
