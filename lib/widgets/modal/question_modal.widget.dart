import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/services/common_action.service.dart';
import 'package:thinking_battle/services/get_nice_question.service.dart';

import 'package:thinking_battle/skills.dart';
import 'package:thinking_battle/widgets/modal/skill_modal.widget.dart';

class QuestionModal extends HookWidget {
  final ScrollController scrollController;

  // ignore: use_key_in_widget_constructors
  const QuestionModal(
    this.scrollController,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int selectQuestionId = useProvider(selectQuestionIdProvider).state;
    final List<Question> selectableQuestions =
        useProvider(selectableQuestionsProvider).state;
    final List<int> selectSkillIds = useProvider(selectSkillIdsProvider).state;
    final bool forceQuestionFlg = useProvider(forceQuestionFlgProvider).state;
    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;

    final List<Widget> skillList = [];

    for (int skillId in selectSkillIds) {
      skillList.add(
        Text(
          skillSettings[skillId - 1].skillName + '　',
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.red,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      width: MediaQuery.of(context).size.width * 0.9 > 600.0
          ? 600.0
          : MediaQuery.of(context).size.width * 0.9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            iconSize: 28,
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              soundEffect.play(
                'sounds/cancel.mp3',
                isNotification: true,
                volume: seVolume,
              );
              Navigator.pop(context);
            },
          ),
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              '質問をタップして選択',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(children: skillList),
          const SizedBox(height: 30),
          selectSkillIds.contains(2)
              ? _niceQuestionButton(context)
              : _selectQuestionColumn(
                  context,
                  selectableQuestions,
                  soundEffect,
                  seVolume,
                  selectQuestionId,
                ),
          const SizedBox(height: 30),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text(
                    'スキル',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: !forceQuestionFlg
                        ? Colors.green.shade100
                        : Colors.green.shade400,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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
                                return SkillModal([
                                  ...context.read(selectSkillIdsProvider).state
                                ]);
                              });
                        }
                      : () {},
                ),
                ElevatedButton(
                  child: const Text(
                    '質問する',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: selectQuestionId != 0 || selectSkillIds.contains(2)
                        ? Colors.blue.shade500
                        : Colors.blue.shade200,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: myTurnFlg &&
                          (selectQuestionId != 0 || selectSkillIds.contains(2))
                      ? () {
                          context.read(myTurnFlgProvider).state = false;

                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          int sendQuestionId = selectQuestionId;

                          bool endFlg = false;

                          if (selectSkillIds.contains(2)) {
                            final List<Question> allQuestions =
                                context.read(allQuestionsProvider).state;

                            allQuestions.shuffle();

                            final List returnValues = getNiceQuestion(
                              context,
                              allQuestions,
                            );

                            sendQuestionId = returnValues[0];
                            endFlg = returnValues[1];
                          }

                          final sendContent = SendContent(
                            questionId: sendQuestionId,
                            answer: '',
                            skillIds: selectSkillIds,
                          );

                          // ターン行動実行
                          turnAction(
                            context,
                            sendContent,
                            true,
                            scrollController,
                            endFlg,
                            soundEffect,
                            seVolume,
                          );

                          Navigator.pop(context);
                        }
                      : () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectQuestionColumn(
    BuildContext context,
    List<Question> selectableQuestions,
    AudioCache soundEffect,
    double seVolume,
    int selectQuestionId,
  ) {
    return Column(
      children: [
        _selectQuestionButton(
          context,
          selectableQuestions[0],
          soundEffect,
          seVolume,
          selectableQuestions[0].id == selectQuestionId,
        ),
        _selectQuestionButton(
          context,
          selectableQuestions[1],
          soundEffect,
          seVolume,
          selectableQuestions[1].id == selectQuestionId,
        ),
        _selectQuestionButton(
          context,
          selectableQuestions[2],
          soundEffect,
          seVolume,
          selectableQuestions[2].id == selectQuestionId,
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
  ) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 8,
        left: 8,
        right: 8,
      ),
      width: double.infinity,
      height: 30,
      child: ElevatedButton(
        onPressed: () {
          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );

          context.read(selectQuestionIdProvider).state = targetQuestion.id;
        },
        child: Text(
          targetQuestion.asking,
          style: const TextStyle(
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: selectedFlg ? Colors.yellow.shade200 : Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          textStyle: Theme.of(context).textTheme.button,
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
      height: 106,
      child: Center(
        child: SizedBox(
          width: double.infinity,
          height: 30,
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              '？？？（ナイスな質問）',
              style: TextStyle(
                fontSize: 25,
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
