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

class EditDaata extends StatefulWidget {
  final String teamNumber;
  final String matchNumber;

  const EditDaata({Key? key, required this.teamNumber, required this.matchNumber}) : super(key: key);

  @override
  State<EditDaata> createState() => _EditDaataState();
}

class _EditDaataState extends State<EditDaata> {

  late var data = {};

  @override
  void initState() {
    super.initState();
    // Force portrait mode when this screen opens
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Restore landscape mode when this screen is closed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  Future<Map<String, dynamic>?> getTeamDataFromFirebase(String matchNumber, String teamNumber) async {
    final query = await FirebaseFirestore.instance
        .collection('$division $matchType')
        .where('matchNumber', isEqualTo: matchNumber)
        .where('teamNumber', isEqualTo: teamNumber)
        .get();

    if (query.docs.isNotEmpty) {
      setState(() {
        data = query.docs.first.data();
      });
       // return the first matching document
    } else {
      setState(() {
        data = {};
      }); // no matching document found
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Data')),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
