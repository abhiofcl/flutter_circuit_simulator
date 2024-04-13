// import 'package:circuit_simulator/pages/tests/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:lib/developer_series.dart';

// class DeveloperChart extends StatelessWidget {
//   final List<DeveloperSeries> data;

//   DeveloperChart({required this.data});
//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<DeveloperSeries, num>> series = [
//       charts.Series(
//           id: "developers",
//           data: data,
//           domainFn: (DeveloperSeries series, _) => series.year,
//           measureFn: (DeveloperSeries series, _) => series.developers,
//           colorFn: (DeveloperSeries series, _) => series.barColor)
//     ];

//     return Container(
//       height: 300,
//       padding: EdgeInsets.all(25),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(9.0),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 "Yearly Growth in the Flutter Community",
//                 style: Theme.of(context).textTheme.bodyText1,
//               ),
//               Expanded(
//                 child: charts.LineChart(
//                   series,
//                   animate: true,
//                   domainAxis: const charts.NumericAxisSpec(
//                     tickProviderSpec: charts.BasicNumericTickProviderSpec(
//                       zeroBound: false,
//                     ),
                    // viewport: charts.NumericExtents(2016, 2022),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
