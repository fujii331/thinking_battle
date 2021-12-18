import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/display_content.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/services/game_playing/failed_connect.service.dart';
import 'package:thinking_battle/services/game_playing/get_nice_question.service.dart';

import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/skill_modal.widget.dart';

class QuestionModalContent extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;
  final int selectQuestionId;
  final List<Question> selectableQuestions;
  final List<int> selectSkillIds;
  final bool forceQuestionFlg;
  final ValueNotifier<bool> changeFlgState;
  final ValueNotifier<bool> displayUpdateFlgState;

  const QuestionModalContent({
    Key? key,
    required this.screenContext,
    required this.scrollController,
    required this.myActionDoc,
    required this.rivalListenSubscription,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
    required this.selectQuestionId,
    required this.selectableQuestions,
    required this.selectSkillIds,
    required this.forceQuestionFlg,
    required this.changeFlgState,
    required this.displayUpdateFlgState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> skillList = [];

    final double paddingWidth = MediaQuery.of(context).size.width > 550.0
        ? (MediaQuery.of(context).size.width - 550) / 2
        : 5;

    final bool widthOk = MediaQuery.of(context).size.width > 350;
    final double fontSize = widthOk ? 19.5 : 17.5;

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
        padding: EdgeInsets.only(
          left: paddingWidth,
          right: paddingWidth,
          bottom: 25,
        ),
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
                ? _niceQuestionButton(context, fontSize)
                : _selectQuestionColumn(
                    context,
                    selectableQuestions,
                    soundEffect,
                    seVolume,
                    selectQuestionId,
                    changeFlgState,
                    fontSize,
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
                        padding: EdgeInsets.only(
                          bottom: Platform.isAndroid ? 3 : 1,
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
                                    soundEffect: soundEffect,
                                    seVolume: seVolume,
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
                        padding: EdgeInsets.only(
                          bottom: Platform.isAndroid ? 3 : 1,
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
                                  context.read(turnCountProvider).state,
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
                                displayUpdateFlgState,
                              );

                              Navigator.pop(context);
                            }
                          : () {},
                    ),
                  ),
                ],
              ),
            ),
            Platform.isAndroid ? Container() : const SizedBox(height: 8),
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
    double fontSize,
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
          fontSize,
        ),
        _selectQuestionButton(
          context,
          selectableQuestions[1],
          soundEffect,
          seVolume,
          selectableQuestions[1].id == selectQuestionId,
          changeFlgState,
          fontSize,
        ),
        _selectQuestionButton(
          context,
          selectableQuestions[2],
          soundEffect,
          seVolume,
          selectableQuestions[2].id == selectQuestionId,
          changeFlgState,
          fontSize,
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
    double fontSize,
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
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: selectedFlg ? Colors.yellow.shade200 : Colors.white,
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 3.5,
            bottom: 6,
          ),
        ),
      ),
    );
  }

  Widget _niceQuestionButton(
    BuildContext context,
    double fontSize,
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
                fontSize: fontSize,
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
