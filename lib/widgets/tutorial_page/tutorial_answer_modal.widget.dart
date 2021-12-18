import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:thinking_battle/widgets/game_play_content/answer_modal_content.widget.dart';

class TutorialAnswerModal extends HookWidget {
  final String inputAnswer;

  const TutorialAnswerModal({
    Key? key,
    required this.inputAnswer,
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
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomRight: Radius.zero,
                  bottomLeft: Radius.zero,
                ),
              ),
              child: AnswerModalContent(
                screenContext: context,
                scrollController: ScrollController(),
                myActionDoc: null,
                rivalListenSubscription: null,
                soundEffect: AudioCache(),
                seVolume: 0,
                myTurnFlg: true,
                inputAnswer: inputAnswer,
                answerCandidate: const ['りんご'],
                displayUpdateFlgState: useState(false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
