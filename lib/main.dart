import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tis_ftc/Match.dart';

import 'DivisionSelect.dart';
import 'HomePage.dart';
import 'colors.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

void main() async { //await and async when the process will take some time to return value so just return a placeholder
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MatchAdapter());
  await Hive.openBox<Match>("Match");
  // await Hive.openBox<LocustModel>("project_mynah_synced");
  // app = await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  // auth = FirebaseAuth.instanceFor(app: app);
  runApp(MyApp());
}

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'TIS Scouting',
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  // User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // FirebaseAuth.instance.signOut();

    Timer(const Duration(seconds: 3),
            () async {

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) => DivisionSelect()
              )
          );
          // }
        }
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeColor,
      body: SafeArea(
        child : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("TIS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: lightThemeColor), textAlign: TextAlign.center,),
                SizedBox(height: 10,),
                Text("FTC Scouting", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: lightThemeColor), textAlign: TextAlign.center,),
              ],
            )
        ),
      ),
    );
  }
}