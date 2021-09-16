import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/quiz_data.dart';

String commonInitialAction(
  BuildContext context,
) {
  final Quiz quiz = quizData[Random().nextInt(quizData.length)];
  // 初期化
  context.read(bgmProvider).state.stop();
  context.read(currentSkillPointProvider).state = 3;
  context.read(alreadyseenQuestionsProvider).state = [];
  context.read(selectableQuestionsProvider).state = [];
  context.read(displayContentListProvider).state = [];
  context.read(answerFailedFlgProvider).state = false;
  context.read(forceQuestionFlgProvider).state = false;
  context.read(spChargeTurnProvider).state = 0;
  context.read(turnCountProvider).state = 0;

  // 問題を設定
  context.read(allQuestionsProvider).state = quiz.questions;
  context.read(correctAnswersProvider).state = quiz.correctAnswers;

  return quiz.thema;
}

void trainingInitialAction(
  BuildContext context,
) {
  context.read(enemySkillPointProvider).state = 3;
  context.read(sumImportanceProvider).state = 0;

  final List<List<int>> skillListData = [
    [1, 2, 3],
    [2, 3, 4],
  ];
  final List<int> skillList = skillListData[Random().nextInt(3)];

  context.read(enemySkillsProvider).state = skillList;

  context.read(rivalInfoProvider).state = PlayerInfo(
    name: 'CPU',
    rate: 500.0,
    maxRate: 500.0,
    imageNumber: 9,
    skillList: skillList,
  );

  context.read(rivalColorProvider).state = Colors.blue;

  // マッチング時の処理
  //   final PlayerInfo rivalInfo = context.read(rivalInfoProvider).state;

  // context.read(rivalColorProvider).state = rivalInfo.maxRate >= 1500
  //     ? Colors.purple
  //     : rivalInfo.maxRate >= 1250
  //         ? Colors.red
  //         : rivalInfo.maxRate >= 1000
  //             ? Colors.orange
  //             : rivalInfo.maxRate >= 750
  //                 ? Colors.green
  //                 : Colors.blue;
}
