import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:hive/hive.dart';
import 'package:tis_ftc/HomePage.dart';
import 'package:tis_ftc/values_.dart';

import 'colors.dart';
import 'Match.dart';

class End extends StatefulWidget{

  final Map<String, dynamic> matchDetails;
  const End({Key? key, required this.matchDetails}) : super(key: key);

  @override
  State<End> createState() => EndState();
}

class EndState extends State<End> {

  String ascendOption = "";
  String robotOption = "";
  String foulOption = "";
  double rating = 0.0;
  int score = 0;
  int penalty = 0;
  String penalty_type = "";
  String dOption = "";
  bool descored = false;
  bool show = false;
  bool isMinorPenaltyChecked = false;
  bool isMajorPenaltyChecked = false;
  bool isMaybePenaltyChecked = false;
  TextEditingController penaltyScoreController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  Box<Match> box = Hive.box<Match>('Match');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: TextFormField(
                  controller:  nameController,
                  decoration: const InputDecoration(
                    labelText: ' Scouter Name ',
                    labelStyle: TextStyle(
                      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              Text("Ascend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
              SizedBox(height: 10,),
              Wrap(
                spacing: 40,
                children: ['A1', 'A2', 'A3', 'Tried', 'Failed', "NA (Parked)"].map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: ascendOption,
                        onChanged: (value) {
                          setState(() {
                            ascendOption = value!;
                            print(ascendOption);
                          });
                        },
                      ),
                      Text(option),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              Text("Robot", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
              SizedBox(height: 10,),
              Wrap(
                spacing: 40,
                children: ['Scoring', 'Defense', 'Both', 'Potato'].map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: robotOption,
                        onChanged: (value) {
                          setState(() {
                            robotOption = value!;
                            print(robotOption);
                          });
                        },
                      ),
                      Text(option),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Rate driver", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
                  SizedBox(width: 20,),
                  StarRating(
                    size: 30,
                    rating: rating,
                    color: Colors.yellow,
                    borderColor: Colors.grey,
                    allowHalfRating: false,
                    starCount: 5,
                    onRatingChanged: (rating) => setState(() {
                      this.rating = rating;
                    }),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Penalty scored?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                  SizedBox(width: 30,),
                  Wrap(
                    spacing: 20,
                    children: ['yes', 'no'].map((option) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: option,
                            groupValue: foulOption,
                            onChanged: (value) {
                              setState(() {
                                foulOption = value!;
                                penalty_type = foulOption;
                                if(foulOption == "yes") {
                                  show = true;
                                }
                              });
                            },
                          ),
                          Text(option),
                        ],
                      );
                    }).toList(),
                  )
                ],
              ),
              if (show)
                Container(
                  margin: EdgeInsets.only(top: 20),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Penalty Type',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                      // Minor Penalty Checkbox
                      CheckboxListTile(
                        title: Text('Minor', style: TextStyle(fontSize: 16)),
                        value: isMinorPenaltyChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isMinorPenaltyChecked = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      // Major Penalty Checkbox
                      CheckboxListTile(
                        title: Text('Major', style: TextStyle(fontSize: 16)),
                        value: isMajorPenaltyChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isMajorPenaltyChecked = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      CheckboxListTile(
                        title: Text('Maybe', style: TextStyle(fontSize: 16)),
                        value: isMaybePenaltyChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isMaybePenaltyChecked = value!;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SizedBox(height: 15),
                      // Penalty Score Input (only show when any penalty is selected)
                      if (isMinorPenaltyChecked || isMajorPenaltyChecked)
                        TextFormField(
                          controller: penaltyScoreController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Penalty Points',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        ),
                    ],
                  ),
                ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text("Robot Descored?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),),
                  SizedBox(width: 30,),
                  Wrap(
                    spacing: 20,
                    children: ['yes', 'no'].map((option) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: option,
                            groupValue: dOption,
                            onChanged: (value) {
                              setState(() {
                                dOption = value!;
                                if(dOption=="yes"){
                                  descored = true;
                                }
                                else{
                                  descored = false;
                                }
                              });
                            },
                          ),
                          Text(option),
                        ],
                      );
                    }).toList(),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width - 100,
                child: TextFormField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    labelText: ' Comments ',
                    labelStyle: TextStyle(
                      color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.black,),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Divider(color: themeColor,),
              ),
              SizedBox(height: 10,),
              SizedBox(height: 10,),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if(nameController.text.isEmpty || ascendOption.isEmpty || robotOption.isEmpty || foulOption.isEmpty || rating == 0){
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
                    else {
                      if (ascendOption == "A1") {
                        score = 3;
                      }
                      else if (ascendOption == "A2") {
                        score = 15;
                      }
                      else if (ascendOption == "A3") {
                        score = 30;
                      }
                      if (penaltyScoreController.text.isNotEmpty) {
                        penalty = int.tryParse(penaltyScoreController.text) ?? 0;
                      }
                      print(widget.matchDetails);
                      int total = 0;
                      if(widget.matchDetails["autoSequence"].contains("park")){
                         total = ((widget.matchDetails["autoScore"] - 3) * 2) + 3 +
                            widget.matchDetails["teleopScore"] + score;
                        print(total);
                        widget.matchDetails["autoScore"] = (widget.matchDetails["autoScore"] - 3) * 2 + 3;
                      }
                      else {
                        total = (widget.matchDetails["autoScore"] * 2) +
                            widget.matchDetails["teleopScore"] + score;
                        print(total);
                        widget.matchDetails["autoScore"] = (widget.matchDetails["autoScore"]) * 2 ;
                      }
                      widget.matchDetails.addAll({
                        "endComments": commentController.text,
                        "totalScore": total,
                        "minorPenalty": isMinorPenaltyChecked,
                        "majorPenalty": isMajorPenaltyChecked,
                        "ascendPoints": score,
                        "robotPreference": robotOption,
                        "driverRatings": rating.toString(),
                        "scouterName": nameController.text,
                        "descored": descored
                      });
                      print(widget.matchDetails);

                      box.add(
                          Match(
                            matchType: widget.matchDetails['matchType'],
                            matchNumber: widget.matchDetails['matchNumber'],
                            teamNumber: widget.matchDetails['teamNumber'],
                            side: widget.matchDetails['side'],
                            autoPosition: widget.matchDetails['autoPosition'],
                            preload: widget.matchDetails['preload'],
                            preloadComments: widget.matchDetails['preload_comments'] ?? "",
                            autoScore: widget.matchDetails['autoScore'] ?? 0,
                            autoParking: widget.matchDetails['autoParking'] == false,
                            autoSequence: widget.matchDetails['autoSequence'] ?? [],
                            autoComments: widget.matchDetails['autoComments'] ?? "",
                            teleopScore: widget.matchDetails['teleopScore'] ?? 0,
                            teleopSequence: widget.matchDetails['teleopSequence'] ?? [],
                            totalCycles: widget.matchDetails['totalCycles'] ?? 0,
                            teleopComments: widget.matchDetails['teleopComments'] ?? "",
                            endComments: widget.matchDetails['endComments'] ?? "",
                            totalScore: widget.matchDetails['totalScore'] ?? 0,
                            majorPenalty: widget.matchDetails['majorPenalty'] == 'true', // Assuming it's a string in Firebase
                            minorPenalty: widget.matchDetails['minorPenalty'] == 'true', // Assuming it's a string in Firebase
                            ascendPoints: widget.matchDetails['ascendPoints'] ?? 0,
                            robotPreference: widget.matchDetails['robotPreference'] ?? "",
                            scouterName: widget.matchDetails['scouterName'] ?? "",
                            driverRatings: widget.matchDetails['driverRatings'] ?? "",
                            descored: widget.matchDetails['descored'] ?? false
                        ),
                      );
                      print("box done");
                      List<Match> ModelList = box.values.toList();
                      for (var model in ModelList) {
                        print("model : ${model.totalScore} ${model.matchNumber}");
                      }

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home(division: division,)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    minimumSize: const Size(100, 30),
                    // textStyle: TextStyle(fontSize: 14),
                    shadowColor: Colors.blue,
                    elevation: 5,
                  ),
                  child: Text("Next Match",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
  
}