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
        ElevatedButton(
          onPressed: () async {
            context.read(rivalInfoProvider).state = dummyPlayerInfo;

            soundEffect.play(
              'sounds/tap.mp3',
              isNotification: true,
              volume: seVolume,
            );

            context.read(bgmProvider).state.stop();

            context.read(trainingProvider).state = true;

            Navigator.of(context).pushNamed(
              GameStartScreen.routeName,
            );
          },
          child: const Text(
            'トレーニング',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.lime.shade700,
            elevation: 8,
            shadowColor: Colors.blue,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            textStyle: Theme.of(context).textTheme.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide(
              width: 4,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}
