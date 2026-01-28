import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ftc_analyzer/colors.dart';
import 'package:ftc_analyzer/values_.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class FTCComparisonScreen extends StatefulWidget {
  @override
  _FTCComparisonScreenState createState() => _FTCComparisonScreenState();
}

class _FTCComparisonScreenState extends State<FTCComparisonScreen> {
  List<Map<String, dynamic>> apiMatches = [];
  Map<String, Map<String, dynamic>> firebaseMatchMap = {};

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchApiData();
    await fetchFirebaseData();
    setState(() {});
  }

  Future<void> fetchApiData() async {
    final username = 'jkarande';
    final authKey = ' A59B90E9-4A56-42F2-9A76-016347E8DF7D';
    final encoded = base64Encode(utf8.encode('$username:$authKey'));
    String eventCode = (division == "Edison") ? "FTCCMP1EDIS" : "FTCCMP1OCHO";
    print(eventCode);
    final url = Uri.parse('https://ftc-api.firstinspires.org/v2.0/2024/matches/$eventCode');

    final headers = {
      'Authorization': 'Basic $encoded',
      'Accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final allMatches = List<Map<String, dynamic>>.from(data['matches']);

      // Only include Qualification matches
      if(matchType == "finals") {
        apiMatches = allMatches
            .where((match) => match['tournamentLevel'] == 'PLAYOFF')
            .toList();
        print(apiMatches);
      }
      else{
        apiMatches = allMatches
            .where((match) => match['tournamentLevel'] == 'QUALIFICATION')
            .toList();
        print(apiMatches);
      }
    } else {
      print("API error: ${response.statusCode}");
    }
  }

  Future<void> fetchFirebaseData() async {
    final query = await FirebaseFirestore.instance.collection('$division $matchType').get();
    final docs = query.docs;

    for (var doc in docs) {
      final data = doc.data();
      String matchNumber = data['matchNumber'];
      String teamNumber = data['teamNumber'].toString();
      if (data["autoSequence"].any((e) => e.toString().contains("park"))) {
        data['autoScore']-=3;
      }
      int score = (data['autoScore'] ?? 0) + (data['teleopScore'] ?? 0) + (data['ascendPoints'] ?? 0);

      if (!firebaseMatchMap.containsKey(matchNumber)) {
        firebaseMatchMap[matchNumber] = {};
      }
      firebaseMatchMap[matchNumber]![teamNumber] = score;
    }
  }

  Future<Map<String, dynamic>?> getTeamDataFromFirebase(String matchNumber, String teamNumber) async {
    final query = await FirebaseFirestore.instance
        .collection('$division $matchType')
        .where('matchNumber', isEqualTo: matchNumber)
        .where('teamNumber', isEqualTo: teamNumber)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data(); // return the first matching document
    } else {
      return null; // no matching document found
    }
  }


  Future<void> deleteTeamData(String matchNumber, String teamNumber) async {
    final query = await FirebaseFirestore.instance
        .collection('$division $matchType')
        .where('matchNumber', isEqualTo: matchNumber)
        .where('teamNumber', isEqualTo: teamNumber)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }

    setState(() {
      firebaseMatchMap[matchNumber]?.remove(teamNumber);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleted Team $teamNumber from Match $matchNumber')),
    );
  }


  Widget buildTable() {
    List<TableRow> rows = [];

    for (var match in apiMatches) {
      final matchNumber = match['description'].toString().trim().split(" ").last;
      print("match number $matchNumber");
      final teams = match['teams'];
      final redTeams = teams.where((t) => t['station'].toString().toLowerCase().contains('red')).toList();
      final blueTeams = teams.where((t) => t['station'].toString().toLowerCase().contains('blue')).toList();

      if (!firebaseMatchMap.containsKey(matchNumber)) continue;

      final fbTeams = firebaseMatchMap[matchNumber]!;

      final red1 = redTeams[0]['teamNumber'].toString();
      final red2 = redTeams[1]['teamNumber'].toString();
      final blue1 = blueTeams[0]['teamNumber'].toString();
      final blue2 = blueTeams[1]['teamNumber'].toString();

      int fbRed1 = fbTeams[red1] ?? 0;
      int fbRed2 = fbTeams[red2] ?? 0;
      int fbRedTotal = fbRed1 + fbRed2;

      int fbBlue1 = fbTeams[blue1] ?? 0;
      int fbBlue2 = fbTeams[blue2] ?? 0;
      int fbBlueTotal = fbBlue1 + fbBlue2;

      int apiRedTotal = match['scoreRedFinal'] ?? 0;
      int apiBlueTotal = match['scoreBlueFinal'] ?? 0;

      Color? redRowColor;
      int redDiff = (fbRedTotal - apiRedTotal).abs();
      if (redDiff > 10) {
        redRowColor = Colors.red[100];
      } else if (redDiff > 0) {
        redRowColor = Colors.yellow[100];
      }

      Color? blueRowColor;
      int blueDiff = (fbBlueTotal - apiBlueTotal).abs();
      if (blueDiff > 10) {
        blueRowColor = Colors.red[100];
      } else if (blueDiff >= 5) {
        blueRowColor = Colors.yellow[100];
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(color: lightThemeColor),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Match $matchNumber", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SizedBox(),
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
        ),
      );

      // Row for RED teams
      rows.add(
        TableRow(
          decoration: BoxDecoration(color: redRowColor),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Red \n[$red1 , $red2]"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$fbRed1 + $fbRed2"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$fbRedTotal"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$apiRedTotal"),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  _buildDeleteButton(matchNumber, red1, label: "🗑 R1"),
                  _buildDeleteButton(matchNumber, red2, label: "🗑 R2"),
                ],
              ),
            ),
          ],
        ),
      );

      // Row for BLUE teams
      rows.add(
        TableRow(
          decoration: BoxDecoration(color: blueRowColor),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Blue \n[$blue1 , $blue2]"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$fbBlue1 + $fbBlue2"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$fbBlueTotal"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("$apiBlueTotal"),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  _buildDeleteButton(matchNumber, blue1, label: "🗑 B1"),
                  _buildDeleteButton(matchNumber, blue2, label: "🗑 B2"),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Table(
      border: TableBorder.all(color: Colors.black12),
      columnWidths: {
        0: FlexColumnWidth(100),
        1: FlexColumnWidth(70),
        2: FlexColumnWidth(70),
        3: FixedColumnWidth(70),
        4: FlexColumnWidth(70),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(color: themeColor),
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text("Team", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Individual Score", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Total Score", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("API Score", style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: EdgeInsets.all(8), child: Text("Update", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        ...rows,
      ],
    );
  }

  Widget _buildDeleteButton(String matchNumber, String teamNumber, {required String label}) {
    return TextButton(
      child: Text(label, style: TextStyle(color: Colors.black)),
      onPressed: () async {
        // Delete team data from Firebase
        await deleteTeamData(matchNumber, teamNumber);
      },
    );
  }

  Widget _buildUpdateButton(String matchNumber, String teamNumber, {required String label}) {
    return TextButton(
      child: Text(label, style: TextStyle(color: Colors.blue)),
      onPressed: () async {
        dynamic data = await getTeamDataFromFirebase(matchNumber, teamNumber);
        int updatedScore = 0;
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 320, // narrower width to simulate portrait mode
                height: 500, // taller height to simulate portrait aspect
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Update Score for $teamNumber", style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              iconSize: 32,
                              onPressed: () {
                                if (updatedScore > 0) {
                                  setState(() => updatedScore--);
                                }
                              },
                            ),
                            SizedBox(width: 20),
                            Text(
                              updatedScore.toString(),
                              style: TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              iconSize: 32,
                              onPressed: () {
                                setState(() => updatedScore++);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final query = await FirebaseFirestore.instance
                                    .collection('$division $matchType')
                                    .where(
                                    'matchNumber', isEqualTo: matchNumber)
                                    .where('teamNumber', isEqualTo: teamNumber)
                                    .get();

                                for (var doc in query.docs) {
                                  await doc.reference.update(
                                      {'manualScore': updatedScore});
                                }

                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      "Updated score for $teamNumber")),
                                );
                              },
                              child: Text("Save"),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            );
          },
        );
      }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Match Comparison')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: apiMatches.isEmpty || firebaseMatchMap.isEmpty
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: buildTable(),
        ),
      ),
    );
  }
}
