import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';

class PlayGameButtons extends HookWidget {
  const PlayGameButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
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
            primary: Colors.grey.shade600,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 5,
            ),
            textStyle: Theme.of(context).textTheme.button,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(),
          ),
        ),
      ],
    );
  }
}
