import 'package:hive/hive.dart';

part 'Match.g.dart';

@HiveType(typeId: 0)
class Match {
  @HiveField(0)
  final String matchType;

  @HiveField(1)
  final String matchNumber;

  @HiveField(2)
  final String teamNumber;

  @HiveField(3)
  final String side;

  @HiveField(4)
  final String preload;

  @HiveField(5)
  final String preloadComments;

  @HiveField(6)
  final String autoPosition;

  @HiveField(7)
  final int autoScore;

  @HiveField(8)
  final bool autoParking;

  @HiveField(9)
  final List<String> autoSequence;

  @HiveField(10)
  final String autoComments;

  @HiveField(11)
  final int teleopScore;

  @HiveField(12)
  final List<int> teleopSequence;

  @HiveField(13)
  final int totalCycles;

  @HiveField(14)
  final String teleopComments;

  @HiveField(15)
  final String endComments;

  @HiveField(16)
  final int totalScore;

  @HiveField(17)
  final bool majorPenalty;

  @HiveField(18)
  final bool minorPenalty;

  @HiveField(19)
  final int ascendPoints;

  @HiveField(20)
  final String robotPreference;

  @HiveField(21)
  final String scouterName;

  @HiveField(22)
  final String driverRatings;

  @HiveField(23)
  final bool descored;

  Match({
    required this.matchType,
    required this.matchNumber,
    required this.teamNumber,
    required this.side,
    required this.preload,
    required this.preloadComments,
    required this.autoPosition,
    required this.autoScore,
    required this.autoParking,
    required this.autoSequence,
    required this.autoComments,
    required this.teleopScore,
    required this.teleopSequence,
    required this.totalCycles,
    required this.teleopComments,
    required this.endComments,
    required this.totalScore,
    required this.majorPenalty,
    required this.minorPenalty,
    required this.ascendPoints,
    required this.robotPreference,
    required this.scouterName,
    required this.driverRatings,
    required this.descored,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchType: json['matchType'],
      matchNumber: json['matchNumber'],
      teamNumber: json['teamNumber'],
      side: json['side'],
      preload: json['preload'],
      preloadComments: json['preloadComments'],
      autoPosition: json['autoPosition'],
      autoScore: json['autoScore'],
      autoParking: json['autoParking'],
      autoSequence: List<String>.from(json['autoSequence'] ?? []),
      autoComments: json['autoComments'],
      teleopScore: json['teleopScore'],
      teleopSequence: List<int>.from(json['teleopSequence'] ?? []),
      totalCycles: json['totalCycles'],
      teleopComments: json['teleopComments'],
      endComments: json['endComments'],
      totalScore: json['totalScore'],
      majorPenalty: json['majorPenalty'],
      minorPenalty: json['minorPenalty'],
      ascendPoints: json['ascendPoints'],
      robotPreference: json['robotPreference'],
      scouterName: json['scouterName'],
      driverRatings: json['driverRatings'],
      descored: json['descored'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchType': matchType,
      'matchNumber': matchNumber,
      'teamNumber': teamNumber,
      'side': side,
      'preload': preload,
      'preloadComments': preloadComments,
      'autoPosition': autoPosition,
      'autoScore': autoScore,
      'autoParking': autoParking,
      'autoSequence': autoSequence,
      'autoComments': autoComments,
      'teleopScore': teleopScore,
      'teleopSequence': teleopSequence,
      'totalCycles': totalCycles,
      'teleopComments': teleopComments,
      'endComments': endComments,
      'totalScore': totalScore,
      'majorPenalty': majorPenalty,
      'minorPenalty': minorPenalty,
      'ascendPoints': ascendPoints,
      'robotPreference': robotPreference,
      'scouterName': scouterName,
      'driverRatings': driverRatings,
      'descored': descored,
    };
  }
}
