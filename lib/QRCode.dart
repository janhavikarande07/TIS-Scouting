import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:tis_ftc/Qualification_Matches.dart';
import 'package:tis_ftc/pre_load.dart';

import 'colors.dart';
import 'Match.dart';

class QRCode_ extends StatefulWidget {
  @override
  State<QRCode_> createState() => QRCode_State();
}

class QRCode_State extends State<QRCode_> {
  final List<Match> matchList = Hive.box<Match>('Match').values.toList();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex >= matchList.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "QR Code",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: isLast
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text(
              "All Matches Shared!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await Hive.box<Match>('Match').clear();
                Navigator.of(context).pop();
              },
              child: const Text("Done"),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: jsonEncode(matchList[currentIndex].toJson()),
              version: QrVersions.auto,
              size: 250,
            ),
            const SizedBox(height: 20),
            Text("Match ${currentIndex + 1} of ${matchList.length}"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex++;
                });
                print(matchList[currentIndex].toJson());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 7),
                minimumSize: const Size(150, 30),
                // textStyle: TextStyle(fontSize: 14),
                shadowColor: Colors.blue,
                elevation: 5,
              ),
              child: Text(currentIndex == matchList.length - 1 ? "Finish" : "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontFamily: "Cooper",
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
