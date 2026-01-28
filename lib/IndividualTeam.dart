import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ftc_analyzer/AutoDetails.dart';
import 'package:ftc_analyzer/IndividualGraphScreen.dart';
import 'package:ftc_analyzer/team_divisionwise_data.dart';
import 'package:ftc_analyzer/values_.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Match.dart';
import 'colors.dart';

class IndividualTeam extends StatefulWidget {

  final String teamNumber;
  const IndividualTeam({Key? key, required this.teamNumber}) : super(key: key);

  @override
  State<IndividualTeam> createState() => _IndividualTeamState();
}

class _IndividualTeamState extends State<IndividualTeam> {

  late Future<List<Map<String, dynamic>>> teamMatchesFuture;

  @override
  void initState() {
    super.initState();
    teamMatchesFuture = fetchTeamMatches(widget.teamNumber);
  }

  Future<List<Map<String, dynamic>>> fetchTeamMatches(String teamNumber) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('$division $matchType')
        .where('teamNumber', isEqualTo: teamNumber)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<_BarData>?> fetchChartData(List<Map<String, dynamic>>? data) async {
    if (data == null) return [];
    // Create the list of _BarData objects
    List<_BarData> barDataList = data.map((match) {
      return _BarData(
        match['matchNumber'].toString(),
        (match['autoScore'] ?? 0).toDouble(),
        (match['teleopScore'] ?? 0).toDouble(),
        (match['ascendPoints'] ?? 0).toDouble(),
      );
    }).toList();

    // Sort the list by matchNumber in ascending order
    barDataList.sort((a, b) => a.label.compareTo(b.label));

    return barDataList;
  }


  Future<List<_TeleOpData>> fetchTeleOpChartData(List<Map<String, dynamic>>? data) async {
    if (data == null) return [];

    List<_TeleOpData> barDataList = data.map((match) {
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

    // Sort the list by matchNumber in ascending order
    barDataList.sort((a, b) => a.label.compareTo(b.label));

    return barDataList;
  }

  Future<List<_AutoData>> fetchAutoChartData(List<Map<String, dynamic>>? data) async {
    if (data == null) return [];

    List<_AutoData> barDataList = data.map((match) {
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

    // Sort the list by matchNumber in ascending order
    barDataList.sort((a, b) => a.label.compareTo(b.label));

    return barDataList;
  }

  Future<List<_CyclesData>> fetchCyclesChartData(List<Map<String, dynamic>>? data) async {
    if (data == null) return [];

    List<_CyclesData> barDataList = data.map((match) {
      return _CyclesData(
        match['matchNumber'].toString(),
        (match['totalCycles'] ?? 0).toDouble(),
      );
    }).toList();

    // Sort the list by matchNumber in ascending order
    barDataList.sort((a, b) => a.label.compareTo(b.label));

    return barDataList;
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Team ${widget.teamNumber}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
      centerTitle: true,
     ),
     body: FutureBuilder<List<Map<String, dynamic>>>(
      future: teamMatchesFuture,  // Wait for match data to load
      builder: (context, snapshot_) {
        if (snapshot_.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
        } else if (snapshot_.hasError) {
        return Center(child: Text("Error: ${snapshot_.error}"));
        } else if (snapshot_.hasData) {
          var team = Edison_Division.firstWhere(
                (team) => team['team_number'] == widget.teamNumber,
            orElse: () => {}, // Return an empty map if not found
          );
       return SingleChildScrollView(
         child: Container(
           padding: EdgeInsets.symmetric(horizontal: 20),
           child: Column(
             children: [
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 30),
                 child: Divider(color: themeColor, thickness: 2,),
               ),
               SizedBox(height: 20,),
               Text(team["team_name"].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
               Text(team["from"].toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
               SizedBox(height: 20,),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 30),
                 child: Divider(color: themeColor, thickness: 2,),
               ),
               SizedBox(height: 10,),
               Container(
                 child: FutureBuilder<List<_BarData>?>(
                   future: fetchChartData(snapshot_.data),
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
               ),
               FutureBuilder<List<_AutoData>?>(
                 future: fetchAutoChartData(snapshot_.data),
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
               FutureBuilder<List<_TeleOpData>?>(
                 future: fetchTeleOpChartData(snapshot_.data),
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
               FutureBuilder<List<_CyclesData>?>(
                 future: fetchCyclesChartData(snapshot_.data),
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
               SizedBox(height: 20,),
               Padding(
                 padding: EdgeInsets.symmetric(horizontal: 30),
                 child: Divider(color: themeColor, thickness: 2,),
               ),
               SizedBox(height: 20,),
               SingleChildScrollView(
                 scrollDirection: Axis.horizontal,
                 child: Table(
                   border: TableBorder.all(color: Colors.black, width: 2),
                   defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                   columnWidths: const {
                     0: FixedColumnWidth(120),
                     1: FixedColumnWidth(120),
                     2: FixedColumnWidth(120),
                     3: FixedColumnWidth(120),
                     4: FixedColumnWidth(120),
                     5: FixedColumnWidth(100),
                     6: FixedColumnWidth(100),
                     7: FixedColumnWidth(100),
                     8: FixedColumnWidth(100),
                     9: FixedColumnWidth(160),
                   },
                   children: [
                     TableRow(
                       decoration: BoxDecoration(color: themeColor),
                       children: [
                         tableCell('Match No'),
                         tableCell('Score'),
                         tableCell('TeleOp Details'),
                         tableCell('Auto Details'),
                         tableCell('Robot Strategy'),
                         tableCell('Penalties'),
                         tableCell('Descored'),
                         tableCell('Driver ratings'),
                         tableCell('Scouter'),
                         tableCell('Comments'),
                       ],
                     ),
                     ...?snapshot_.data?.map((entry) {
                       if (entry["autoSequence"].any((e) => e.toString().contains("park"))) {
                         print("auto_ ${entry['autoScore']}");
                         entry['autoScore']-=3;
                         print("auto_ ${entry['autoScore']}");
                       }
                       return TableRow(
                         // decoration: BoxDecoration(
                         //   color: (entry["side"] == "red")? Colors.redAccent: Colors.blueAccent,
                         // ),
                         children: [
                           tableCell("${entry['matchType']}  ${entry['matchNumber']} \n${entry['side'].toString().capitalize()} Alliance"),
                           tableCell("TeleOp : ${entry['teleopScore']} \nAuto : ${entry['autoScore']} \nAscend : ${entry['ascendPoints']}"),
                           tableCell("Specimen: ${entry['teleopSequence'][7]}  \nSample: ${entry['teleopSequence'][8]} \nCycles: ${entry['totalCycles']}"),
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: ElevatedButton(
                               onPressed: () async {
                                 Navigator.push(context, MaterialPageRoute(builder: (context)=>AutoDetails(teamNumber: widget.teamNumber, data: entry)));
                               },
                               style: ElevatedButton.styleFrom(
                                 backgroundColor: themeColor,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10),
                                 ),
                                 padding: const EdgeInsets.symmetric(vertical: 7),
                                 minimumSize: const Size(70, 30),
                                 // textStyle: TextStyle(fontSize: 14),
                                 shadowColor: Colors.blue,
                                 elevation: 5,
                               ),
                               child: Text("Details",
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 18,
                                   fontFamily: "Cooper",
                                   fontStyle: FontStyle.normal,
                                   fontWeight: FontWeight.w900,
                                 ),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                           ),
                           tableCell("${entry['robotPreference']}"),
                           tableCell("${entry['majorPenalty'] ? "Major" : ""} \n${entry['minorPenalty'] ? "Minor" : ""}"),
                           tableCell(entry['descored'].toString()),
                           tableCell(entry['driverRatings'].toString()),
                           tableCell(entry['scouterName'].toString()),
                           tableCell("Preload: ${entry['preloadComments']}  \n\nAuto:${entry['autoComments']} \n\nTeleOp${entry['teleopComments']} \n\nOther:${entry['endComments']} "),
                         ],
                       );
                     }).toList(),
                   ],
                 ),
               ),
               SizedBox(height: 30,),
             ],
           ),
         ),
       );
        } else {
        return Center(child: Text("No data available"));
        }
      },
     ),
   );
  }

  Widget tableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(child: Text(text.capitalize(), style: TextStyle(fontSize: 16), textAlign: TextAlign.center,)),
    );
  }
  Widget buildChartCard(String title, List<_BarData> data) {
    return Stack(
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
    );
  }

  Widget buildTeleOpChartCard(String title, List<_TeleOpData> data) {
    return Stack(
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
    );
  }

  Widget buildAutoChartCard(String title, List<_AutoData> data) {
    return Stack(
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
    );
  }

  Widget buildCyclesChartCard(String title, List<_CyclesData> data) {
    return Stack(
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
