import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ftc_analyzer/GraphsScreen.dart';
import 'package:ftc_analyzer/Scan_QR.dart';
import 'package:hive/hive.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'ChooseTeams.dart';
import 'ScoreVerify.dart';
import 'colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validation_textformfield/validation_textformfield.dart';

class Home extends StatefulWidget {
  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Scan_QR()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 7),
                minimumSize: const Size(100, 20),
                // textStyle: TextStyle(fontSize: 14),
                shadowColor: Colors.blue,
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Scan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 5),
                  Image.asset("assets/qr_code.png", width: 15,)
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GraphScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 7),
                minimumSize: const Size(200, 30),
                // textStyle: TextStyle(fontSize: 14),
                shadowColor: Colors.blue,
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Analyze All Teams Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 5),
                  Icon(FontAwesomeIcons.chartSimple, color: Colors.black,)
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseTeam()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 7),
                minimumSize: const Size(200, 30),
                // textStyle: TextStyle(fontSize: 14),
                shadowColor: Colors.blue,
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Analyze Individual Team Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 5),
                  Icon(FontAwesomeIcons.chartSimple, color: Colors.black,)
                ],
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>FTCComparisonScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 7),
                minimumSize: const Size(200, 30),
                // textStyle: TextStyle(fontSize: 14),
                shadowColor: Colors.blue,
                elevation: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Verify and Edit Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 5),
                  Icon(FontAwesomeIcons.chartSimple, color: Colors.black,)
                ],
              ),
            ),
            SizedBox(height: 30,)
          ],
        ),
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