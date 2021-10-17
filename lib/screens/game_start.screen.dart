import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/services/game_playing/matching_action.service.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/services/game_playing/initialize_game.service.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

import 'package:thinking_battle/widgets/game_start/center_row_start.widget.dart';
import 'package:thinking_battle/widgets/game_start/failed_matching.widget.dart';
import 'package:thinking_battle/widgets/game_start/top_row_start.widget.dart';
import 'package:thinking_battle/widgets/common/user_profile_common.widget.dart';

class GameStartScreen extends HookWidget {
  const GameStartScreen({Key? key}) : super(key: key);
  static const routeName = '/game-start';

  Future gameStart(
    BuildContext context,
    ValueNotifier<bool> matchingFlg,
    AudioCache soundEffect,
    double seVolume,
  ) async {
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

  @override
  Widget build(BuildContext context) {
    final String fiendMatchWord = useProvider(friendMatchWordProvider).state;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final int cardNumber = useProvider(cardNumberProvider).state;

    final int matchedCount = useProvider(matchedCountProvider).state;
    final int continuousWinCount =
        useProvider(continuousWinCountProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
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

        if (!matchingQuitFlg.value) {
          if (trainingFlg) {
            await Future.delayed(
              const Duration(milliseconds: 1500),
            );
            if (!matchingQuitFlg.value) {
              trainingInitialAction(
                context,
              );

              gameStart(
                context,
                matchingFlg,
                soundEffect,
                seVolume,
              );
            }
          } else {
            await matchingAction(
              context,
              imageNumber,
              cardNumber,
              playerName,
              rate,
              matchedCount,
              continuousWinCount,
              mySkillIdsList,
              matchingQuitFlg,
              fiendMatchWord,
            ).then((_) {
              if (!matchingQuitFlg.value) {
                gameStart(
                  context,
                  matchingFlg,
                  soundEffect,
                  seVolume,
                );
              }
            }).catchError((onError) async {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                headerAnimationLoop: false,
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
                body: const FaildMatching(
                  '通信失敗',
                  '電波状況をご確認ください。\nメニュー画面に戻ります。',
                ),
              ).show();

              await Future.delayed(
                const Duration(milliseconds: 3500),
              );
              context.read(bgmProvider).state.stop();
              context.read(bgmProvider).state = await soundEffect.loop(
                'sounds/title.mp3',
                volume: bgmVolume,
                isNotification: true,
              );
              Navigator.popUntil(
                  context, ModalRoute.withName(ModeSelectScreen.routeName));
              return;
            });
          }
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
                              child: UserProfileCommon(
                                rivalInfo.imageNumber,
                                rivalInfo.cardNumber,
                                rivalInfo.matchedCount,
                                rivalInfo.continuousWinCount,
                                rivalInfo.name,
                                rivalInfo.rate,
                                rivalInfo.skillList,
                                0,
                              ),
                            )
                          : SizedBox(
                              height: 158,
                              child: fiendMatchWord != ''
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            child: Text(
                                              'あいことば',
                                              style: TextStyle(
                                                color: Colors.blueGrey.shade100,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            fiendMatchWord,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'KaiseiOpti',
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            ),
                      CenterRowStart(
                        rivalInfo.skillList.isNotEmpty,
                        trainingFlg,
                        soundEffect,
                        seVolume,
                        matchingQuitFlg,
                      ),
                      UserProfileCommon(
                        imageNumber,
                        cardNumber,
                        matchedCount,
                        continuousWinCount,
                        playerName,
                        rate,
                        mySkillIdsList,
                        0,
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
