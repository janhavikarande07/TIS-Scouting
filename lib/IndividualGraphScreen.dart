import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validation_textformfield/validation_textformfield.dart';

class IndividualGraphScreen extends StatefulWidget {

  final String teamNumber;
  final List<Map<String, dynamic>> data;
  final String task;
  const IndividualGraphScreen({Key? key, required this.teamNumber, required this.data, required this.task}) : super(key: key);

  @override
  State<IndividualGraphScreen> createState() => _IndividualGraphScreenState();
}

class _IndividualGraphScreenState extends State<IndividualGraphScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  Future<List<_BarData>> fetchChartData() async {
    return widget.data.map((match) {
      return _BarData(
        match['matchNumber'].toString(),
        (match['autoScore'] ?? 0).toDouble(),
        (match['teleopScore'] ?? 0).toDouble(),
        (match['ascendPoints'] ?? 0).toDouble(),
      );
    }).toList();
  }

  Future<List<_TeleOpData>> fetchTeleOpChartData() async {
    return widget.data.map((match) {
      return _TeleOpData(
        match['matchNumber'].toString(),
        (match['teleopSequence'][0] ?? 0).toDouble(),
        (match['teleopSequence'][1] ?? 0).toDouble(),
        (match['teleopSequence'][4] ?? 0).toDouble(),
        (match['teleopSequence'][5] ?? 0).toDouble(),
        (match['teleopSequence'][6] ?? 0).toDouble(),
        (match['ascendPoints'] == 3) ? 1.0 : 0.0,
        (match['ascendPoints'] == 15) ? 1.0 : 0.0,
        (match['ascendPoints'] == 30) ? 1.0 : 0.0,
        (match['teleopSequence'][3] ?? 0).toDouble(),
      );
    }).toList();
  }

  Future<List<_AutoData>> fetchAutoChartData() async {
    return widget.data.map((match) {
      double h_b_Sum = 0;
      double l_b_Sum = 0;
      double net_Sum = 0;
      double h_c_Sum = 0;
      double l_c_Sum = 0;
      double p_oz_Sum = 0;
      double p_a_Sum = 0;
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
      return _AutoData(
        match['matchNumber'].toString(),
        (h_c_Sum ?? 0).toDouble(),
        (l_c_Sum ?? 0).toDouble(),
        (h_b_Sum ?? 0).toDouble(),
        (l_b_Sum ?? 0).toDouble(),
        (net_Sum ?? 0).toDouble(),
        (p_oz_Sum ?? 0).toDouble(),
        (p_a_Sum ?? 0).toDouble(),
      );
    }).toList();
  }

  Future<List<_CyclesData>> fetchCyclesChartData() async {
    return widget.data.map((match) {
      return _CyclesData(
        match['matchNumber'].toString(),
        (match['totalCycles'] ?? 0).toDouble(),
      );
    }).toList();
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
              if(widget.task == "total")
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
              if(widget.task == "teleop")
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
              if(widget.task == "auto")
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
              if(widget.task == "cycle")
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
              primaryXAxis: CategoryAxis(),
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
              primaryXAxis: CategoryAxis(),
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
              primaryXAxis: CategoryAxis(),
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
              primaryXAxis: CategoryAxis(),
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
