import 'package:flutter/material.dart';

import 'package:thinking_battle/models/quiz.model.dart';

List getNiceQuestion(
  BuildContext context,
  List<Question> allQuestions,
) {
  // ナイス質問
  final importantQuestions =
      allQuestions.where((question) => question.importance > 2).toList();

  // 重要な質問がない場合
  if (importantQuestions.isEmpty) {
    // 重要度2の質問
    final importance2Questions =
        allQuestions.where((question) => question.importance == 2).toList();
    if (importance2Questions.isEmpty) {
      return [allQuestions.first.id, true];
    } else {
      return [importance2Questions.first.id, false];
    }
  } else {
    return [importantQuestions.first.id, false];
  }
}
