import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/services/game_playing/failed_connect.service.dart';
import 'package:thinking_battle/services/game_playing/get_nice_question.service.dart';

import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/skill_modal.widget.dart';

class QuestionModal extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;

  const QuestionModal({
    Key? key,
    required this.screenContext,
    required this.scrollController,
    required this.myActionDoc,
    required this.rivalListenSubscription,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int selectQuestionId = context.read(selectQuestionIdProvider).state;
    final List<Question> selectableQuestions =
        context.read(selectableQuestionsProvider).state;
    final List<int> selectSkillIds = context.read(selectSkillIdsProvider).state;
    final bool forceQuestionFlg = context.read(forceQuestionFlgProvider).state;

    final List<Widget> skillList = [];

    final changeFlgState = useState(false);

    for (int skillId in selectSkillIds) {
      skillList.add(
        Container(
          padding: const EdgeInsets.only(
            left: 12,
            right: 2,
          ),
          // width: double.infinity,
          child: Text(
            skillSettings[skillId - 1].skillName,
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.orange.shade900,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          left: 5,
          right: 5,
          bottom: 25,
        ),
        width: MediaQuery.of(context).size.width * 0.8 > 600.0
            ? 600.0
            : MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                const Spacer(),
                IconButton(
                  iconSize: 28,
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const Text(
              '質問をタップして選択',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: skillList,
            ),
            const SizedBox(height: 10),
            selectSkillIds.contains(2)
                ? _niceQuestionButton(context)
                : _selectQuestionColumn(
                    context,
                    selectableQuestions,
                    soundEffect,
                    seVolume,
                    selectQuestionId,
                    changeFlgState,
                  ),
            const SizedBox(height: 20),
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text('スキル'),
                      style: ElevatedButton.styleFrom(
                        primary: !forceQuestionFlg
                            ? Colors.green.shade600
                            : Colors.green.shade200,
                        textStyle: Theme.of(context).textTheme.button,
                        padding: const EdgeInsets.only(
                          bottom: 3,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          width: 2,
                          color: Colors.green.shade700,
                        ),
                      ),
                      onPressed: !forceQuestionFlg
                          ? () {
                              soundEffect.play(
                                'sounds/tap.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled:
                                    true, //trueにしないと、Containerのheightが反映されない
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15)),
                                ),
                                builder: (BuildContext context) {
                                  return SkillModal(
                                    changeFlgState: changeFlgState,
                                  );
                                },
                              );
                            }
                          : () {},
                    ),
                  ),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text('質問する'),
                      style: ElevatedButton.styleFrom(
                        primary:
                            selectQuestionId != 0 || selectSkillIds.contains(2)
                                ? Colors.blue.shade600
                                : Colors.blue.shade200,
                        padding: const EdgeInsets.only(
                          bottom: 3,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          width: 2,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      onPressed: myTurnFlg &&
                              (selectQuestionId != 0 ||
                                  selectSkillIds.contains(2))
                          ? () async {
                              context.read(myTurnFlgProvider).state = false;

                              soundEffect.play(
                                'sounds/tap.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );
                              int sendQuestionId = selectQuestionId;

                              if (selectSkillIds.contains(2)) {
                                final List<Question> allQuestions = [
                                  ...context.read(allQuestionsProvider).state
                                ];

                                allQuestions.shuffle();

                                sendQuestionId = getNiceQuestion(
                                  context,
                                  allQuestions,
                                );
                              }

                              final messageId =
                                  context.read(selectMessageIdProvider).state;

                              // 通信対戦時は相手にデータを送る
                              if (myActionDoc != null) {
                                await myActionDoc!
                                    .set({
                                      'questionId': sendQuestionId,
                                      'answer': '',
                                      'skillIds': selectSkillIds,
                                      'messageId': messageId,
                                    })
                                    .timeout(const Duration(seconds: 5))
                                    .onError((error, stackTrace) {
                                      rivalListenSubscription!.cancel();
                                      failedConnect(context);
                                    });
                              }

                              final sendContent = SendContent(
                                questionId: sendQuestionId,
                                answer: '',
                                skillIds: selectSkillIds,
                                messageId: messageId,
                              );
                              // ターン行動実行
                              turnAction(
                                screenContext,
                                sendContent,
                                true,
                                scrollController,
                                soundEffect,
                                seVolume,
                                rivalListenSubscription,
                              );

                              Navigator.pop(context);
                            }
                          : () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectQuestionColumn(
    BuildContext context,
    List<Question> selectableQuestions,
    AudioCache soundEffect,
    double seVolume,
    int selectQuestionId,
    ValueNotifier<bool> changeFlgState,
  ) {
    return Column(
      children: [
        _selectQuestionButton(
          context,
          selectableQuestions[0],
          soundEffect,
          seVolume,
          selectableQuestions[0].id == selectQuestionId,
          changeFlgState,
        ),
        _selectQuestionButton(
          context,
          selectableQuestions[1],
          soundEffect,
          seVolume,
          selectableQuestions[1].id == selectQuestionId,
          changeFlgState,
        ),
        _selectQuestionButton(
          context,
          selectableQuestions[2],
          soundEffect,
          seVolume,
          selectableQuestions[2].id == selectQuestionId,
          changeFlgState,
        ),
      ],
    );
  }

  Widget _selectQuestionButton(
    BuildContext context,
    Question targetQuestion,
    AudioCache soundEffect,
    double seVolume,
    bool selectedFlg,
    ValueNotifier<bool> changeFlgState,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 8,
        right: 8,
      ),
      width: double.infinity,
      height: 45,
      child: ElevatedButton(
        onPressed: () {
          context.read(selectQuestionIdProvider).state = targetQuestion.id;
          changeFlgState.value = !changeFlgState.value;
        },
        child: Text(
          targetQuestion.asking,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'NotoSerif',
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: selectedFlg ? Colors.yellow.shade200 : Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
        ),
      ),
    );
  }

  Widget _niceQuestionButton(
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 8,
        right: 8,
      ),
      height: 135,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              '？？？（ナイスな質問）',
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange.shade800,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow.shade200,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              textStyle: Theme.of(context).textTheme.button,
            ),
          ),
        ),
      ),
    );
  }
}
