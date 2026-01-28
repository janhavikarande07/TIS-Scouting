import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ftc_analyzer/values_.dart';
import 'package:hive/hive.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import 'Match.dart';
import 'colors.dart';

class Scan_QR extends StatefulWidget {
  const Scan_QR({super.key});

  @override
  State<Scan_QR> createState() => _Scan_QRState();
}

class _Scan_QRState extends State<Scan_QR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;

  Box<Match> box = Hive.box<Match>('Match');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Scan')),
      body: Stack(
        children: [
          _buildQrView(context),
          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.6),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: Text(
                  'Scan the QR Code',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.shortestSide < 400 ? 200.0 : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (_isProcessing) return;

      setState(() {
        _isProcessing = true;
      });

      try {
        final data = scanData.code ?? '';
        final Map<String, dynamic> decodedData = json.decode(data);
        print("decode $decodedData");
        final newMatch = Match.fromJson(decodedData);
        print("vj $newMatch");

        final isDuplicateHive = box.values.any((m) =>
        m.matchType == newMatch.matchType &&
            m.matchNumber == newMatch.matchNumber &&
            m.teamNumber == newMatch.teamNumber
        );

        final querySnapshot = await FirebaseFirestore.instance
            .collection("$division $matchType")
            .where("matchType", isEqualTo: newMatch.matchType)
            .where("matchNumber", isEqualTo: newMatch.matchNumber)
            .where("teamNumber", isEqualTo: newMatch.teamNumber)
            .get();

        final isDuplicateFirebase = querySnapshot.docs.isNotEmpty;

        if (isDuplicateHive || isDuplicateFirebase) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Duplicate match already exists.")),
            );
            setState(() {
              _isProcessing = false;
            });
          }
        } else {
          await FirebaseFirestore.instance.collection("$division $matchType").add(
              decodedData);
          await box.add(newMatch);
          controller.pauseCamera(); // stop scanning

          if (mounted) _showCompletionDialog();
        }
      } catch (e) {
        log("Error decoding or saving: $e");
        print("error $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid QR code!")),
          );
          setState(() {
            _isProcessing = false;
          });
        }
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: lightThemeColor,
        title: const Text('Scan Done', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('All data has been saved!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // go back to home
            },
            child: const Text('OK'),
          ),
        ],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool permissionGranted) {
    if (!permissionGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
