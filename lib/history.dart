import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:tis_ftc/Qualification_Matches.dart';
import 'package:tis_ftc/pre_load.dart';

import 'QRCode.dart';
import 'colors.dart';
import 'Match.dart';

class History extends StatefulWidget{
  @override
  State<History> createState() => HistoryState();
}

class HistoryState extends State<History> {

  Box<Match> box = Hive.box<Match>('Match');

  List<Widget> Tiles= [];
  List<Widget> FTiles = [];
  List<Widget> PTiles = [];

  Future<Box> _getQBox() async {
    return await box;
  }

  QRow() {
    List<Match> ModelList = box.values.toList();
    final qualificationMatches = ModelList.where((match) => match.matchType == 'qualification').toList();
    final finalMatches = ModelList.where((match) => match.matchType == 'finals').toList();
    final practiceMatches = ModelList.where((match) => match.matchType == 'Practice').toList();

    // List<dynamic> data = [];
    int index = 0;
    for (var model in qualificationMatches) {
      print(model);
      Tiles.insert(index,  GridTile(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  // color: lightThemeColor.withOpacity(0.1),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: themeColor),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Row(
                    children: [
                      Text(model.matchNumber),
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          Text(model.teamNumber),
                          SizedBox(height: 10,),
                          Text("${model.side.capitalize()} Alliance" ),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          Text("Auto Score : ${model.autoScore}"),
                          SizedBox(height: 10,),
                          Text("TeleOp Score : ${model.teleopScore}"),
                          SizedBox(height: 10,),
                          Text("Ascend Score : ${model.ascendPoints}"),
                          SizedBox(height: 10,),
                          Text("Total Score : ${model.totalScore}")
                        ],
                      )

                    ]
                )
            ),
          )
      )
      );
      index++;
    }
    return Tiles;
  }

  Future<Box> _getFBox() async {
    return await box;
  }

  FRow() {
    List<Match> ModelList = box.values.toList();
    final qualificationMatches = ModelList.where((match) => match.matchType == 'qualification').toList();
    final finalMatches = ModelList.where((match) => match.matchType == 'finals').toList();
    final practiceMatches = ModelList.where((match) => match.matchType == 'Practice').toList();

    // List<dynamic> data = [];
    int index = 0;
    for (var model in finalMatches) {
      print(model);
      FTiles.insert(index,  GridTile(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  // color: lightThemeColor.withOpacity(0.1),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: themeColor),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Row(
                    children: [
                      Text(model.matchNumber),
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          Text(model.teamNumber),
                          SizedBox(height: 10,),
                          Text("${model.side.capitalize()} Alliance" ),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          Text("Auto Score : ${model.autoScore}"),
                          SizedBox(height: 10,),
                          Text("TeleOp Score : ${model.teleopScore}"),
                          SizedBox(height: 10,),
                          Text("Ascend Score : ${model.ascendPoints}"),
                          SizedBox(height: 10,),
                          Text("Total Score : ${model.totalScore}")
                        ],
                      )

                    ]
                )
            ),
          )
      )
      );
      index++;
    }
    return FTiles;
  }

  Future<Box> _getPBox() async {
    return await box;
  }

  PRow() {
    List<Match> ModelList = box.values.toList();
    final qualificationMatches = ModelList.where((match) => match.matchType == 'qualification').toList();
    final finalMatches = ModelList.where((match) => match.matchType == 'finals').toList();
    final practiceMatches = ModelList.where((match) => match.matchType == 'Practice').toList();

    // List<dynamic> data = [];
    int index = 0;
    for (var model in practiceMatches) {
      print(model);
      Tiles.insert(index,  GridTile(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  // color: lightThemeColor.withOpacity(0.1),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: themeColor),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.2),
                  //     spreadRadius: 2,
                  //     blurRadius: 5,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                ),
                child: Row(
                    children: [
                      Text(model.matchNumber),
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          Text(model.teamNumber),
                          SizedBox(height: 10,),
                          Text("${model.side.capitalize()} Alliance" ),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Column(
                        children: [
                          Text("Auto Score : ${model.autoScore}"),
                          SizedBox(height: 10,),
                          Text("TeleOp Score : ${model.teleopScore}"),
                          SizedBox(height: 10,),
                          Text("Ascend Score : ${model.ascendPoints}"),
                          SizedBox(height: 10,),
                          Text("Total Score : ${model.totalScore}")
                        ],
                      )

                    ]
                )
            ),
          )
      )
      );
      index++;
    }
    return Tiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History", style: TextStyle(fontWeight: FontWeight.w700,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> QRCode_()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  minimumSize: const Size(200, 20),
                  // textStyle: TextStyle(fontSize: 14),
                  shadowColor: Colors.blue,
                  elevation: 5,
                ),
                child: const Text("Generate QR Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: themeColor)
                ),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Practice", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                    SizedBox(height: 10,),
                    FutureBuilder<Box>(
                      future: _getPBox(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.hasError) {
                          return Center(child: Text('Error loading data.'));
                        }

                        final box_ = snapshot.data!;
                        final items = box_.values.toList();

                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                                children: <Widget>[...PRow()]
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: themeColor)
                ),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Qualifications", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                    SizedBox(height: 10,),
                    FutureBuilder<Box>(
                      future: _getQBox(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.hasError) {
                          return Center(child: Text('Error loading data.'));
                        }

                        final box_ = snapshot.data!;
                        final items = box_.values.toList();

                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                                children: <Widget>[...QRow()]
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: themeColor)
                ),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Finals", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                    SizedBox(height: 10,),
                    FutureBuilder<Box>(
                      future: _getFBox(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.hasError) {
                          return Center(child: Text('Error loading data.'));
                        }

                        final box_ = snapshot.data!;
                        final items = box_.values.toList();

                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Column(
                                children: <Widget>[...FRow()]
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
}