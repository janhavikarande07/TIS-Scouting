import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ftc_analyzer/team_divisionwise_data.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'IndividualTeam.dart';
import 'Match.dart';
import 'colors.dart';

class ChooseTeam extends StatefulWidget {
  const ChooseTeam({super.key});

  @override
  State<ChooseTeam> createState() => _ChooseTeamState();
}

class _ChooseTeamState extends State<ChooseTeam> {

  List<String> teamNumbers = Edison_Division
      .map((team) => team['team_number'].toString())
      .toList();

  String teamNumber = "";


  @override
  Widget build(BuildContext context) {
    // teamNumbers.add("12560");
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Text("Select Team Number : ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
            SizedBox(height: 50,),
            DropdownSearch<String>(
              items: (f, cs) => teamNumbers,
              onChanged: (value) {
                print("Selected team: $value");
                setState(() {
                  teamNumber = value ?? "";
                });
                Navigator.push(context, MaterialPageRoute(builder: (context)=>IndividualTeam(teamNumber: teamNumber,)));
              },
              popupProps: PopupProps.menu(
                showSearchBox: true,
                fit: FlexFit.loose,
                menuProps: MenuProps(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}