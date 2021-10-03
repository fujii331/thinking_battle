import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/services/game_playing/matching_action.service.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/services/game_playing/initialize_game.service.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/widgets/game_start/center_row_start.widget.dart';
import 'package:thinking_battle/widgets/game_start/top_row_start.widget.dart';
import 'package:thinking_battle/widgets/game_start/user_profile_start.widget.dart';

class GameStartScreen extends HookWidget {
  const GameStartScreen({Key? key}) : super(key: key);
  static const routeName = '/game-start';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final int matchedCount = useProvider(matchedCountProvider).state;
    final int continuousWinCount =
        useProvider(continuousWinCountProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final double maxRate = useProvider(maxRateProvider).state;
    final List<int> mySkillIdsList = useProvider(mySkillIdsListProvider).state;
    final bool trainingFlg = context.read(trainingProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    final matchingQuitFlg = useState(false);
    final matchingFlg = useState(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        context.read(rivalInfoProvider).state = dummyPlayerInfo;
        context.read(matchingWaitingIdProvider).state = '';
        context.read(matchingRoomIdProvider).state = '';

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
            const Duration(milliseconds: 1500),
          );
          if (!matchingQuitFlg.value) {
            trainingInitialAction(
              context,
            );
          }
        } else {
          await matchingAction(
            context,
            imageNumber,
            playerName,
            rate,
            maxRate,
            matchedCount,
            continuousWinCount,
            mySkillIdsList,
          );
        }

        if (!matchingQuitFlg.value) {
          soundEffect.play(
            'sounds/matching.mp3',
            isNotification: true,
            volume: seVolume,
          );

          await Future.delayed(
            const Duration(milliseconds: 100),
          );

          matchingFlg.value = true;

          await Future.delayed(
            const Duration(milliseconds: 5000),
          );

          context.read(bgmProvider).state.stop();

          final String thema = commonInitialAction(context);

          Navigator.of(context).pushReplacementNamed(
            GamePlayingScreen.routeName,
            arguments: thema,
          );
        }
      });
      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blueGrey.shade900.withOpacity(0.7),
            ),
            Center(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // const Stamina(),
                      // const SizedBox(height: 30),
                      TopRowStart(
                        rivalInfo.skillList.isNotEmpty,
                      ),
                      rivalInfo.skillList.isNotEmpty
                          // rivalInfo.skillList.isEmpty
                          ? AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: matchingFlg.value ? 1 : 0,
                              child: UserProfileStart(
                                rivalInfo.imageNumber,
                                rivalInfo.matchedCount,
                                rivalInfo.continuousWinCount,
                                rivalInfo.name,
                                rivalInfo.rate,
                                rivalInfo.maxRate,
                                rivalInfo.skillList,
                                true,
                              ),
                            )
                          : const SizedBox(
                              height: 158,
                            ),
                      CenterRowStart(
                        rivalInfo.skillList.isNotEmpty,
                        trainingFlg,
                        soundEffect,
                        seVolume,
                        matchingQuitFlg,
                      ),
                      UserProfileStart(
                        imageNumber,
                        matchedCount,
                        continuousWinCount,
                        playerName,
                        rate,
                        maxRate,
                        mySkillIdsList,
                        true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
