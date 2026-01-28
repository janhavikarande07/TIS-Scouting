import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import 'auto.dart';
import 'colors.dart';

class PreLoad extends StatefulWidget{

  final Map<String, dynamic> matchDetails;
  const PreLoad({Key? key, required this.matchDetails}) : super(key: key);

  @override
  State<PreLoad> createState() => PreLoadState();
}

class PreLoadState extends State<PreLoad> {

  String auto_position = "";
  String preload = "";
  int? selectedIndex;
  List<bool> isPressedPreloadList = List.generate(2, (_) => false);

  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preload", style: TextStyle(fontWeight: FontWeight.w700),),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              Container(
                alignment: AlignmentDirectional.centerEnd,
                margin: EdgeInsets.only(right: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      selectedIndex = null;
                      auto_position = "";
                    });
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
                  child: const Text("Reload ↻",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Cooper",
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Stack(
                children: [
                  (widget.matchDetails['side'] == "red") ?
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
              Text("Preload used: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                       preload = "yellow";
                       isPressedPreloadList[0] = true;
                       isPressedPreloadList[1] = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPressedPreloadList[0]? Colors.yellow : Colors.yellowAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: isPressedPreloadList[0]
                            ? const BorderSide(color: Colors.black, width: 2)
                            : BorderSide.none,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      minimumSize: const Size(70, 30),
                      // textStyle: TextStyle(fontSize: 14),
                      // shadowColor: Colors.blue,
                      elevation: 3,
                    ),
                    child: Text("+",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Cooper",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: 50,),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        preload = (widget.matchDetails["side"] == "red") ? "red" : "blue";
                        isPressedPreloadList[1] = true;
                        isPressedPreloadList[0] = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPressedPreloadList[1]? (widget.matchDetails["side"] == "red") ? Colors.red : Colors.blue : (widget.matchDetails["side"] == "red") ? Colors.redAccent : Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: isPressedPreloadList[1]
                            ? const BorderSide(color: Colors.black, width: 2)
                            : BorderSide.none,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      minimumSize: const Size(70, 30),
                      // textStyle: TextStyle(fontSize: 14),
                      // shadowColor: Colors.blue,
                      elevation: 3,
                    ),
                    child: Text("+",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Cooper",
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  )
                ],
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
                  if(preload.isEmpty || auto_position.isEmpty){
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
                    widget.matchDetails.addAll({
                      "autoPosition": auto_position,
                      "preload": preload,
                      "preloadComments": commentController.text
                    });
                    print(widget.matchDetails);
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            Auto(matchDetails: widget.matchDetails,)));
                  }
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
                child: Text("Auto",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: "Cooper",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
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
          setState(() {
            auto_position= text;
            selectedIndex = index;
          });
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