import 'package:circuit_simulator/pages/charttest.dart';
import 'package:flutter/material.dart';

class SemList extends StatelessWidget {
  const SemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text("This is the main screen"),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(8, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CircuitList(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.blue),
                child: Center(
                  child: Container(
                    child: Text("S ${index + 1}"),
                  ),
                ),
              ),
            );
          }),
        ));
  }
}

class CircuitList extends StatelessWidget {
  const CircuitList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Circuit Selection Screen"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.build_circle_outlined),
            title: const Text("Negative Clipper"),
            tileColor: Colors.blue,
            splashColor: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyChartPage(circuitkey: 1),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.build_circle_outlined),
            title: const Text("Positive Clipper"),
            tileColor: Colors.blue,
            splashColor: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyChartPage(circuitkey: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
