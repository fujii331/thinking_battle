import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/answer_modal.widget.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons/question_modal.widget.dart';

class BottomActionButtonsContent extends StatelessWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;
  final bool forceQuestionFlg;
  final bool answerFailedFlg;

  const BottomActionButtonsContent({
    Key? key,
    required this.screenContext,
    required this.scrollController,
    required this.myActionDoc,
    required this.rivalListenSubscription,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
    required this.forceQuestionFlg,
    required this.answerFailedFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                          return AnswerModal(
                            screenContext: screenContext,
                            scrollController: scrollController,
                            myActionDoc: myActionDoc,
                            rivalListenSubscription: rivalListenSubscription,
                            soundEffect: soundEffect,
                            seVolume: seVolume,
                            myTurnFlg: myTurnFlg,
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
                            screenContext: screenContext,
                            scrollController: scrollController,
                            myActionDoc: myActionDoc,
                            rivalListenSubscription: rivalListenSubscription,
                            soundEffect: soundEffect,
                            seVolume: seVolume,
                            myTurnFlg: myTurnFlg,
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
