import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';

class PlayGameButtons extends StatelessWidget {
  final AudioCache soundEffect;
  final double seVolume;

  // ignore: use_key_in_widget_constructors
  const PlayGameButtons(
    this.soundEffect,
    this.seVolume,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _playButton(
          context,
          'トレーニング',
          Colors.lime.shade800,
          1,
        ),
        const SizedBox(height: 25),
        _playButton(
          context,
          'ランダムマッチ',
          Colors.lightBlue.shade600,
          2,
        ),
      ],
    );
  }

  Widget _playButton(
    BuildContext context,
    String text,
    Color color,
    int buttonNumber,
  ) {
    return SizedBox(
      width: 210,
      child: ElevatedButton(
        onPressed: () async {
          context.read(rivalInfoProvider).state = dummyPlayerInfo;

          soundEffect.play(
            'sounds/tap.mp3',
            isNotification: true,
            volume: seVolume,
          );

          context.read(bgmProvider).state.stop();

          if (buttonNumber == 1) {
            context.read(trainingProvider).state = true;
          } else {
            context.read(trainingProvider).state = false;
          }

          Navigator.of(context).pushNamed(
            GameStartScreen.routeName,
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: color,
          elevation: 8,
          shadowColor: Colors.grey,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          textStyle: Theme.of(context).textTheme.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            width: 2,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
