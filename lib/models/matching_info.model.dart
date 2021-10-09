import 'package:cloud_firestore/cloud_firestore.dart';

class MatchingInfo {
  final String name;
  final double rate;
  final double maxRate;
  final int imageNumber;
  final int matchedCount;
  final int continuousWinCount;
  final List<int> skillList;
  final int matchingStatus;
  final bool precedingFlg;
  final String customData;

  const MatchingInfo({
    required this.name,
    required this.rate,
    required this.maxRate,
    required this.imageNumber,
    required this.matchedCount,
    required this.continuousWinCount,
    required this.skillList,
    required this.matchingStatus,
    required this.precedingFlg,
    required this.customData,
  });

  factory MatchingInfo.fromJson(DocumentSnapshot<Object?> json) {
    return MatchingInfo(
      name: json['name'] as String,
      rate: json['rate'] as double,
      maxRate: json['maxRate'] as double,
      imageNumber: json['imageNumber'] as int,
      matchedCount: json['matchedCount'] as int,
      continuousWinCount: json['continuousWinCount'] as int,
      skillList: [
        json['skillList'][0] as int,
        json['skillList'][1] as int,
        json['skillList'][2] as int,
      ],
      matchingStatus: json['matchingStatus'] as int,
      precedingFlg: json['precedingFlg'] as bool,
      customData: json['customData'] as String,
    );
  }
}
