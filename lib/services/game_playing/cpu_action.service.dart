import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:math';

import 'package:thinking_battle/models/display_content.model.dart';
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
) async {
  final List<Question> allQuestions = context.read(allQuestionsProvider).state;

  allQuestions.shuffle();
  // 表示リスト
  List<DisplayContent> displayContentList =
      context.read(displayContentListProvider).state;
  // ターン数
  int cpuTurn = (displayContentList.length ~/ 2) + 1;
  // スキル
  List<int> enemySkills = context.read(enemySkillsProvider).state;
  // スキルポイント
  int enemySkillPoint = context.read(enemySkillPointProvider).state;
  // 重要度
  int sumImportance = context.read(sumImportanceProvider).state;

  SendContent sendContent;

  List<Question> questions = [];

  // スキル用ランダム
  final int skillRandom = Random().nextInt(3);

  bool endFlg = false;

  if (!displayContentList.last.skillIds.contains(3)) {
    if (Random().nextInt(2) == 0 &&
        enemySkills[0] == 1 &&
        enemySkillPoint >=
            skillSettings[enemySkills[0] - 1].skillPoint +
                skillSettings[enemySkills[1] - 1].skillPoint) {
      final List returnValues = getNiceQuestion(
        context,
        allQuestions,
      );

      // 重要度の合計を更新
      sumImportance += allQuestions
          .where((question) => question.id == returnValues[0])
          .toList()[0]
          .importance;

      enemySkillPoint += 1;

      endFlg = returnValues[1];

      sendContent = SendContent(
        questionId: returnValues[0],
        answer: '',
        skillIds: [enemySkills[0], enemySkills[1]],
      );
    } else if (Random().nextInt(2) == 0 &&
        enemySkills[0] == 2 &&
        enemySkillPoint >=
            skillSettings[enemySkills[0] - 1].skillPoint +
                skillSettings[enemySkills[2] - 1].skillPoint) {
      final List returnValues = getNiceQuestion(
        context,
        allQuestions,
      );

      // 重要度の合計を更新
      sumImportance += allQuestions
          .where((question) => question.id == returnValues[0])
          .toList()[0]
          .importance;

      enemySkillPoint += 1;

      endFlg = returnValues[1];

      sendContent = SendContent(
        questionId: returnValues[0],
        answer: '',
        skillIds: [enemySkills[0], enemySkills[2]],
      );
    } else if (Random().nextInt(3) == 0 &&
        enemySkillPoint >=
            skillSettings[enemySkills[skillRandom] - 1].skillPoint) {
      if (enemySkills[skillRandom] == 2) {
        final List returnValues = getNiceQuestion(
          context,
          allQuestions,
        );

        // 重要度の合計を更新
        sumImportance += allQuestions
            .where((question) => question.id == returnValues[0])
            .toList()[0]
            .importance;

        endFlg = returnValues[1];

        enemySkillPoint += 1;

        sendContent = SendContent(
          questionId: returnValues[0],
          answer: '',
          skillIds: [2],
        );
      } else {
        questions = getCpuQuestion(
          context,
          cpuTurn,
        );

        sendContent = SendContent(
          questionId: questions[0].id,
          answer: '',
          skillIds: [enemySkills[skillRandom]],
        );
      }
    } else if (sumImportance >= 45) {
      sendContent = SendContent(
        questionId: 0,
        answer: context.read(correctAnswersProvider).state[0],
        skillIds: [],
      );
    } else {
      questions = getCpuQuestion(
        context,
        cpuTurn,
      );

      // 重要度の合計を更新
      sumImportance += questions[0].importance;

      sendContent = SendContent(
        questionId: questions[0].id,
        answer: '',
        skillIds: [],
      );
    }
  } else {
    questions = getCpuQuestion(
      context,
      cpuTurn,
    );

    sendContent = SendContent(
      questionId: questions[0].id,
      answer: '',
      skillIds: [],
    );
  }

  await Future.delayed(
    Duration(seconds: 6 + Random().nextInt(7)),
  );

  turnAction(
    context,
    sendContent,
    false,
    scrollController,
    endFlg,
    soundEffect,
    seVolume,
  );
}

List<Question> getCpuQuestion(
  BuildContext context,
  int cpuTurn,
) {
  // スキルポイント
  context.read(enemySkillPointProvider).state += 1;

  final List<Question> allQuestions = context.read(allQuestionsProvider).state;

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

    // 重要度の合計を更新
    context.read(sumImportanceProvider).state += getQuestions[0].importance;

    return getQuestions;
  } else {
    getQuestions = getNextQuestions(
      context,
      importance1Questions,
      importance2Questions,
      importance3Questions,
      cpuTurn,
    );

    // 重要度の合計を更新
    context.read(sumImportanceProvider).state += getQuestions[0].importance;

    return getQuestions;
  }
}
