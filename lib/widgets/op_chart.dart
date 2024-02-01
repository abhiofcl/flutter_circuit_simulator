import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OpChart extends StatefulWidget {
  const OpChart({super.key});

  @override
  State<OpChart> createState() => _OpChartState();
}

class _OpChartState extends State<OpChart> {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 10,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
            ],
          )
        ],
      ),
    );
  }
}
