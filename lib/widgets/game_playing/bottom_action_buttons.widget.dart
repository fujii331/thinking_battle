import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/answer_modal.widget.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/question_modal.widget.dart';

class BottomActionButtons extends StatelessWidget {
  final ScrollController scrollController;

  // ignore: use_key_in_widget_constructors
  const BottomActionButtons(
    this.scrollController,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;
    final bool forceQuestionFlg = useProvider(forceQuestionFlgProvider).state;
    final bool answerFailedFlg = useProvider(answerFailedFlgProvider).state;

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text(
              '解答',
            ),
            style: ElevatedButton.styleFrom(
              primary: myTurnFlg && !forceQuestionFlg && !answerFailedFlg
                  ? Colors.pink.shade600
                  : Colors.pink.shade200,
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: myTurnFlg && !forceQuestionFlg && !answerFailedFlg
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      builder: (BuildContext context) {
                        return AnswerModal(scrollController);
                      },
                    );
                  }
                : () {},
          ),
          ElevatedButton(
            child: const Text(
              '質問',
            ),
            style: ElevatedButton.styleFrom(
              primary: myTurnFlg ? Colors.blue.shade500 : Colors.blue.shade200,
              textStyle: Theme.of(context).textTheme.button,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: myTurnFlg && !forceQuestionFlg
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                      ),
                      builder: (BuildContext context) {
                        return QuestionModal(scrollController);
                      },
                    );
                  }
                : () {},
          ),
        ],
      ),
    );
  }
}
