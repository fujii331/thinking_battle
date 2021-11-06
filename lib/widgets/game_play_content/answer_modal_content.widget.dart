import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

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
                'ひらがなで答えを入力',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: 170,
                  child: TextFormField(
                    controller: answerController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: 'タップして入力',
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                      ),
                    ),
                    onChanged: (String input) {
                      context.read(inputAnswerProvider).state = input;
                      if (inputAnswer.isNotEmpty &&
                          RegExp(r'^([ぁ-ん|ー])+$').hasMatch(input)) {
                        hiraganaState.value = true;
                      }
                    },
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(
                        12,
                      ),
                    ],
                  ),
                ),
                const Text(
                  'だ！',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
              child: Text(
                hiraganaState.value ? '' : 'ひらがなで入力してください',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'SawarabiGothic',
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                        if (RegExp(r'^([ぁ-ん|ー])+$')
                            .hasMatch(answerController.text)) {
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
                        } else {
                          hiraganaState.value = false;
                        }
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
