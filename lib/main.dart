import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'DivisionSelect.dart';
import 'HomePage.dart';
import 'firebase_options.dart';
import 'login_email.dart';
import 'Match.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MatchAdapter());
  await Hive.openBox<Match>("Match");
  app = await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  auth = FirebaseAuth.instanceFor(app: app);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TIS Analyzer',
      home: SplashPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3),
            (){
          if(user == null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>  const LoginPage()
                )
            );
          }
          else{
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) => DivisionSelect()
                )
            );
          }
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
      body: SafeArea(
        child : Center(
            child: Text("FTC Analyzer", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),)
        ),
      ),
    );
  }
}