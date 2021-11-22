import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/game.provider.dart';

class AnswerCandidateModal extends HookWidget {
  const AnswerCandidateModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> answerCandidate =
        useProvider(answerCandidateProvider).state;

    List<Widget> answerCandidateList = [];

    for (String answer in answerCandidate) {
      // 画像をcardListに追加
      answerCandidateList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            answer,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 15,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '解答候補一覧',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: answerCandidateList,
          ),
        ],
      ),
    );
  }
}
