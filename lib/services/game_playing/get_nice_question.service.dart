import 'package:flutter/material.dart';

import 'package:thinking_battle/models/quiz.model.dart';

int getNiceQuestion(
  BuildContext context,
  List<Question> allQuestions,
  int turnCount,
) {
  // ナイス質問
  // 10ターン以上ならクリティカルな質問が出るようになる
  final importantQuestions = turnCount > 10
      ? allQuestions.where((question) => question.importance > 2).toList()
      : allQuestions.where((question) => question.importance == 3).toList();

  // 重要な質問がない場合
  if (importantQuestions.isEmpty) {
    // 重要度2の質問
    final importance2Questions =
        allQuestions.where((question) => question.importance == 2).toList();
    if (importance2Questions.isEmpty) {
      return allQuestions.first.id;
    } else {
      return importance2Questions.first.id;
    }
  } else {
    return importantQuestions.first.id;
  }
}
