import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math';

import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/services/game_playing/get_nice_question.service.dart';

import 'package:thinking_battle/data/skills.dart';

Future cpuAction(
  BuildContext context,
  ScrollController scrollController,
  AudioCache soundEffect,
  double seVolume,
  bool disconnectedActionFlg,
) async {
  final List<Question> allQuestions = [
    ...context.read(allQuestionsProvider).state
  ];

  allQuestions.shuffle();
  // 表示リスト
  final List<DisplayContent> displayContentList =
      context.read(displayContentListProvider).state;
  // ターン数
  final int cpuTurn = (displayContentList.length ~/ 2) + 1;
  // スキル
  final List<int> enemySkills = context.read(rivalInfoProvider).state.skillList;
  // 的情報
  final PlayerInfo rivalInfo = context.read(rivalInfoProvider).state;
  // スキルポイント
  final int enemySkillPoint = context.read(enemySkillPointProvider).state;
  // トレーニングステータス
  final int trainingStatus = context.read(trainingStatusProvider).state;
  // スキル使用レベル
  final int skillUseLevel = context.read(skillUseLevelProvider).state;

  // 重要度
  int sumImportance = 0;
  // 質問隠しか嘘つきが出たかどうか
  bool searchFlg = false;

  int returnQuestionId = 0;
  String returnAnswer = '';
  List<int> returnSkillIds = [];
  int returnMessageId = 0;

  final double finishImportance = (60 - (rivalInfo.rate / 90));

  final bool gotMessageFlg = displayContentList.isEmpty
      ? false
      : displayContentList.last.messageId != 0;

  if (!disconnectedActionFlg) {
    // 経過時間にランダム性を出す
    await Future.delayed(
      Duration(
        seconds: cpuTurn < 6
            ? 4 + Random().nextInt(4)
            : Random().nextInt(15) == 0
                ? 15 + Random().nextInt(5)
                : cpuTurn < 12
                    ? 6 + Random().nextInt(6)
                    : 8 + Random().nextInt(5),
      ),
    );
  }

  // CPUのメッセージ時間
  int afterRivalMessageTime = context.read(afterRivalMessageTimeProvider).state;

  for (DisplayContent displayContent in displayContentList) {
    if ((displayContent.skillIds.contains(4) && !displayContent.myTurnFlg) ||
        (displayContent.skillIds.contains(108) && displayContent.myTurnFlg)) {
      // 相手のターンに嘘つきを使ったか、自分の前の相手のターンにトラップを使われたか
      sumImportance -= displayContent.importance;
      searchFlg = true;
    } else if (displayContent.skillIds.contains(1) &&
        !displayContent.myTurnFlg) {
      searchFlg = true;
    } else {
      sumImportance +=
          displayContent.importance * displayContent.importance == 4
              ? 3
              : displayContent.importance;
    }
  }

  List<Question> questions = [];

  // 前回解答実行フラグ
  final bool previousAnsweredFlg = displayContentList.length > 1 &&
      displayContentList[displayContentList.length - 2].answerFlg == true;

  // 強制質問されていない場合
  if (displayContentList.isNotEmpty &&
      !displayContentList.last.skillIds.contains(3)) {
    if (sumImportance >= finishImportance && !previousAnsweredFlg) {
      // 重要度が溜まっていたら解答
      // 相手のレートによって応える早さが変わる
      final List<String> correctAnswerList =
          context.read(correctAnswersProvider).state;
      returnAnswer = correctAnswerList[Random().nextInt(10) == 0
          ? 0
          : Random().nextInt(correctAnswerList.length)];
    } else if (trainingStatus >= 3 &&
        sumImportance >= finishImportance * 0.8 &&
        Random().nextInt(10) == 0 &&
        context.read(wrongAnswersProvider).state.length > 1 &&
        !previousAnsweredFlg) {
      final List<String> wrongAnswerList = [
        ...context.read(wrongAnswersProvider).state
      ];
      final int target = Random().nextInt(wrongAnswerList.length);

      // 誤答を設定
      returnAnswer = wrongAnswerList[target];

      // 解答した誤答を削除
      wrongAnswerList.removeAt(target);
      context.read(wrongAnswersProvider).state = wrongAnswerList;
    } else if (skillUseLevel == 1 ||
        (skillUseLevel == 2 && Random().nextInt(3) > 0) ||
        (skillUseLevel == 3 && Random().nextInt(3) == 0)) {
      final List<int> enemySkillsCandidate = enemySkills
          .where((skillId) =>
              skillId != 6 && (searchFlg || (skillId != 5 && skillId != 7)))
          .toList();

      // 質問候補が2つの場合でナイス質問を含み、質問サーチ・質問確認・トラップを含まず、スキルポイントが溜まっている場合
      if (enemySkillsCandidate.length == 2 &&
          enemySkillsCandidate.contains(2) &&
          !enemySkillsCandidate.contains(5) &&
          !enemySkillsCandidate.contains(6) &&
          !enemySkillsCandidate.contains(7) &&
          !enemySkillsCandidate.contains(8) &&
          enemySkillPoint >=
              skillSettings[enemySkillsCandidate[0] - 1].skillPoint +
                  skillSettings[enemySkillsCandidate[1] - 1].skillPoint) {
        returnSkillIds = enemySkillsCandidate;
      } else if (enemySkillsCandidate.length == 3) {
        // 質問候補が3つの場合
        final int randomNum = Random().nextInt(3);
        final List<int> skillsCombination = [
          randomNum == 2
              ? enemySkillsCandidate[0]
              : enemySkillsCandidate[randomNum],
          randomNum == 2
              ? enemySkillsCandidate[2]
              : enemySkillsCandidate[randomNum + 1]
        ];

        // ナイス質問を含み、質問サーチ・質問確認・SP溜め・トラップを含まず、スキルポイントが溜まっている場合
        if (((skillsCombination.contains(2) &&
                    !skillsCombination.contains(5) &&
                    !skillsCombination.contains(6) &&
                    !skillsCombination.contains(7) &&
                    !skillsCombination.contains(8)) ||
                (!skillsCombination.contains(1) &&
                    !skillsCombination.contains(2) &&
                    !skillsCombination.contains(3) &&
                    (skillUseLevel == 1 ||
                        (skillUseLevel == 2 && Random().nextInt(2) == 0) ||
                        (skillUseLevel == 3 && Random().nextInt(3) == 0)))) &&
            enemySkillPoint >=
                skillSettings[skillsCombination[0] - 1].skillPoint +
                    skillSettings[skillsCombination[1] - 1].skillPoint) {
          returnSkillIds = skillsCombination;
        }
      }

      // スキルを同時に使わなかった場合
      if (returnSkillIds.isEmpty &&
          (skillUseLevel == 1 ||
              (skillUseLevel == 2 && Random().nextInt(2) == 0) ||
              (skillUseLevel == 3 && Random().nextInt(3) > 0))) {
        final int targetSkillId =
            enemySkillsCandidate[Random().nextInt(enemySkillsCandidate.length)];

        if (enemySkillPoint >= skillSettings[targetSkillId - 1].skillPoint &&
            targetSkillId != 2 &&
            (targetSkillId != 6 || enemySkillPoint < 8)) {
          returnSkillIds = [targetSkillId];
        }
      }

      // 仮で質問を取得
      questions = getCpuQuestion(
        context,
        cpuTurn,
      );

      // スキルを使っていても条件によってはスキルを取り除く
      // 質問隠しを使っていて、ナイス質問を使っていないかつ質問重要度が1の場合
      // 強制質問を使っていて、質問重要度が80%より小さい場合
      // 5ターン以内でSP溜めを使っていなくて2/3の確率
      if ((returnSkillIds.contains(1) &&
              !returnSkillIds.contains(2) &&
              questions[0].importance == 1) ||
          (returnSkillIds.contains(3) &&
              (sumImportance < finishImportance * 0.8 ||
                  !returnSkillIds.contains(2))) ||
          (cpuTurn < 5 &&
              !returnSkillIds.contains(6) &&
              skillUseLevel != 1 &&
              Random().nextInt(3) > 0)) {
        returnSkillIds = [];
      }

      // ナイス質問を行なった場合
      if (returnSkillIds.contains(2)) {
        returnQuestionId = getNiceQuestion(
          context,
          allQuestions,
        );
      } else {
        returnQuestionId = questions[0].id;
      }
    } else {
      questions = getCpuQuestion(
        context,
        cpuTurn,
      );

      returnQuestionId = questions[0].id;
    }
  } else {
    questions = getCpuQuestion(
      context,
      cpuTurn,
    );

    returnQuestionId = questions[0].id;
  }

  // メッセージの設定
  // 相手がランダムマッチで接続切れではなく、メッセージを送ってから60秒経っている場合
  if (trainingStatus >= 3 && afterRivalMessageTime == 0) {
    returnMessageId = getCpuMessageId(
      context,
      cpuTurn,
      gotMessageFlg,
    );
  }

  final SendContent sendContent = SendContent(
    questionId: returnQuestionId,
    answer: returnAnswer,
    skillIds: returnSkillIds,
    messageId: returnMessageId,
  );

  turnAction(
    context,
    sendContent,
    false,
    scrollController,
    soundEffect,
    seVolume,
    null,
  );
}

List<Question> getCpuQuestion(
  BuildContext context,
  int cpuTurn,
) {
  final List<Question> allQuestions = [
    ...context.read(allQuestionsProvider).state
  ];

  allQuestions.shuffle();

  // 重要度1
  List<Question> importance1Questions =
      allQuestions.where((question) => question.importance == 1).toList();
  // 重要度2
  List<Question> importance2Questions =
      allQuestions.where((question) => question.importance == 2).toList();
  // 重要度3
  List<Question> importance3Questions =
      allQuestions.where((question) => question.importance == 3).toList();

  List<Question> getQuestions;

  // 質問候補の取得
  if (importance1Questions.length < 3 ||
      importance2Questions.length < 3 ||
      importance3Questions.length < 3) {
    // 完全ランダムで取ってくる
    getQuestions = allQuestions.sublist(0, 3);

    return getQuestions;
  } else {
    getQuestions = getNextQuestions(
      context,
      importance1Questions,
      importance2Questions,
      importance3Questions,
      cpuTurn,
    );

    return getQuestions;
  }
}

int getCpuMessageId(
  BuildContext context,
  int cpuTurn,
  bool gotMessageFlg,
) {
  final List<int> cpuMessageIdsList =
      context.read(cpuMessageIdsListProvider).state;
  final int messageLevel = context.read(messageLevelProvider).state;

  if (cpuTurn == 1 || (cpuTurn == 2 && gotMessageFlg)) {
    if (messageLevel == 1 ||
        (gotMessageFlg &&
            (messageLevel == 2 ||
                (messageLevel == 3 && Random().nextInt(3) == 0)))) {
      return cpuMessageIdsList.contains(1)
          ? 1
          : cpuMessageIdsList.contains(4)
              ? 4
              : cpuMessageIdsList.contains(9)
                  ? 9
                  : cpuMessageIdsList.contains(10)
                      ? 10
                      : cpuMessageIdsList[Random().nextInt(4)];
    } else {
      return 0;
    }
  } else {
    int messageId = cpuMessageIdsList[Random().nextInt(4)];
    if ([1, 4, 9].contains(messageId)) {
      return 0;
    }

    if (gotMessageFlg) {
      if (messageLevel <= 2 || Random().nextInt(3) == 0) {
        return messageId;
      }
    } else if ((messageLevel == 1 && Random().nextInt(2) == 0) ||
        (messageLevel == 2 && Random().nextInt(10) == 0)) {
      return messageId;
    }

    return 0;
  }
}
