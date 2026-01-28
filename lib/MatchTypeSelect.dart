import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'colors.dart';
import 'values_.dart';

class MatchTypeSelect extends StatefulWidget {
  const MatchTypeSelect({super.key});

  @override
  State<MatchTypeSelect> createState() => _MatchTypeSelectState();
}

class _MatchTypeSelectState extends State<MatchTypeSelect> {

  List<bool> isPressedPreloadList = List.generate(2, (_) => false);

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       width: MediaQuery.of(context).size.width,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Text("Select Match Type: ", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
           SizedBox(height: 15,),
           ElevatedButton(
             onPressed: () async {
               setState(() {
                 matchType = "finals";
                 isPressedPreloadList[0] = true;
                 isPressedPreloadList[1] = false;
               });
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: themeColor,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20),
                 side: isPressedPreloadList[0]
                     ? const BorderSide(color: Colors.black, width: 2)
                     : BorderSide.none,
               ),
               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
               minimumSize: const Size(150, 40),
               // textStyle: TextStyle(fontSize: 14),
               // shadowColor: Colors.blue,
               elevation: 3,
             ),
             child: Text("Finals",
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 18,
                 fontFamily: "Cooper",
                 fontStyle: FontStyle.normal,
                 fontWeight: FontWeight.w800,
               ),
             ),
           ),
           SizedBox(height: 20,),
           ElevatedButton(
             onPressed: () async {
               setState(() {
                matchType = "qualification";
                isPressedPreloadList[0] = false;
                isPressedPreloadList[1] = true;
               });
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: themeColor,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20),
                 side: isPressedPreloadList[1]
                     ? const BorderSide(color: Colors.black, width: 2)
                     : BorderSide.none,
               ),
               padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
               minimumSize: const Size(150, 40),
               // textStyle: TextStyle(fontSize: 14),
               // shadowColor: Colors.blue,
               elevation: 3,
             ),
             child: Text("Qualifications",
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 18,
                 fontFamily: "Cooper",
                 fontStyle: FontStyle.normal,
                 fontWeight: FontWeight.w900,
               ),
             ),
           ),
           SizedBox(height: 40,),
           ElevatedButton(
             onPressed: () async {
               if(matchType==null){
                 final snackBar = SnackBar(
                   elevation: 0,
                   behavior: SnackBarBehavior.floating,
                   backgroundColor: Colors.transparent,
                   content: AwesomeSnackbarContent(
                     title: 'Data Missing',
                     message: 'Please select the matchType',
                     contentType: ContentType.warning,
                   ),
                 );

                 ScaffoldMessenger.of(context)
                   ..hideCurrentSnackBar()
                   ..showSnackBar(snackBar);
               }
               else {
                 Navigator.push(context, MaterialPageRoute(
                     builder: (context) =>Home()));
               }
             },
             style: ElevatedButton.styleFrom(
               backgroundColor: themeColor,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10),
               ),
               padding: const EdgeInsets.symmetric(vertical: 5),
               minimumSize: const Size(100, 30),
               // textStyle: TextStyle(fontSize: 14),
               shadowColor: Colors.blue,
               elevation: 5,
             ),
             child: Text("Start",
               style: TextStyle(
                 color: Colors.white,
                 fontSize: 21,
                 fontFamily: "Cooper",
                 fontStyle: FontStyle.normal,
                 fontWeight: FontWeight.w800,
               ),
             ),
           )
         ],
       ),
     ),
   );
  }

}