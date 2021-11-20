import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/services/game_start/matching_flow.service.dart';

class NoMatchingModal extends HookWidget {
  final BuildContext screenContext;
  final int imageNumber;
  final int cardNumber;
  final String userName;
  final double userRate;
  final int matchedCount;
  final int continuousWinCount;
  final List<int> userSkillIdsList;
  final ValueNotifier<bool> matchingQuitFlgState;
  final String friendMatchWord;
  final ValueNotifier<bool> interruptionFlgState;
  final ValueNotifier<bool> matchingAnimatedFlgState;

  const NoMatchingModal({
    Key? key,
    required this.screenContext,
    required this.imageNumber,
    required this.cardNumber,
    required this.userName,
    required this.userRate,
    required this.matchedCount,
    required this.continuousWinCount,
    required this.userSkillIdsList,
    required this.matchingQuitFlgState,
    required this.friendMatchWord,
    required this.interruptionFlgState,
    required this.matchingAnimatedFlgState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'マッチング失敗',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '対戦相手が見つかりませんでした。\nもう一度相手を探しますか？',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text('やめる'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade600,
                      textStyle: Theme.of(context).textTheme.button,
                      padding: const EdgeInsets.only(
                        bottom: 3,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        width: 2,
                        color: Colors.red.shade700,
                      ),
                    ),
                    onPressed: () async {
                      soundEffect.play(
                        'sounds/cancel.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      context.read(bgmProvider).state.stop();
                      context.read(bgmProvider).state = await soundEffect.loop(
                        'sounds/title.mp3',
                        volume: bgmVolume,
                        isNotification: true,
                      );

                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(ModeSelectScreen.routeName),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 30),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text('続ける'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue.shade600,
                      padding: const EdgeInsets.only(
                        bottom: 3,
                      ),
                      shape: const StadiumBorder(),
                      side: BorderSide(
                        width: 2,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    onPressed: () async {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );

                      matchingQuitFlgState.value = false;

                      Navigator.pop(context);

                      matchingFlow(
                        screenContext,
                        imageNumber,
                        cardNumber,
                        userName,
                        userRate,
                        matchedCount,
                        continuousWinCount,
                        userSkillIdsList,
                        matchingQuitFlgState,
                        friendMatchWord,
                        interruptionFlgState,
                        matchingAnimatedFlgState,
                        soundEffect,
                        seVolume,
                      );
                    },
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
