import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/cpu_names.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/data/quiz_data.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/game_playing/update_rate.service.dart';

void commonInitialAction(
  BuildContext context,
) {
  // 初期化
  context.read(bgmProvider).state.stop();
  context.read(currentSkillPointProvider).state = 7;
  context.read(afterMessageTimeProvider).state = 0;
  context.read(afterRivalMessageTimeProvider).state = 0;
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
  context.read(skillUseCountInGameProvider).state = 0;
  context.read(interstitialAdProvider).state = null;
}

Future trainingInitialAction(
  BuildContext context,
) async {
  context.read(enemySkillPointProvider).state = 7;

  // 先行・後攻
  final bool precedingFlg = Random().nextInt(2) == 0 ? true : false;
  context.read(precedingFlgProvider).state = precedingFlg;

  final String cpuName = cpuNames[Random().nextInt(cpuNames.length)];

  final double cpuRate = ((context.read(rateProvider).state -
                  100 +
                  (Random().nextInt(2000) / 10)) *
              10)
          .round() /
      10;

  // レートによって対戦回数・コメント・スキルを調整する
  int matchedCount = Random().nextInt(100);
  final double rateDifference = (cpuRate - 1500).abs();
  int plusMatchedCount = 0;
  if (rateDifference > 1000) {
    plusMatchedCount = 1200;
  } else if (rateDifference > 500) {
    plusMatchedCount = 800;
  } else if (rateDifference > 400) {
    plusMatchedCount = 650;
  } else if (rateDifference > 300) {
    plusMatchedCount = 500;
  } else if (rateDifference > 200) {
    plusMatchedCount = 300;
  } else if (rateDifference > 150) {
    plusMatchedCount = 200;
  } else if (rateDifference > 100) {
    plusMatchedCount = 100;
  } else if (rateDifference > 50) {
    plusMatchedCount = 10;
  }

  matchedCount += plusMatchedCount;

  int continuousWinCount = Random().nextInt(6) != 0 ? 0 : Random().nextInt(5);
  if (continuousWinCount > plusMatchedCount) {
    continuousWinCount = plusMatchedCount;
  }

  List<int> skillList = [1, 2, 3];
  final int skillRandomValue = Random().nextInt(100);
  final int messageRandomValue = Random().nextInt(100);

  List<int> messageIdsList = [1, 2, 3, 4];
  int imageNumber = Random().nextInt(6) + 1;
  int cardNumber = Random().nextInt(4) + 1;

  if (matchedCount < 2) {
    // 何もしない
  } else if (matchedCount < 10) {
    skillList = skillRandomValue < 10
        ? [1, 2, 4]
        : skillRandomValue < 40
            ? [2, 3, 4]
            : skillRandomValue < 60
                ? [1, 2, 3]
                : [1, 3, 4];

    messageIdsList = messageRandomValue < 20
        ? [1, 2, 3, 6]
        : messageRandomValue < 40
            ? [2, 3, 4, 7]
            : messageRandomValue < 60
                ? [2, 3, 4, 9]
                : messageRandomValue < 80
                    ? [2, 3, 10, 11]
                    : [1, 2, 3, 10];

    imageNumber = Random().nextInt(9) + 1;
    cardNumber = Random().nextInt(6) + 1;
  } else if (matchedCount < 100) {
    skillList = skillRandomValue < 20
        ? [1, 2, 4]
        : skillRandomValue < 40
            ? [1, 2, 5]
            : skillRandomValue < 60
                ? [2, 4, 5]
                : skillRandomValue < 75
                    ? [1, 3, 4]
                    : skillRandomValue < 90
                        ? [1, 2, 7]
                        : [2, 4, 7];

    messageIdsList = messageRandomValue < 20
        ? [1, 2, 6, 7]
        : messageRandomValue < 40
            ? [2, 3, 8, 11]
            : messageRandomValue < 60
                ? [2, 4, 16, 17]
                : messageRandomValue < 80
                    ? [2, 6, 7, 19]
                    : [1, 2, 3, 4];

    imageNumber = Random().nextInt(15) + 1;
    cardNumber = Random().nextInt(15) + 1;
  } else {
    skillList = skillRandomValue < 10
        ? [1, 2, 4]
        : skillRandomValue < 20
            ? [1, 4, 5]
            : skillRandomValue < 30
                ? [2, 3, 4]
                : skillRandomValue < 40
                    ? [2, 4, 5]
                    : skillRandomValue < 50
                        ? [4, 6, 7]
                        : skillRandomValue < 60
                            ? [4, 5, 6]
                            : skillRandomValue < 70
                                ? [2, 4, 7]
                                : skillRandomValue < 80
                                    ? [2, 4, 6]
                                    : skillRandomValue < 90
                                        ? [1, 2, 7]
                                        : [1, 3, 7];

    messageIdsList = [
      Random().nextInt(20) + 1,
      Random().nextInt(20) + 1,
      Random().nextInt(20) + 1,
      Random().nextInt(20) + 1
    ];

    imageNumber = Random().nextInt(20) + 1;
    cardNumber = Random().nextInt(20) + 1;
  }

  if (plusMatchedCount > 1600 && Random().nextInt(10) == 0) {
    skillList = skillRandomValue < 20
        ? [3, 7, 8]
        : skillRandomValue < 40
            ? [2, 5, 8]
            : skillRandomValue < 60
                ? [6, 7, 8]
                : skillRandomValue < 80
                    ? [1, 2, 8]
                    : [2, 4, 8];
  }

  context.read(rivalInfoProvider).state = PlayerInfo(
    name: cpuName,
    rate: cpuRate,
    imageNumber: imageNumber,
    cardNumber: cardNumber,
    matchedCount: matchedCount,
    continuousWinCount: continuousWinCount,
    skillList: skillList,
  );

  context.read(cpuMessageIdsListProvider).state = messageIdsList;

  final int messageLevelRandomValue = Random().nextInt(100);

  context.read(messageLevelProvider).state = messageLevelRandomValue < 20
      ? 1
      : messageLevelRandomValue < 80
          ? 2
          : 3;

  final int skillUseLevelRandomValue = Random().nextInt(100);

  context.read(skillUseLevelProvider).state = skillUseLevelRandomValue < 20
      ? 1
      : messageLevelRandomValue < 75
          ? 2
          : 3;

  // 問題を設定
  final Quiz quiz = quizData[Random().nextInt(quizData.length)];
  context.read(quizThemaProvider).state = quiz.thema;
  context.read(allQuestionsProvider).state = quiz.questions;
  context.read(correctAnswersProvider).state = quiz.correctAnswers;
  context.read(wrongAnswersProvider).state = quiz.wrongAnswers;
  context.read(answerCandidateProvider).state = quiz.answerCandidate;

  // 負けた場合のレートを登録
  final double failedRate = getNewRate(
    context.read(rateProvider).state,
    cpuRate,
    false,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('failedRate', failedRate);
}

void tutorialTrainingInitialAction(
  BuildContext context,
) {
  context.read(enemySkillPointProvider).state = 7;
  context.read(cpuMessageIdsListProvider).state = [0, 0, 0, 0];

  context.read(precedingFlgProvider).state = true;

  context.read(rivalInfoProvider).state = const PlayerInfo(
    name: '練習くん',
    rate: 1000.0,
    imageNumber: 1,
    cardNumber: 1,
    matchedCount: 0,
    continuousWinCount: 0,
    skillList: [1, 2, 3],
  );
  context.read(skillUseLevelProvider).state = 2;

  final Quiz quiz = quizData[15];
  // 問題を設定
  context.read(quizThemaProvider).state = quiz.thema;
  context.read(allQuestionsProvider).state = quiz.questions;
  context.read(correctAnswersProvider).state = quiz.correctAnswers;
  context.read(wrongAnswersProvider).state = quiz.wrongAnswers;
  context.read(answerCandidateProvider).state = quiz.answerCandidate;
}
