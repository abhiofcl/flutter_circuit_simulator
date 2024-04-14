import 'package:circuit_simulator/pages/circuits/astable_op.dart';
import 'package:circuit_simulator/pages/circuits/inv_opamp.dart';
import 'package:circuit_simulator/pages/circuits/monostable_op.dart';
import 'package:circuit_simulator/pages/circuits/opamp_lpf.dart';
import 'package:circuit_simulator/pages/circuits/schmitt.dart';
import 'package:circuit_simulator/pages/circuits/triangle_gen_op.dart';
import 'package:circuit_simulator/pages/tests/freqtest.dart';
import 'package:flutter/material.dart';

import 'package:circuit_simulator/pages/circuits/neg_clamper.dart';
import 'package:circuit_simulator/pages/circuits/neg_negb.dart';
import 'package:circuit_simulator/pages/circuits/neg_posb.dart';
import 'package:circuit_simulator/pages/circuits/negative_clipper.dart';
import 'package:circuit_simulator/pages/circuits/ninv_opamp.dart';
import 'package:circuit_simulator/pages/circuits/pos_clamper.dart';
import 'package:circuit_simulator/pages/circuits/pos_negb.dart';
import 'package:circuit_simulator/pages/circuits/pos_posb.dart';
import 'package:circuit_simulator/pages/circuits/positive_clipper.dart';

class MyMenu extends StatelessWidget {
  const MyMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipper Menu'),
      ),
      body: ListView.builder(
        itemCount: 16, // Two options in the list
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
              optionText = "Positive Clipper Negative Bias";
              targetWidget = NegPosClipper();

            case 4:
              optionText = "Negative Clipper Positive Bias";
              targetWidget = PosNegClipper();
            case 5:
              optionText = "Negative Clipper Negative Bias";
              targetWidget = NegNegClipper();

            case 6:
              optionText = "Positive clamper";
              targetWidget = PosClamper();
            case 7:
              optionText = "Negative Clamper";
              targetWidget = NegClamper();
            case 8:
              optionText = "Non inverting Opamp amplifier";
              targetWidget = NinVOpamp();
            case 9:
              optionText = "Inverting Opamp amplifier";
              targetWidget = InvOpamp();
            case 10:
              optionText = "Astable Multivibrator using Opamp ";
              targetWidget = AstableOP();
            case 11:
              optionText = "Schmitt Trigger Opamp ";
              targetWidget = Schmitt();
            case 12:
              optionText = "Monostable Multivibrator using Opamp ";
              targetWidget = MonoOP();
            case 13:
              optionText = "Triangle Generator using Opamp ";
              targetWidget = TriangleOP();
            case 14:
              optionText = "LPF using Opamp ";
              targetWidget = LpfOP();
            case 15:
              optionText = "Frequency curve test";
              targetWidget = BodePlot();
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
