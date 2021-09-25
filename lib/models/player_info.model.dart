import 'package:flutter/material.dart';

class PlayerInfo {
  final String name;
  final double rate;
  final double maxRate;
  final int imageNumber;
  final int matchedCount;
  final List<int> skillList;
  final MaterialColor color;

  const PlayerInfo({
    required this.name,
    required this.rate,
    required this.maxRate,
    required this.imageNumber,
    required this.matchedCount,
    required this.skillList,
    required this.color,
  });
}
