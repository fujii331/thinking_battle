import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/services/game_playing/initialize_game.service.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_start/center_row_start.widget.dart';
import 'package:thinking_battle/widgets/game_start/user_profile_start.widget.dart';
import 'package:thinking_battle/widgets/common/stamina.widget.dart';

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
        } else {
          // 対戦数
          SharedPreferences prefs = await SharedPreferences.getInstance();
          context.read(matchCountProvider).state += 1;
          prefs.setInt('matchCount', context.read(matchCountProvider).state);
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
                  UserProfileStart(
                    rivalInfo.color,
                    rivalInfo.imageNumber,
                    rivalInfo.name,
                    rivalInfo.rate,
                    rivalInfo.skillList,
                    false,
                  ),
                  const SizedBox(height: 50),
                  CenterRowStart(rivalInfo.skillList.isNotEmpty),
                  const SizedBox(height: 50),
                  UserProfileStart(
                    color,
                    imageNumber,
                    playerName,
                    rate,
                    mySkillIdsList,
                    true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
