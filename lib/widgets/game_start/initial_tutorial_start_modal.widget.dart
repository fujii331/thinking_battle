import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/services/game_start/initialize_game.service.dart';

class InitialTutorialStartModal extends HookWidget {
  final BuildContext screenContext;
  final AudioCache soundEffect;
  final double seVolume;

  const InitialTutorialStartModal({
    Key? key,
    required this.screenContext,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 23,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'CPUと初対戦！',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '初対戦ではターンごとの制限時間はなく、対戦画面右上の「ヘルプ」ボタンからいつでもゲーム説明を確認することができます。\n\n気楽に色々試してみてください！',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 115,
            height: 40,
            child: ElevatedButton(
              child: const Text('対戦開始!'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange.shade600,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.orange.shade700,
                ),
              ),
              onPressed: () async {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                Navigator.pop(context);

                screenContext.read(bgmProvider).state.stop();

                commonInitialAction(screenContext);

                Navigator.of(screenContext).pushReplacementNamed(
                  GamePlayingScreen.routeName,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
