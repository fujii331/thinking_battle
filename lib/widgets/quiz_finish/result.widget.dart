import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/services/initialize_game.service.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/stamina.widget.dart';

class Result extends HookWidget {
  final bool? winFlg;

  // ignore: use_key_in_widget_constructors
  const Result(
    this.winFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final MaterialColor color = useProvider(colorProvider).state;
    final bool trainingFlg = context.read(trainingProvider).state;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.9,
              color: Colors.grey.shade900.withOpacity(0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Stamina(),
                  const SizedBox(height: 30),
                  _userProfile(
                    context,
                    color,
                    rivalInfo.imageNumber,
                    rivalInfo.name,
                    rivalInfo.rate,
                    winFlg == null ? null : !winFlg!,
                    false,
                    trainingFlg,
                  ),
                  const SizedBox(height: 30),
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

                          final bool precedingFlg =
                              Random().nextInt(2) == 0 ? true : false;

                          final String thema = commonInitialAction(context);

                          Navigator.of(context).pushNamed(
                            GamePlayingScreen.routeName,
                            arguments: [
                              precedingFlg,
                              thema,
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  _userProfile(
                    context,
                    color,
                    imageNumber,
                    playerName,
                    rate,
                    winFlg,
                    true,
                    trainingFlg,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userProfile(
    BuildContext context,
    MaterialColor userColor,
    int imageNumber,
    String userName,
    double userRate,
    bool? winFlg,
    bool myDataFlg,
    bool trainingFlg,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8 > 600.0
          ? 600.0
          : MediaQuery.of(context).size.width * 0.8,
      height: 200,
      child: myDataFlg
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerIcon(
                  userColor,
                  imageNumber,
                ),
                const SizedBox(width: 30),
                _playerData(
                  userName,
                  userRate,
                  winFlg,
                  trainingFlg,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerData(
                  userName,
                  userRate,
                  winFlg == null ? null : !winFlg,
                  trainingFlg,
                ),
                const SizedBox(width: 30),
                _playerIcon(
                  userColor,
                  imageNumber,
                ),
              ],
            ),
    );
  }

  Widget _playerIcon(
    MaterialColor playerColor,
    int imageNumber,
  ) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: playerColor,
          width: 4,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Image.asset(
          'assets/images/' + imageNumber.toString() + '.png',
        ),
      ),
    );
  }

  Widget _playerData(
    String playerName,
    double playerRate,
    bool? winFlg,
    bool trainingFlg,
  ) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
            child: Text(
              'name',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            playerName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
            child: Text(
              'rate',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                playerRate.toString(),
                style: TextStyle(
                  color: trainingFlg || winFlg == null
                      ? Colors.black
                      : winFlg
                          ? Colors.blue
                          : Colors.red,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 15),
              trainingFlg || winFlg == null
                  ? Container()
                  : Icon(
                      winFlg ? Icons.arrow_upward : Icons.arrow_downward,
                      color: winFlg ? Colors.blue : Colors.red,
                      size: 17,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
