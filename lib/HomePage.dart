import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:tis_ftc/Qualification_Matches.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:tis_ftc/pre_load.dart';
import 'package:tis_ftc/values_.dart';

import 'colors.dart';
import 'history.dart';
import 'team_divisionwise_data.dart';

class Home extends StatefulWidget{

  final String division;
  const Home({Key? key, required this.division}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {

  TextEditingController matchController = TextEditingController();
  String matchNumber = "";
  String matchType = "";
  Map<String, dynamic> teams = {};
  String side = "";
  String team_number = "";
  List<String> teamNumbers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: ElevatedButton(
              onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));
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
              child: const Text("History 📋",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Cooper",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body : SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40,),
              Text("Match Type", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  match_btns('P', "practice"),
                  match_btns('Q', "qualification"),
                  match_btns('F', "finals"),
                ]
              ),
              SizedBox(height: 50,),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: TextFormField(
                  controller: matchController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: ' Match Number ',
                    labelStyle: TextStyle(
                      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: themeColor),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              SizedBox(height: 50),
              if(teamNumbers.isEmpty)...[
              ElevatedButton(
                onPressed: () async {
                  if(matchType.isEmpty){
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Data Missing',
                        message: 'Please enter all details ',
                        contentType: ContentType.warning,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                  else{
                    print("fdtgh");
                    setState(() {
                      matchNumber = matchController.text.toString();
                      if(widget.division == "Edison"){
                        teamNumbers.addAll(Edison_Division
                            .map((team) => team['team_number'].toString())
                            .toList());
                      }
                      else{
                        teamNumbers.addAll(Ochoa_Division
                            .map((team) => team['team_number'].toString())
                            .toList());
                      }
                      print(teamNumbers);
                    });
                    // if(division == "Edison"){
                    //   matchNumber = matchController.text.toString();
                    //   setState(() {
                    //     teams = EdisonQualifictaion[matchNumber] ?? {};
                    //   });
                    // }
                    // else{
                    //   matchNumber = matchController.text.toString();
                    //   setState(() {
                    //     teams = OchoaQualification[matchNumber] ?? {};
                    //   });
                    // }
                    // });
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  minimumSize: const Size(150, 40),
                  // textStyle: TextStyle(fontSize: 14),
                  shadowColor: Colors.blue,
                  elevation: 5,
                ),
                child: const Text("Submit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
              if(teamNumbers.isNotEmpty)...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(thickness: 3, color: Colors.lightBlueAccent,),
                ),
                SizedBox(height: 20,),
                Text("Select Team Number", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Column(
                    //   children: [
                    //     team_btns(teams["red"][0].toString(), Colors.redAccent),
                    //     SizedBox(height: 30),
                    //     team_btns(teams["red"][1].toString(), Colors.redAccent)
                    //   ],
                    // ),
                    // Column(
                    //   children: [
                    //     team_btns(teams["blue"][0].toString(), Colors.blueAccent),
                    //     SizedBox(height: 30),
                    //     team_btns(teams["blue"][1].toString(), Colors.blueAccent)
                    //   ],
                    // ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownSearch<String>(
                            items: (f, cs) => teamNumbers,
                            onChanged: (value) {
                              print("Selected team: $value");
                              setState(() {
                                side = "red";
                                team_number = value!;
                              });
                            },
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                              textAlign: TextAlign.center,
                              baseStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
                            ),
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
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownSearch<String>(
                            items: (f, cs) => teamNumbers,
                            onChanged: (value) {
                              print("Selected team: $value");
                              setState(() {
                                side = "red";
                                team_number = value!;
                              });
                            },
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                baseStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
                            ),
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
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownSearch<String>(
                            items: (f, cs) => teamNumbers,
                            onChanged: (value) {
                              print("Selected team: $value");
                              setState(() {
                                side = "blue";
                                team_number = value!;
                              });
                            },
                            decoratorProps: DropDownDecoratorProps(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                baseStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
                            ),
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
                        ),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[700],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: DropdownSearch<String>(
                            items: (f, cs) => teamNumbers,
                            onChanged: (value) {
                              print("Selected team: $value");
                              setState(() {
                                side = "blue";
                                team_number = value!;
                              });
                            },
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                                textAlign: TextAlign.center,
                                baseStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)
                            ),
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
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 50,),
                ElevatedButton(
                  onPressed: () async {
                    if(side.isEmpty || team_number.isEmpty){
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Data Missing',
                          message: 'Please enter all details ',
                          contentType: ContentType.warning,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                    else{
                      print("fdtgh");
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PreLoad(matchDetails: {
                        "matchType" : matchType,
                        "matchNumber" : matchNumber,
                        "teamNumber" : team_number,
                        "side" : side,
                      },)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    minimumSize: const Size(150, 40),
                    // textStyle: TextStyle(fontSize: 14),
                    shadowColor: Colors.blue,
                    elevation: 5,
                  ),
                  child: const Text("Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget match_btns(text, value){
    bool isSelected = matchType == value;

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          matchType= value;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : themeColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        // minimumSize: const Size(double.infinity, 50),
        // textStyle: TextStyle(fontSize: 14),
        shadowColor: Colors.blue,
        elevation: 5,
      ),
      child: Text(text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontFamily: "Cooper",
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget team_btns(text, color){
    bool isSelected = team_number == text && side == ((color == Colors.redAccent) ? "red" : "blue");

    return ElevatedButton(
      onPressed: () async {
        setState(() {
          side = (color == Colors.redAccent)? "red" : "blue";
          team_number = text;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.green : color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        minimumSize: const Size(100, 50),
        // textStyle: TextStyle(fontSize: 14),
        shadowColor: Colors.blue,
        elevation: 5,
      ),
      child: Text(text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontFamily: "Cooper",
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// child: QrImageView(
//   data: message,
//   version: QrVersions.auto,
//   ),