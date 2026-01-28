import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:tis_ftc/teleop.dart';

import 'colors.dart';

class Auto extends StatefulWidget{

  final Map<String, dynamic> matchDetails;
  const Auto({Key? key, required this.matchDetails}) : super(key: key);

  @override
  State<Auto> createState() => AutoState();
}

class AutoState extends State<Auto> {

  String auto_position = "";
  String preload = "";
  List<bool> isPressedList = List.generate(7, (_) => false);
  List<bool> isPressedPreloadList = List.generate(2, (_) => false);
  bool isSamplePicked = true;
  int score = 0;
  bool parking = false;
  List<String> autoSequence = ["preload"];
  String latestAction = "Preload loaded";
  bool showMessage = false;
  int specimenCount = 0;
  int sampleCount = 0;

  TextEditingController commentController = TextEditingController();

  void showTemporaryMessage(String message) {
    setState(() {
      latestAction = message;
      showMessage = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showMessage = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auto", style: TextStyle(fontWeight: FontWeight.w700),),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 3),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Sample \n $sampleCount", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16), textAlign: TextAlign.center,),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 3),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text("Specimen \n $specimenCount", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16), textAlign: TextAlign.center,),
                  ),
                  SizedBox(width: 20,),
                ],
              ),
              SizedBox(height: 20,),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Stack(
                  children: [
                    // The image
                    Image.asset(
                      widget.matchDetails['side'] == "red"
                          ? 'assets/red_side.png'
                          : 'assets/blue_side.png',
                      width: 500,
                      height: 600,
                    ),

                    // Position buttons relative to the image
                    Positioned(
                      top: 10,
                      left: 100,
                      child: Column(
                        children: [
                          position_btns("H", "h_basket", "high basket", isSamplePicked),
                          SizedBox(height: 5,),
                          position_btns("L", "l_basket", "low basket", isSamplePicked),
                          SizedBox(height: 5,),
                          position_btns("N", "net", "net zone", isSamplePicked),
                          SizedBox(height: 5,),
                          position_btns("￬", "drop", "dropped", isSamplePicked),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 0,
                      left: 255,
                      child: Column(
                        children: [
                          position_btns("+", "sample", "preset sample zone top", !isSamplePicked, Colors.yellowAccent),
                          SizedBox(height: 7,),
                          position_btns("+", "sample", "preset sample zone middle", !isSamplePicked, Colors.yellowAccent),
                          SizedBox(height: 11,),
                          position_btns("+", "sample", "preset sample zone bottom", !isSamplePicked, Colors.yellowAccent),
                        ],
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 255,
                      child: Column(
                        children: [
                          position_btns("+", "sample", "preset colored sample zone top", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                          SizedBox(height: 12,),
                          position_btns("+", "sample", "preset colored sample zone middle", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                          SizedBox(height: 8,),
                          position_btns("+", "sample", "preset colored sample zone bottom", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 230,
                      left: 180,
                      child: Column(
                        children: [
                          position_btns("H", "h_chamber", "high chamber", isSamplePicked),
                          SizedBox(height: 5,),
                          position_btns("L", "l_chamber", "low chamber", isSamplePicked),
                          SizedBox(height: 5,),
                          position_btns("￬", "drop", "dropped", isSamplePicked),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 255,
                      left: 265,
                      child: Row(
                        children: [
                          position_btns("+", "sample", "${widget.matchDetails['side']} side submersible zone (yellow sample)", !isSamplePicked, Colors.yellow),
                          position_btns("+", "sample", "${widget.matchDetails['side']} side submersible zone (colored sample)", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 315,
                      left: 265,
                      child: Row(
                        children: [
                          position_btns("+", "sample", "${widget.matchDetails['side']} side submersible zone (yellow sample)", !isSamplePicked, Colors.yellow),
                          position_btns("+", "sample", "${widget.matchDetails['side']} side submersible zone (colored sample)", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 255,
                      left: 355,
                      child: Row(
                        children: [
                          position_btns("+", "sample", "${(widget.matchDetails['side']!="red") ? "red" : "blue"} submersible zone (yellow sample)", !isSamplePicked, Colors.yellow),
                          position_btns("+", "sample", "${(widget.matchDetails['side']!="red") ? "red" : "blue"} submersible zone (colored sample)", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 315,
                      left: 355,
                      child: Row(
                        children: [
                          position_btns("+", "sample", "${(widget.matchDetails['side']!="red") ? "red" : "blue"} submersible zone (yellow sample)", !isSamplePicked, Colors.yellow),
                          position_btns("+", "sample", "${(widget.matchDetails['side']!="red") ? "red" : "blue"} submersible zone (colored sample)", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                        ],
                      ),
                    ),

                    // Positioned(
                    //   bottom: 50,
                    //   left: 50,
                    //   child: Column(
                    //     children: [
                    //       position_btns("￬", "drop", "dropped", isSamplePicked),
                    //       SizedBox(height: 70,),
                    //       position_btns("P", "parking", "parked observation zone"),
                    //     ],
                    //   ),
                    // ),

                    Positioned(
                      bottom: 10,
                      left: 55,
                      child: Column(
                        children: [
                          position_btns("￬", "drop", "dropped", isSamplePicked),
                          SizedBox(height: 40,),
                          position_btns("+￬", "specimen drop", "observation zone dropped", isSamplePicked),
                          SizedBox(height: 20,),
                          position_btns("+", "specimen", "specimen picked from observation zone", !isSamplePicked, (widget.matchDetails['side']=="red")?Colors.redAccent:Colors.blueAccent),
                          SizedBox(height: 20,),
                          position_btns("P", "parking", "parked observation zone"),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 180,
                      left: 300,
                      child: Row(
                        children: [
                          position_btns("P", "parking", "parked ascend zone"),
                          SizedBox(width: 20,),
                          position_btns("￬", "drop", "dropped", isSamplePicked),
                        ],
                      ),
                    ),

                    Positioned(
                      top: 280,
                      left: 20,
                      right: 20,
                      child: AnimatedOpacity(
                        opacity: showMessage ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 100),
                        child: IgnorePointer(
                          ignoring: !showMessage,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                latestAction,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
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
              SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () async {
                  print(score);
                  print(autoSequence);
                  widget.matchDetails.addAll({
                    "autoScore" : score,
                    "autoParking": parking,
                    "autoSequence": autoSequence,
                    "autoComments": commentController.text,
                    "autoEndIsSample": isSamplePicked
                  });
                  print(widget.matchDetails);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TeleOp(matchDetails: widget.matchDetails,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  minimumSize: const Size(100, 50),
                  // textStyle: TextStyle(fontSize: 14),
                  shadowColor: Colors.blue,
                  elevation: 5,
                ),
                child: Text("TeleOp",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
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

  Widget position_btns(text, value, position, [visible = true, color = Colors.white]){
    if (!visible) return const SizedBox.shrink(); // Invisible
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          autoSequence.add(position);
          showTemporaryMessage(position);
          if(value == "sample"){
            isSamplePicked = true;
            latestAction = "Sample picked from $position";
          }
          else if(value == "specimen"){
            isSamplePicked = true;
            latestAction = "Specimen picked from $position";
          }
          else if(value == "parking"){
            score += 3;
            parking = true;
            latestAction = "Robot Parked at $position";
          }
          else{
            if(isSamplePicked){
              if(value == "net"){
                score += 2;
                sampleCount++;
              }
              else if(value == "l_basket"){
                score += 4;
                sampleCount++;
              }
              else if(value == "h_basket"){
                score += 8;
                sampleCount++;
              }
              else if(value == "l_chamber"){
                score += 6;
                specimenCount++;
              }
              else if(value == "h_chamber"){
                score += 10;
                specimenCount++;
              }
              else{}
              isSamplePicked = false;
              if(value != "drop") {
                latestAction = "Robot scored at $position";
              }
              else{
                latestAction = "Sample dropped";
              }

            }
            else{
              final snackBar = SnackBar(
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: 'Data Missing',
                  message: 'Please pick a sample first ',
                  contentType: ContentType.warning,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2),
        minimumSize: const Size(40, 10),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        // textStyle: TextStyle(fontSize: 14),
        shadowColor: Colors.blue,
        elevation: 5,
      ),
      child: Text(text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontFamily: "Cooper",
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

}