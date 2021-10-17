import 'dart:math';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

Future updateRate(
  BuildContext context,
  bool winFlg,
) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final double myRate = context.read(rateProvider).state;

  // 敵のレート
  final PlayerInfo rivalInfo = context.read(rivalInfoProvider).state;
  final double rivalRate = rivalInfo.rate;

  final double newRate = getNewRate(
    myRate,
    rivalRate,
    winFlg,
  );

  final double newRivalRate = getNewRate(
    rivalRate,
    myRate,
    !winFlg,
  );

  // レート更新
  context.read(rateProvider).state = newRate;
  prefs.setDouble('rate', newRate);

  // レート更新
  context.read(rivalInfoProvider).state = PlayerInfo(
    name: rivalInfo.name,
    rate: newRivalRate,
    imageNumber: rivalInfo.imageNumber,
    cardNumber: rivalInfo.cardNumber,
    matchedCount: rivalInfo.matchedCount,
    continuousWinCount: winFlg ? 0 : rivalInfo.continuousWinCount + 1,
    skillList: rivalInfo.skillList,
  );

  // 接続が切れた場合のレートを更新
  prefs.setDouble('failedRate', 0.0);

  if (winFlg) {
    final double maxRate = context.read(maxRateProvider).state;

    // 最大レート更新時
    if (newRate > maxRate) {
      context.read(maxRateProvider).state = newRate;
      prefs.setDouble('maxRate', newRate);
    }
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
  return ((myRate + adjustedValue * (winCount - winPercent)) * 10).round() / 10;
}
