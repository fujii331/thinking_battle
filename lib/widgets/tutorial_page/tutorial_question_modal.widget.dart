import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/widgets/game_play_content/question_modal_content.widget.dart';

class TutorialQuestionModal extends StatelessWidget {
  final int selectQuestionId;
  final List<Question> selectableQuestions;
  final List<int> selectSkillIds;
  final bool forceQuestionFlg;

  const TutorialQuestionModal({
    Key? key,
    required this.selectQuestionId,
    required this.selectableQuestions,
    required this.selectSkillIds,
    required this.forceQuestionFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Column(
          children: [
            const SizedBox(),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
              child: QuestionModalContent(
                screenContext: context,
                scrollController: ScrollController(),
                myActionDoc: null,
                rivalListenSubscription: null,
                soundEffect: AudioCache(),
                seVolume: 0,
                myTurnFlg: true,
                selectQuestionId: selectQuestionId,
                selectableQuestions: selectableQuestions,
                selectSkillIds: selectSkillIds,
                forceQuestionFlg: forceQuestionFlg,
                changeFlgState: ValueNotifier(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
