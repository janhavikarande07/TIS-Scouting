// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Match.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MatchAdapter extends TypeAdapter<Match> {
  @override
  final int typeId = 0;

  @override
  Match read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Match(
      matchType: fields[0] as String,
      matchNumber: fields[1] as String,
      teamNumber: fields[2] as String,
      side: fields[3] as String,
      preload: fields[4] as String,
      preloadComments: fields[5] as String,
      autoPosition: fields[6] as String,
      autoScore: fields[7] as int,
      autoParking: fields[8] as bool,
      autoSequence: (fields[9] as List).cast<String>(),
      autoComments: fields[10] as String,
      teleopScore: fields[11] as int,
      teleopSequence: (fields[12] as List).cast<int>(),
      totalCycles: fields[13] as int,
      teleopComments: fields[14] as String,
      endComments: fields[15] as String,
      totalScore: fields[16] as int,
      majorPenalty: fields[17] as bool,
      minorPenalty: fields[18] as bool,
      ascendPoints: fields[19] as int,
      robotPreference: fields[20] as String,
      scouterName: fields[21] as String,
      driverRatings: fields[22] as String,
      descored: fields[23] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Match obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.matchType)
      ..writeByte(1)
      ..write(obj.matchNumber)
      ..writeByte(2)
      ..write(obj.teamNumber)
      ..writeByte(3)
      ..write(obj.side)
      ..writeByte(4)
      ..write(obj.preload)
      ..writeByte(5)
      ..write(obj.preloadComments)
      ..writeByte(6)
      ..write(obj.autoPosition)
      ..writeByte(7)
      ..write(obj.autoScore)
      ..writeByte(8)
      ..write(obj.autoParking)
      ..writeByte(9)
      ..write(obj.autoSequence)
      ..writeByte(10)
      ..write(obj.autoComments)
      ..writeByte(11)
      ..write(obj.teleopScore)
      ..writeByte(12)
      ..write(obj.teleopSequence)
      ..writeByte(13)
      ..write(obj.totalCycles)
      ..writeByte(14)
      ..write(obj.teleopComments)
      ..writeByte(15)
      ..write(obj.endComments)
      ..writeByte(16)
      ..write(obj.totalScore)
      ..writeByte(17)
      ..write(obj.majorPenalty)
      ..writeByte(18)
      ..write(obj.minorPenalty)
      ..writeByte(19)
      ..write(obj.ascendPoints)
      ..writeByte(20)
      ..write(obj.robotPreference)
      ..writeByte(21)
      ..write(obj.scouterName)
      ..writeByte(22)
      ..write(obj.driverRatings)
      ..writeByte(23)
      ..write(obj.descored);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
