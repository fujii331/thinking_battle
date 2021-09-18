import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/return_color.service.dart';

Future updateLate(
  BuildContext context,
  double myRate,
  double rivalRate,
  bool winFlg,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final double newRate = getNewRate(
    myRate,
    rivalRate,
    winFlg,
  );

  // レート更新
  context.read(rateProvider).state = newRate;
  prefs.setDouble('rate', newRate);

  // 敵のレート更新
  PlayerInfo rivalInfo = context.read(rivalInfoProvider).state;
  MaterialColor rivalColor = rivalInfo.color;

  final double newRivalRate = getNewRate(
    rivalRate,
    myRate,
    !winFlg,
  );

  if (newRivalRate > rivalInfo.maxRate) {
    rivalColor = returnColor(newRivalRate);
  }

  // レート更新
  rivalInfo = PlayerInfo(
    name: rivalInfo.name,
    rate: newRivalRate,
    maxRate: rivalInfo.maxRate,
    imageNumber: rivalInfo.imageNumber,
    skillList: rivalInfo.skillList,
    color: rivalColor,
  );

  final double maxRate = context.read(maxRateProvider).state;

  // 最大レート更新時
  if (newRate > maxRate) {
    context.read(maxRateProvider).state = newRate;
    prefs.setDouble('maxRate', newRate);

    // カラー
    context.read(colorProvider).state = returnColor(newRate);
  }
}

double getNewRate(
  double myRate,
  double rivalRate,
  bool winFlg,
) {
  // 大きいほど、適正レーティングに収束するのが早くなる一方、収束した後も頻繁に上下する不安定な値となる
  const int adjustedValue = 32;

  final double rateDifference = rivalRate - myRate;

  final double winPercent = 1 / (1 + pow(10, (rateDifference / 400)));

  final int winCount = winFlg ? 1 : 0;

  return myRate + adjustedValue * (winCount - winPercent);
}
