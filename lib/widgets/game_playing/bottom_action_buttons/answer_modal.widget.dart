import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';

class AnswerModal extends HookWidget {
  final BuildContext screenContext;
  final ScrollController scrollController;
  final AudioCache soundEffect;
  final double seVolume;
  final bool myTurnFlg;

  // ignore: use_key_in_widget_constructors
  const AnswerModal(
    this.screenContext,
    this.scrollController,
    this.soundEffect,
    this.seVolume,
    this.myTurnFlg,
  );

  @override
  Widget build(BuildContext context) {
    final String inputAnswer = context.read(inputAnswerProvider).state;
    final hiraganaState = useState(true);

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
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
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
                  primary: inputAnswer.isNotEmpty
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
                onPressed: myTurnFlg && inputAnswer.isNotEmpty
                    ? () {
                        if (RegExp(r'^([ぁ-ん|ー])+$').hasMatch(inputAnswer)) {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          hiraganaState.value = true;
                          context.read(myTurnFlgProvider).state = false;

                          final sendContent = SendContent(
                            questionId: 0,
                            answer: inputAnswer,
                            skillIds: [],
                          );

                          // ターン行動実行
                          turnAction(
                            screenContext,
                            sendContent,
                            true,
                            scrollController,
                            false,
                            soundEffect,
                            seVolume,
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
