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
) async {
  final List<Question> allQuestions = [
    ...context.read(allQuestionsProvider).state
  ];

  allQuestions.shuffle();
  // 表示リスト
  List<DisplayContent> displayContentList =
      context.read(displayContentListProvider).state;
  // ターン数
  int cpuTurn = (displayContentList.length ~/ 2) + 1;
  // スキル
  List<int> enemySkills = context.read(rivalInfoProvider).state.skillList;
  // 的情報
  PlayerInfo rivalInfo = context.read(rivalInfoProvider).state;
  // スキルポイント
  int enemySkillPoint = context.read(enemySkillPointProvider).state;
  // 重要度
  int sumImportance = 0;
  // 質問隠しか嘘つきが出たかどうか
  bool searchFlg = false;

  int returnQuestionId = 0;
  String returnAnswer = '';
  List<int> returnSkillIds = [];

  for (DisplayContent displayContent in displayContentList) {
    if (displayContent.skillIds.contains(4)) {
      sumImportance -= displayContent.importance;
      searchFlg = true;
    } else if (!displayContent.skillIds.contains(1)) {
      sumImportance +=
          displayContent.importance * displayContent.importance == 4
              ? 3
              : displayContent.importance;
    } else {
      searchFlg = true;
    }
  }

  List<Question> questions = [];

  // 強制質問されていない場合
  if (displayContentList.isNotEmpty &&
      !displayContentList.last.skillIds.contains(3)) {
    if (sumImportance >= (60 - rivalInfo.rate / 100)) {
      // 重要度が溜まっていたら解答
      // 相手のレートによって応える早さが変わる
      returnAnswer = context.read(correctAnswersProvider).state[0];
    } else if (cpuTurn > 4 && Random().nextInt(3) > 0) {
      // 2/3の確率でスキル使用判断
      List<int> usingSkills = [];

      final List<int> enemySkillsCandidate = enemySkills
          .where((skillId) => skillId != 6 && (searchFlg || skillId != 5))
          .toList();

      // 質問候補が2つの場合でナイス質問を含み、質問調査を含まず、スキルポイントが溜まっている場合
      if (enemySkillsCandidate.length == 2 &&
          enemySkillsCandidate.contains(2) &&
          !enemySkillsCandidate.contains(5) &&
          enemySkillPoint >=
              skillSettings[enemySkillsCandidate[0] - 1].skillPoint +
                  skillSettings[enemySkillsCandidate[1] - 1].skillPoint) {
        usingSkills = enemySkillsCandidate;
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

        // ナイス質問を含み、質問調査を含まず、スキルポイントが溜まっている場合
        if (skillsCombination.contains(2) &&
            !skillsCombination.contains(5) &&
            enemySkillPoint >=
                skillSettings[skillsCombination[0] - 1].skillPoint +
                    skillSettings[skillsCombination[1] - 1].skillPoint) {
          usingSkills = skillsCombination;
        }
      }

      // スキルを同時に使わなかった場合、かつ、1/2の確率でスキル単体使用
      if (usingSkills.isEmpty && Random().nextInt(2) == 0) {
        final int targetSkillId =
            enemySkillsCandidate[Random().nextInt(enemySkillsCandidate.length)];

        if (enemySkillPoint >= skillSettings[targetSkillId - 1].skillPoint) {
          usingSkills = [targetSkillId];
        }
      }

      // ナイス質問を行なった場合
      if (usingSkills.contains(2)) {
        returnQuestionId = getNiceQuestion(
          context,
          allQuestions,
        );
        returnSkillIds = usingSkills;
      } else {
        questions = getCpuQuestion(
          context,
          cpuTurn,
        );

        returnQuestionId = questions[0].id;
        if (!usingSkills.contains(1) ||
            !usingSkills.contains(3) ||
            questions[0].importance != 1) {
          returnSkillIds = usingSkills;
        }
      }

      context.read(enemySkillPointProvider).state += 1;
    } else {
      questions = getCpuQuestion(
        context,
        cpuTurn,
      );

      returnQuestionId = questions[0].id;
      context.read(enemySkillPointProvider).state += 1;
    }
  } else {
    questions = getCpuQuestion(
      context,
      cpuTurn,
    );

    returnQuestionId = questions[0].id;
    context.read(enemySkillPointProvider).state += 1;
  }

  await Future.delayed(
    Duration(
        seconds:
            cpuTurn < 6 ? 3 + Random().nextInt(3) : 5 + Random().nextInt(6)),
  );

  final SendContent sendContent = SendContent(
    questionId: returnQuestionId,
    answer: returnAnswer,
    skillIds: returnSkillIds,
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
