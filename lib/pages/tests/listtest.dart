import 'package:circuit_simulator/pages/circuits/negative_clipper.dart';
import 'package:circuit_simulator/pages/circuits/ninv_opamp.dart';
import 'package:circuit_simulator/pages/circuits/pos_posb.dart';
import 'package:circuit_simulator/pages/circuits/positive_clipper.dart';
import 'package:flutter/material.dart';

class MyMenu extends StatelessWidget {
  const MyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipper Menu'),
      ),
      body: ListView.builder(
        itemCount: 4, // Two options in the list
        itemBuilder: (context, index) {
          final String optionText;
          final Widget targetWidget; // Widget to navigate to

          switch (index) {
            case 0:
              optionText = 'Positive Clipper';
              targetWidget = PosClipper();
              break;
            case 1:
              optionText = 'Negative Clipper';
              targetWidget = NegClipper();
              break;
            case 2:
              optionText = "Positive Clipper Positive Bias";
              targetWidget = PosPosClipper();
            case 3:
              optionText = "Non inverting Opamp amplifier";
              targetWidget = NinVOpamp();
            default:
              optionText = 'Unknown Option';
              targetWidget = const Scaffold(
                body: Center(child: Text('Invalid Selection')),
              );
          }

          return ListTile(
            title: Text(optionText),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetWidget),
            ),
          );
        },
      ),
    );
  }
}
