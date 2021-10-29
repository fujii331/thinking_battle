import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/data/quiz_data.dart';

void commonInitialAction(
  BuildContext context,
) {
  // 初期化
  context.read(bgmProvider).state.stop();
  context.read(currentSkillPointProvider).state = 7;
  context.read(afterMessageTimeProvider).state = 0;
  context.read(alreadyseenQuestionsProvider).state = [];
  context.read(selectableQuestionsProvider).state = [];
  context.read(displayContentListProvider).state = [];
  context.read(answerFailedFlgProvider).state = false;
  context.read(forceQuestionFlgProvider).state = false;
  context.read(spChargeTurnProvider).state = 0;
  context.read(turnCountProvider).state = 0;
  context.read(timerCancelFlgProvider).state = false;
  context.read(myTrapCountProvider).state = 0;
  context.read(enemyTrapCountProvider).state = 0;
}

void trainingInitialAction(
  BuildContext context,
) {
  context.read(enemySkillPointProvider).state = 7;

  final bool precedingFlg = Random().nextInt(2) == 0 ? true : false;
  context.read(precedingFlgProvider).state = precedingFlg;

  final List<List<int>> skillListData = [
    [8, 2, 5],
    [8, 2, 5],
    [8, 2, 5],
    [8, 2, 5],
    [8, 2, 5],
  ];
  final List<int> skillList = skillListData[Random().nextInt(5)];

  context.read(rivalInfoProvider).state = PlayerInfo(
    name: 'CPU',
    rate: 1500.0,
    imageNumber: Random().nextInt(9) + 1,
    cardNumber: Random().nextInt(5) + 1,
    matchedCount: 0,
    continuousWinCount: 0,
    skillList: skillList,
  );

  final Quiz quiz = quizData[Random().nextInt(quizData.length)];
  // 問題を設定
  context.read(quizThemaProvider).state = quiz.thema;
  context.read(allQuestionsProvider).state = quiz.questions;
  context.read(correctAnswersProvider).state = quiz.correctAnswers;
}
