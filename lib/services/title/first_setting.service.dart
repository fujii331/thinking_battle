import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/return_color.service.dart';

void firstSetting(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // 音量設定
  final double? bgmVolume = prefs.getDouble('bgmVolume');
  final double? seVolume = prefs.getDouble('seVolume');

  if (bgmVolume != null) {
    context.read(bgmVolumeProvider).state = bgmVolume;
  } else {
    prefs.setDouble('bgmVolume', 0.2);
  }
  if (seVolume != null) {
    context.read(seVolumeProvider).state = seVolume;
  } else {
    prefs.setDouble('seVolume', 0.5);
  }

  context
      .read(bgmProvider)
      .state
      .setVolume(context.read(bgmVolumeProvider).state);

  context.read(soundEffectProvider).state.loadAll([
    'sounds/cancel.mp3',
    'sounds/change.mp3',
    'sounds/correct_answer.mp3',
    'sounds/got_message.mp3',
    'sounds/matching.mp3',
    'sounds/my_turn.mp3',
    'sounds/open_advertise.mp3',
    'sounds/question_research.mp3',
    'sounds/ready.mp3',
    'sounds/reply.mp3',
    'sounds/skill.mp3',
    'sounds/start.mp3',
    'sounds/tap.mp3',
    'sounds/waiting_answer.mp3',
    'sounds/fault.mp3',
  ]);

  // プレイヤー名
  context.read(playerNameProvider).state = prefs.getString('playerName') ?? '';
  // ログインID
  context.read(loginIdProvider).state = prefs.getString('email') ?? '';
  // 画像番号
  context.read(imageNumberProvider).state = prefs.getInt('imageNumber') ?? 1;
  // レート
  context.read(rateProvider).state = prefs.getDouble('rate') ?? 1500.0;
  // 最大レート
  final double maxRate = context.read(maxRateProvider).state =
      prefs.getDouble('maxRate') ?? 1500.0;
  // カラー
  context.read(colorProvider).state = returnColor(maxRate);

  // スキル
  context.read(mySkillIdsListProvider).state =
      prefs.getStringList('skillList') != null
          ? prefs
              .getStringList('skillList')
              ?.map((skill) => int.parse(skill))
              .toList() as List<int>
          : [1, 2, 3];

  // 対戦数
  context.read(matchedCountProvider).state = prefs.getInt('matchCount') ?? 0;
  // 勝利数
  context.read(winCountProvider).state = prefs.getInt('winCount') ?? 0;

  // ライフ
  // if (prefs.getString('saveTime') != null) {
  //   // ライフ1つあたりの時間
  //   const int lifeCaluculateTime = 60 * 15;

  //   final DateTime savedTime = DateTime.parse(prefs.getString('saveTime')!);
  //   final Duration difference = DateTime.now().difference(savedTime);
  //   final int sec = difference.inSeconds;
  //   if (sec >= lifeCaluculateTime * 5) {
  //     context.read(lifePointProvider).state = 5;
  //   } else {
  //     final int lifePoint = (sec / lifeCaluculateTime).floor();
  //     context.read(lifePointProvider).state = lifePoint;

  //     final int remainSec = sec - lifePoint * lifeCaluculateTime;
  //     final int recoveryTimeMinutes = (remainSec / 60).floor();
  //     final int recoveryTimeSeconds = remainSec - recoveryTimeMinutes * 60;

  //     context.read(recoveryTimeProvider).state =
  //         DateTime(2020, 1, 1, 1, recoveryTimeMinutes, recoveryTimeSeconds);
  //   }
  // }
}
