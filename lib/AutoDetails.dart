import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validation_textformfield/validation_textformfield.dart';

class AutoDetails extends StatefulWidget {

  final String teamNumber;
  final Map<String, dynamic> data;
  const AutoDetails({Key? key, required this.teamNumber, required this.data}) : super(key: key);

  @override
  State<AutoDetails> createState() => _AutoDetailsState();
}

class _AutoDetailsState extends State<AutoDetails> {
  int? selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    selectedIndex = (int.tryParse(widget.data['autoPosition']) ?? 0) - 1;
    return Scaffold(
      appBar: AppBar(
        title: Text("Team ${widget.teamNumber}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 0,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Divider(color: themeColor, thickness: 2,),
              ),
              SizedBox(height: 10,),
              Text("Alliance: ${widget.data['side']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              SizedBox(height: 10,),
              Text("Auto Score: ${widget.data['autoScore']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Divider(color: themeColor, thickness: 2,),
              ),
              SizedBox(height: 20,),
              Text("Auto Sequence:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              SizedBox(height: 10,),
              Text((widget.data["autoSequence"] as List<dynamic>?)
                  ?.join("   -->   ") ?? "No sequence", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Divider(color: themeColor, thickness: 2,),
              ),
              SizedBox(height: 20,),
              Text("Preload: ${widget.data['preload']}", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Divider(color: themeColor, thickness: 2,),
              ),
              SizedBox(height: 20,),
              Text("Preload Position:", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              SizedBox(height: 10,),
              Stack(
                children: [
                  (widget.data['side'] == "red") ?
                  Image.asset('assets/red_side.png', width: 300, height: 400,) :
                  Image.asset('assets/blue_side.png', width: 300, height: 400,),
                  Positioned(
                    top: 68,
                    left: 35,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        position_btns("1", 0),
                        SizedBox(height: 3,),
                        position_btns("2", 1),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 135,
                    left: 35,
                    child: Column(
                      children: [
                        position_btns("3", 2),
                        SizedBox(height: 3,),
                        position_btns("4", 3),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 202,
                    left: 35,
                    child: Column(
                      children: [
                        position_btns("5", 4),
                        SizedBox(height: 3,),
                        position_btns("6", 5),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 272,
                    left: 35,
                    child: Column(
                      children: [
                        position_btns("7", 6),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      )
    );
  }

  Widget position_btns(text, index){
    bool shouldHide = selectedIndex != null && selectedIndex != index;

    return Visibility(
      visible: !shouldHide,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: ElevatedButton(
        onPressed: () async {
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 5),
          minimumSize: Size(30,20), // optional: remove default minimum height
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Colors.blue,
          // elevation: 5,
        ),
        child: Text(text,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: "Cooper",
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
  
}