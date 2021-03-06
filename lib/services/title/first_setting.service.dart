import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

void firstSetting(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  final double? failedRate = prefs.getDouble('failedRate');
  // レート設定
  if (failedRate != null && failedRate != 0.0) {
    context.read(continuousWinCountProvider).state = 0;
    prefs.setInt('continuousWinCount', 0);
    prefs.setDouble('rate', failedRate);
    prefs.setDouble('failedRate', 0.0);
  }

  // 音量設定
  final double? seVolume = prefs.getDouble('seVolume');

  if (seVolume != null) {
    context.read(seVolumeProvider).state = seVolume;
  } else {
    prefs.setDouble('seVolume', 0.5);
  }

  context.read(soundEffectProvider).state.loadAll([
    'sounds/cancel.mp3',
    'sounds/change.mp3',
    'sounds/correct_answer.mp3',
    'sounds/gacha.mp3',
    'sounds/gacha_start.mp3',
    'sounds/got_message.mp3',
    'sounds/hint.mp3',
    'sounds/matching.mp3',
    'sounds/my_turn.mp3',
    'sounds/new_item.mp3',
    'sounds/open_advertise.mp3',
    'sounds/question_research.mp3',
    'sounds/ready.mp3',
    'sounds/reply.mp3',
    'sounds/rival_message.mp3',
    'sounds/same_item.mp3',
    'sounds/skill.mp3',
    'sounds/start.mp3',
    'sounds/tap.mp3',
    'sounds/waiting_answer.mp3',
    'sounds/fault.mp3',
  ]);
  // 閲覧済み情報リスト
  context.read(watchedInfoListProvider).state =
      prefs.getStringList('watchedInfoList') ?? [];

  // プレイヤー名
  context.read(playerNameProvider).state = prefs.getString('playerName') ?? '';
  // ログインID
  context.read(loginIdProvider).state = prefs.getString('email') ?? '';
  // 画像番号
  context.read(imageNumberProvider).state = prefs.getInt('imageNumber') ?? 1;
  // カード番号
  context.read(cardNumberProvider).state = prefs.getInt('cardNumber') ?? 1;
  // 画像番号リスト
  context.read(imageNumberListProvider).state =
      prefs.getStringList('imageNumberList') ?? ['1', '2', '3', '4', '5', '6'];

  // カード番号リスト
  context.read(cardNumberListProvider).state =
      prefs.getStringList('cardNumberList') ?? ['1', '2', '3', '4'];
  // メッセージIDリスト
  context.read(messageIdsListProvider).state =
      prefs.getStringList('messageIdsList') ?? ['1', '2', '3', '4'];
  // レート
  context.read(rateProvider).state = prefs.getDouble('rate') ?? 1500.0;
  // 最大レート
  context.read(maxRateProvider).state = prefs.getDouble('maxRate') ?? 1500.0;

  // スキル
  context.read(mySkillIdsListProvider).state =
      prefs.getStringList('skillList') != null
          ? prefs
              .getStringList('skillList')
              ?.map((skill) => int.parse(skill))
              .toList() as List<int>
          : [1, 2, 3];

  // メッセージ
  context.read(myMessageIdsListProvider).state =
      prefs.getStringList('messageList') != null
          ? prefs
              .getStringList('messageList')
              ?.map((message) => int.parse(message))
              .toList() as List<int>
          : [1, 2, 3, 4];

  // 対戦数
  context.read(matchedCountProvider).state = prefs.getInt('matchCount') ?? 0;
  // 勝利数
  context.read(winCountProvider).state = prefs.getInt('winCount') ?? 0;
  // // イベント勝利数
  // // イベント開始してから終了するまで
  // context.read(eventWinCountProvider).state =
  //     prefs.getInt('eventWinCount') ?? 0;
  // 連続勝利数
  context.read(continuousWinCountProvider).state =
      prefs.getInt('continuousWinCount') ?? 0;
  // 最大連続勝利数
  context.read(maxContinuousWinCountProvider).state =
      prefs.getInt('maxContinuousWinCount') ?? 0;
  // スキル使用回数
  context.read(skillUseCountProvider).state =
      prefs.getInt('skillUseCount') ?? 0;

  // GP
  context.read(gachaPointProvider).state = prefs.getInt('gachaPoint') ?? 0;
  // ガチャカウント
  context.read(gachaCountProvider).state = prefs.getInt('gachaCount') ?? 5;
  // ガチャチケット
  context.read(gachaTicketProvider).state = prefs.getInt('gachaTicket') ?? 0;

  // スタンプリスト
  context.read(stampListProvider).state =
      prefs.getStringList('stampList') ?? ['0', '0', '0', '0', '0', '0'];

  // 選択可能スキルリスト
  context.read(settableSkillsListProvider).state =
      prefs.getStringList('settableSkillsList') ?? ['1', '2', '3'];

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
