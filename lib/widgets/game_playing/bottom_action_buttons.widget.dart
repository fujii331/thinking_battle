import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/answer_modal.widget.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/question_modal.widget.dart';

class BottomActionButtons extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DatabaseReference firebaseRef;
  final StreamSubscription<Event>? messagesSubscription;
  final AudioCache soundEffect;
  final double seVolume;

  // ignore: use_key_in_widget_constructors
  const BottomActionButtons(
    this.screenContext,
    this.scrollController,
    this.firebaseRef,
    this.messagesSubscription,
    this.soundEffect,
    this.seVolume,
  );

  @override
  Widget build(BuildContext context) {
    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;
    final bool forceQuestionFlg = useProvider(forceQuestionFlgProvider).state;
    final bool answerFailedFlg = useProvider(answerFailedFlgProvider).state;

    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 40,
            child: ElevatedButton(
              child: const Text('解答'),
              style: ElevatedButton.styleFrom(
                primary: myTurnFlg && !forceQuestionFlg && !answerFailedFlg
                    ? Colors.orange.shade600
                    : Colors.orange.shade200,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.orange.shade700,
                ),
              ),
              onPressed: myTurnFlg && !forceQuestionFlg && !answerFailedFlg
                  ? () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        builder: (BuildContext context) {
                          return AnswerModal(
                            screenContext,
                            scrollController,
                            firebaseRef,
                            messagesSubscription,
                            soundEffect,
                            seVolume,
                            myTurnFlg,
                          );
                        },
                      );
                    }
                  : () {},
            ),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 80,
            height: 40,
            child: ElevatedButton(
              child: const Text('質問'),
              style: ElevatedButton.styleFrom(
                primary:
                    myTurnFlg ? Colors.blue.shade500 : Colors.blue.shade200,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.blue.shade700,
                ),
              ),
              onPressed: myTurnFlg
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        builder: (BuildContext context) {
                          return QuestionModal(
                            screenContext,
                            scrollController,
                            firebaseRef,
                            messagesSubscription,
                            soundEffect,
                            seVolume,
                            myTurnFlg,
                          );
                        },
                      );
                    }
                  : () {},
            ),
          ),
        ],
      ),
    );
  }
}
