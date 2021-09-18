import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

import 'package:thinking_battle/models/send_content.model.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';

class AnswerModal extends HookWidget {
  final ScrollController scrollController;

  // ignore: use_key_in_widget_constructors
  const AnswerModal(
    this.scrollController,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final String inputAnswer = useProvider(inputAnswerProvider).state;
    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;

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
              'ひらがなで答えを入力',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            children: [
              const Text(
                'それは',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: 150,
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'タップして入力',
                    // enabledBorder:  OutlineInputBorder(
                    //   borderSide: BorderSide(
                    //     color: Colors.black,
                    //   ),
                    // ),
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
                      10,
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              RegExp(r'^([ぁ-ん|ー])+$').hasMatch(inputAnswer)
                  ? ''
                  : 'ひらがなで入力してください',
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'SawarabiGothic',
                color: Colors.red,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: ElevatedButton(
              onPressed: myTurnFlg &&
                      inputAnswer != '' &&
                      RegExp(r'^([ぁ-ん|ー])+$').hasMatch(inputAnswer)
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      context.read(myTurnFlgProvider).state = false;

                      final sendContent = SendContent(
                        questionId: 0,
                        answer: inputAnswer,
                        skillIds: [],
                      );

                      // ターン行動実行
                      turnAction(
                        context,
                        sendContent,
                        true,
                        scrollController,
                        false,
                        soundEffect,
                        seVolume,
                      );

                      Navigator.pop(context);
                    }
                  : () {},
              child: const Text(
                '解答する',
              ),
              style: ElevatedButton.styleFrom(
                primary: inputAnswer != '' &&
                        RegExp(r'^([ぁ-ん|ー])+$').hasMatch(inputAnswer)
                    ? Colors.pink.shade600
                    : Colors.pink.shade200,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
