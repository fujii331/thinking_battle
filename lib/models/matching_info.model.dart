import 'package:cloud_firestore/cloud_firestore.dart';

class MatchingInfo {
  final String name;
  final double rate;
  final double maxRate;
  final int imageNumber;
  final int matchedCount;
  final int continuousWinCount;
  final int skill1;
  final int skill2;
  final int skill3;
  final int matchingStatus;
  final bool precedingFlg;
  final String createdAt;

  const MatchingInfo({
    required this.name,
    required this.rate,
    required this.maxRate,
    required this.imageNumber,
    required this.matchedCount,
    required this.continuousWinCount,
    required this.skill1,
    required this.skill2,
    required this.skill3,
    required this.matchingStatus,
    required this.precedingFlg,
    required this.createdAt,
  });

  factory MatchingInfo.fromJson(DocumentSnapshot<Object?> json) {
    return MatchingInfo(
      name: json['name'],
      rate: json['rate'],
      maxRate: json['maxRate'],
      imageNumber: json['imageNumber'],
      matchedCount: json['matchedCount'],
      continuousWinCount: json['continuousWinCount'],
      skill1: json['skill1'],
      skill2: json['skill2'],
      skill3: json['skill3'],
      matchingStatus: json['matchingStatus'],
      precedingFlg: json['precedingFlg'],
      createdAt: json['createdAt'],
    );
  }
}
