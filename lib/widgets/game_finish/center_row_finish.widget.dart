import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';

class CenterRowFinish extends StatelessWidget {
  final bool? winFlg;

  // ignore: use_key_in_widget_constructors
  const CenterRowFinish(
    this.winFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final bool trainingFlg = context.read(trainingProvider).state;

    return Column(
      children: [
        Text(
          winFlg == null
              ? '引き分け！'
              : winFlg!
                  ? 'あなたの勝ち！'
                  : 'あなたの負け！',
          style: TextStyle(
            color: winFlg == null
                ? Colors.green.shade200
                : winFlg!
                    ? Colors.blue.shade200
                    : Colors.red.shade200,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text(
                '戻る',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade300,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                Navigator.of(context).pushNamed(
                  ModeSelectScreen.routeName,
                );
              },
            ),
            ElevatedButton(
              child: const Text(
                '次のゲーム',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade300,
                textStyle: Theme.of(context).textTheme.button,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                if (trainingFlg) {
                  context.read(trainingProvider).state = true;
                }

                Navigator.of(context).pushNamed(
                  GameStartScreen.routeName,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
