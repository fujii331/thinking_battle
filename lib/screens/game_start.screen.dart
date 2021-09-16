import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/services/initialize_game.service.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/stamina.widget.dart';

import 'package:thinking_battle/skills.dart';

class GameStartScreen extends HookWidget {
  const GameStartScreen({Key? key}) : super(key: key);
  static const routeName = '/game-start';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final MaterialColor color = useProvider(colorProvider).state;
    final List<int> mySkillIdsList = useProvider(mySkillIdsListProvider).state;
    final bool trainingFlg = context.read(trainingProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        context.read(bgmProvider).state = await soundEffect.loop(
          'sounds/matting.mp3',
          volume: bgmVolume,
          isNotification: true,
        );

        if (trainingFlg) {
          await Future.delayed(
            const Duration(milliseconds: 1000),
          );

          trainingInitialAction(
            context,
          );
        }

        soundEffect.play(
          'sounds/matching.mp3',
          isNotification: true,
          volume: seVolume,
        );

        await Future.delayed(
          const Duration(milliseconds: 3000),
        );

        context.read(bgmProvider).state.stop();

        final bool precedingFlg = Random().nextInt(2) == 0 ? true : false;

        final String thema = commonInitialAction(context);

        if (!trainingFlg) {
          context.read(lifePointProvider).state -= 1;
        }

        // Navigator.of(context).pushNamed(
        //   GamePlayingScreen.routeName,
        //   arguments: [
        //     precedingFlg,
        //     thema,
        //   ],
        // );
      });
      return null;
    }, const []);

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
                    rivalInfo.skillList,
                    false,
                    trainingFlg,
                  ),
                  const SizedBox(height: 50),
                  rivalInfo.skillList.isNotEmpty
                      ? Text(
                          'VS',
                          style: TextStyle(
                            color: Colors.red.shade200,
                            fontSize: 28,
                          ),
                        )
                      : Row(
                          children: [
                            SpinKitPouringHourGlassRefined(
                              color: Colors.orange.shade200,
                              size: 50.0,
                            ),
                            Text(
                              'マッチング中',
                              style: TextStyle(
                                color: Colors.yellow.shade200,
                                fontSize: 28,
                              ),
                            ),
                          ],
                        ),
                  const SizedBox(height: 50),
                  _userProfile(
                    context,
                    color,
                    imageNumber,
                    playerName,
                    rate,
                    mySkillIdsList,
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
    List<int> mySkillIdsList,
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
                  mySkillIdsList,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerData(
                  userName,
                  userRate,
                  mySkillIdsList,
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
    List<int> mySkillIdsList,
  ) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                playerName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                playerRate.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange.shade200,
            ),
            child: Column(
              children: [
                Text(
                  skillSettings[mySkillIdsList[0]].skillName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  skillSettings[mySkillIdsList[1]].skillName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  skillSettings[mySkillIdsList[2]].skillName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
