import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/services/game_playing/failed_connect.service.dart';

class AnswerModalContent extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final DocumentReference<Map<String, dynamic>>? myActionDoc;
  final StreamSubscription<DocumentSnapshot>? rivalListenSubscription;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;
  final String inputAnswer;
  final List<String> answerCandidate;

  const AnswerModalContent({
    Key? key,
    required this.screenContext,
    required this.scrollController,
    required this.myActionDoc,
    required this.rivalListenSubscription,
    required this.soundEffect,
    required this.seVolume,
    required this.myTurnFlg,
    required this.inputAnswer,
    required this.answerCandidate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hiraganaState = useState(
        inputAnswer.isEmpty || RegExp(r'^([ぁ-ん|ー])+$').hasMatch(inputAnswer));
    final double paddingWidth = MediaQuery.of(context).size.width > 450.0
        ? (MediaQuery.of(context).size.width - 450) / 2
        : 5;
    final TextEditingController answerController =
        useTextEditingController(text: inputAnswer);

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
            const Padding(
              padding: EdgeInsets.only(
                bottom: 25,
              ),
              child: Text(
                '候補から答えを選択',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '答えは',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      bottom: 3,
                    ),
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.black54,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: DropdownButton(
                      isExpanded: true,
                      hint: const Text(
                        'タップして選択',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black45,
                        ),
                      ),
                      underline: Container(
                        color: Colors.black,
                      ),
                      value: answerController.text != ''
                          ? answerController.text
                          : null,
                      items: answerCandidate.map((String word) {
                        return DropdownMenuItem(
                          value: word,
                          child: Text(word,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              )),
                        );
                      }).toList(),
                      onChanged: (targetSubject) {
                        answerController.text = context
                            .read(inputAnswerProvider)
                            .state = targetSubject as String;
                      },
                    ),
                  ),
                ),
                const Text(
                  'だ！',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 100,
              height: 40,
              child: ElevatedButton(
                child: const Text('解答する'),
                style: ElevatedButton.styleFrom(
                  primary: answerController.text.isNotEmpty
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
                onPressed: myTurnFlg && answerController.text.isNotEmpty
                    ? () async {
                        soundEffect.play(
                          'sounds/tap.mp3',
                          isNotification: true,
                          volume: seVolume,
                        );
                        hiraganaState.value = true;
                        context.read(myTurnFlgProvider).state = false;

                        final messageId =
                            context.read(selectMessageIdProvider).state;

                        // 通信対戦時は相手にデータを送る
                        if (myActionDoc != null) {
                          await myActionDoc!
                              .set({
                                'questionId': 0,
                                'answer': answerController.text,
                                'skillIds': [],
                                'messageId': messageId,
                              })
                              .timeout(const Duration(seconds: 5))
                              .onError((error, stackTrace) {
                                rivalListenSubscription!.cancel();
                                failedConnect(context);
                              });
                        }

                        final sendContent = SendContent(
                          questionId: 0,
                          answer: answerController.text,
                          skillIds: [],
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
            SizedBox(
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }
}
