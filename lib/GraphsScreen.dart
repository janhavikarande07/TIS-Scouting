import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:ftc_analyzer/values_.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validation_textformfield/validation_textformfield.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {


  Future<List<_BarData>> fetchChartData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('$division $matchType').get();
    final docs = querySnapshot.docs;

    Map<String, List<Map<String, dynamic>>> teamGrouped = {};

    for (var doc in docs) {
      final data = doc.data();
      final team = data['teamNumber'].toString();

      if (!teamGrouped.containsKey(team)) {
        teamGrouped[team] = [];
      }
      teamGrouped[team]!.add(data);
    }

    List<_BarData> averagedData = [];

    teamGrouped.forEach((team, matches) {
      double autoSum = 0;
      double teleSum = 0;
      double ascendSum = 0;

      for (var match in matches) {
        if (match["autoSequence"].any((e) => e.toString().contains("park"))) {
          match['autoScore']-=3;
        }
        autoSum += (match['autoScore'] ?? 0).toDouble();
        teleSum += (match['teleopScore'] ?? 0).toDouble();
        ascendSum += (match['ascendPoints'] ?? 0).toDouble();
      }

      int count = matches.length;
      averagedData.add(
        _BarData(team, autoSum / count, teleSum / count, ascendSum / count),
      );
    });

    averagedData.sort((a, b) {
      double aTotal = a.part1 + a.part2 + a.part3 ;
      double bTotal = b.part1 + b.part2 + b.part3 ;
      return bTotal.compareTo(aTotal); // descending order
    });

    for (var a in averagedData) {
      double total = a.part1 + a.part2 + a.part3;
      print('Team: ${a.label}, Total: $total');
    }

    return averagedData;
  }

  Future<List<_TeleOpData>> fetchTeleOpChartData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('$division $matchType').get();
    final docs = querySnapshot.docs;

    Map<String, List<Map<String, dynamic>>> teamGrouped = {};

    for (var doc in docs) {
      final data = doc.data();
      final team = data['teamNumber'].toString();

      if (!teamGrouped.containsKey(team)) {
        teamGrouped[team] = [];
      }
      teamGrouped[team]!.add(data);
    }

    List<_TeleOpData> averagedData = [];

    teamGrouped.forEach((team, matches) {
      double h_b_Sum = 0;
      double l_b_Sum = 0;
      double net_Sum = 0;
      double h_c_Sum = 0;
      double l_c_Sum = 0;
      double p_oz_Sum = 0;
      double A1_Sum = 0;
      double A2_Sum = 0;
      double A3_Sum = 0;

      for (var match in matches) {
        h_b_Sum += (match['teleopSequence'][4] ?? 0).toDouble();
        l_b_Sum += (match['teleopSequence'][5] ?? 0).toDouble();
        net_Sum += (match['teleopSequence'][6] ?? 0).toDouble();
        h_c_Sum += (match['teleopSequence'][0] ?? 0).toDouble();
        l_c_Sum += (match['teleopSequence'][1] ?? 0).toDouble();
        p_oz_Sum += (match['teleopSequence'][3] ?? 0).toDouble();
        A1_Sum += (match['ascendPoints'] == 3) ? 1.0 : 0.0;
        A2_Sum += (match['ascendPoints'] == 15) ? 1.0 : 0.0;
        A3_Sum += (match['ascendPoints'] == 30) ? 1.0 : 0.0;
      }

      int count = matches.length;
      averagedData.add(
        _TeleOpData(team, h_c_Sum / count, l_c_Sum / count, h_b_Sum / count, l_b_Sum / count, net_Sum / count, A1_Sum / count, A2_Sum / count, A3_Sum / count, p_oz_Sum / count)
         );
    });

    averagedData.sort((a, b) {
      double aTotal = a.part1 + a.part2 + a.part3 + a.part4 + a.part5 + a.part6 + a.part7 + a.part8 + a.part9;
      double bTotal = b.part1 + b.part2 + b.part3 + b.part4 + b.part5 + b.part6 + b.part7 + b.part8 + b.part9;
      return bTotal.compareTo(aTotal); // descending order
    });

    return averagedData;
  }

  Future<List<_AutoData>> fetchAutoChartData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('$division $matchType').get();
    final docs = querySnapshot.docs;

    Map<String, List<Map<String, dynamic>>> teamGrouped = {};

    for (var doc in docs) {
      final data = doc.data();
      final team = data['teamNumber'].toString();

      if (!teamGrouped.containsKey(team)) {
        teamGrouped[team] = [];
      }
      teamGrouped[team]!.add(data);
    }

    List<_AutoData> averagedData = [];

    teamGrouped.forEach((team, matches) {
      double h_b_Sum = 0;
      double l_b_Sum = 0;
      double net_Sum = 0;
      double h_c_Sum = 0;
      double l_c_Sum = 0;
      double p_oz_Sum = 0;
      double p_a_Sum = 0;

      for (var match in matches) {
        for (var action in match['autoSequence']) {
          switch (action) {
            case 'high basket':
              h_b_Sum += 1;
              break;
            case 'low basket':
              l_b_Sum += 1;
              break;
            case 'net zone':
              net_Sum += 1;
              break;
            case 'high chamber':
              h_c_Sum += 1;
              break;
            case 'low chamber':
              l_c_Sum += 1;
              break;
            case 'parked observation zone':
              p_oz_Sum += 1;
              break;
            case 'parked ascend zone':
              p_a_Sum += 1;
              break;
          }
        }
      }

      int count = matches.length;
      averagedData.add(
          _AutoData(team, h_c_Sum / count, l_c_Sum / count, h_b_Sum / count, l_b_Sum / count, net_Sum / count, p_oz_Sum / count,  p_a_Sum / count)
      );
    });

    averagedData.sort((a, b) {
      double aTotal = a.part1 + a.part2 + a.part3 + a.part4 + a.part5 + a.part6 + a.part7 ;
      double bTotal = b.part1 + b.part2 + b.part3 + b.part4 + b.part5 + b.part6 + b.part7;
      return bTotal.compareTo(aTotal); // descending order
    });

    return averagedData;
  }

  Future<List<_CyclesData>> fetchCyclesChartData() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('$division $matchType').get();
    final docs = querySnapshot.docs;

    Map<String, List<Map<String, dynamic>>> teamGrouped = {};

    for (var doc in docs) {
      final data = doc.data();
      final team = data['teamNumber'].toString();

      if (!teamGrouped.containsKey(team)) {
        teamGrouped[team] = [];
      }
      teamGrouped[team]!.add(data);
    }

    List<_CyclesData> averagedData = [];

    teamGrouped.forEach((team, matches) {
      double cycleSum = 0;

      for (var match in matches) {
        cycleSum += (match['totalCycles'] ?? 0).toDouble();
      }

      int count = matches.length;
      averagedData.add(
        _CyclesData(team, cycleSum / count),
      );
    });

    averagedData.sort((a, b) {
      double aTotal = a.part1 ;
      double bTotal = b.part1 ;
      return bTotal.compareTo(aTotal); // descending order
    });

    return averagedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Analyze Teams Data", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        toolbarHeight: 30,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      persistentFooterButtons: const [
        Center(
          child: Text(
            "💡 Tip: Swipe near the screen edges to scroll through charts",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        )
      ],
      body: RotatedBox(
        quarterTurns: 1,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children:[
            FutureBuilder<List<_BarData>>(
              future: fetchChartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final chartData = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
                  child: SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: buildChartCard('Total Score per team', chartData)
                  ),
                );
              },
            ),
            FutureBuilder<List<_AutoData>>(
              future: fetchAutoChartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final chartData = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.8,
                      child: buildAutoChartCard('Auto Score per team', chartData)
                  ),

                );
              },
            ),
            FutureBuilder<List<_TeleOpData>>(
              future: fetchTeleOpChartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final chartData = snapshot.data!;
                return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
                      child: SizedBox(
                          // width: MediaQuery.of(context).size.width * 0.8,
                          child: buildTeleOpChartCard('TeleOp Score per team', chartData)
                      ),

                );
              },
            ),
            FutureBuilder<List<_CyclesData>>(
              future: fetchCyclesChartData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data available"));
                }

                final chartData = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.8,
                      child: buildCyclesChartCard('Cycles per team', chartData)
                  ),

                );
              },
            ),
          ]
        ),
      ),
    );
  }

  Widget buildChartCard(String title, List<_BarData> data) {
    return RotatedBox(
      quarterTurns: -1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width - 100,
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: 90,
              ),
              primaryYAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                enableDoubleTapZooming: true,
                zoomMode: ZoomMode.xy,
              ),
              series: <CartesianSeries>[
                StackedColumnSeries<_BarData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part1,
                  color: Colors.orange,
                  name: 'Auto',
                ),
                StackedColumnSeries<_BarData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part2,
                  color: Colors.green,
                  name: 'TeleOp',
                ),
                StackedColumnSeries<_BarData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part3,
                  color: Colors.brown,
                  name: 'Ascend',
                ),
              ],
              legend: Legend(isVisible: true),
            ),
          ),
          Positioned(
            top: -17,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Cooper",
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTeleOpChartCard(String title, List<_TeleOpData> data) {
    return RotatedBox(
      quarterTurns: -1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width - 100,
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: 90,
              ),
              primaryYAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                enableDoubleTapZooming: true,
                zoomMode: ZoomMode.xy,
              ),
              series: <CartesianSeries>[
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part1,
                  color: Colors.orange[700],
                  name: 'High Chamber',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part2,
                  color: Colors.orange[200],
                  name: 'Low Chamber',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part3,
                  color: Colors.brown[900],
                  name: 'High Basket',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part4,
                  color: Colors.brown[500],
                  name: 'Low Basket',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part5,
                  color: Colors.brown[200],
                  name: 'Net Zone',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part6,
                  color: Colors.purple[800],
                  name: 'A1',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part7,
                  color: Colors.purple[400],
                  name: 'A2',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part8,
                  color: Colors.purple[200],
                  name: 'A3',
                ),
                StackedColumnSeries<_TeleOpData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part9,
                  color: Colors.pink,
                  name: 'Park O Zone',
                ),
              ],
              legend: Legend(isVisible: true),
            ),
          ),
          Positioned(
            top: -17,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Cooper",
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAutoChartCard(String title, List<_AutoData> data) {
    return RotatedBox(
      quarterTurns: -1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width - 100,
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: 90,
              ),
              primaryYAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                enableDoubleTapZooming: true,
                zoomMode: ZoomMode.xy,
              ),
              series: <CartesianSeries>[
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part1,
                  color: Colors.orange[700],
                  name: 'High Chamber',
                ),
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part2,
                  color: Colors.orange[200],
                  name: 'Low Chamber',
                ),
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part3,
                  color: Colors.brown[900],
                  name: 'High Basket',
                ),
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part4,
                  color: Colors.brown[500],
                  name: 'Low Basket',
                ),
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part5,
                  color: Colors.brown[200],
                  name: 'Net Zone',
                ),
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part6,
                  color: Colors.purple[800],
                  name: 'Park Ascend',
                ),
                StackedColumnSeries<_AutoData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part7,
                  color: Colors.purple[400],
                  name: 'Park O Zone',
                ),
              ],
              legend: Legend(isVisible: true),
            ),
          ),
          Positioned(
            top: -17,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Cooper",
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCyclesChartCard(String title, List<_CyclesData> data) {
    return RotatedBox(
      quarterTurns: -1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width - 100,
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelRotation: 90,
              ),
              primaryYAxis: NumericAxis(),
              tooltipBehavior: TooltipBehavior(enable: true),
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                enableDoubleTapZooming: true,
                zoomMode: ZoomMode.xy,
              ),
              series: <CartesianSeries>[
                StackedColumnSeries<_CyclesData, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.part1,
                  color: Colors.orange[700],
                  name: 'Cycles',
                ),
              ],
              legend: Legend(isVisible: true),
            ),
          ),
          Positioned(
            top: -17,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Cooper",
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}


class _BarData {
  final String label;
  final double part1;
  final double part2;
  final double part3;

  _BarData(this.label, this.part1, this.part2, this.part3);
}

class _TeleOpData{
  final String label;
  final double part1;
  final double part2;
  final double part3;
  final double part4;
  final double part5;
  final double part6;
  final double part7;
  final double part8;
  final double part9;

  _TeleOpData(this.label, this.part1, this.part2, this.part3, this.part4, this.part5, this.part6, this.part7, this.part8, this.part9);
}

class _AutoData{
  final String label;
  final double part1;
  final double part2;
  final double part3;
  final double part4;
  final double part5;
  final double part6;
  final double part7;

  _AutoData(this.label, this.part1, this.part2, this.part3, this.part4, this.part5, this.part6, this.part7);
}

class _CyclesData{
  final String label;
  final double part1;


  _CyclesData(this.label, this.part1);
}
