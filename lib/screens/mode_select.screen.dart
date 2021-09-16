import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:thinking_battle/background.widget.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/quiz_data.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';
import 'package:thinking_battle/services/initialize_game.service.dart';
import 'package:thinking_battle/widgets/modal/select_skills.widget.dart';
import 'package:intl/intl.dart';
import 'package:bubble/bubble.dart';

import 'package:thinking_battle/widgets/modal/sound_mode.widget.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/stamina.widget.dart';

class ModeSelectScreen extends HookWidget {
  const ModeSelectScreen({Key? key}) : super(key: key);
  static const routeName = '/mode-select';

  void toSoundMode(BuildContext context) => AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: const SoundMode(),
      )..show();

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final MaterialColor color = useProvider(colorProvider).state;

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
                children: <Widget>[
                  const Stamina(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: color,
                              width: 4,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Image.asset(
                              'assets/images/' +
                                  imageNumber.toString() +
                                  '.png',
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                                child: Text(
                                  'name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                playerName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                                child: Text(
                                  'rate',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Text(
                                rate.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 5),
                              ElevatedButton(
                                onPressed: () async {
                                  soundEffect.play(
                                    'sounds/tap.mp3',
                                    isNotification: true,
                                    volume: seVolume,
                                  );

                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.NO_HEADER,
                                    headerAnimationLoop: false,
                                    dismissOnTouchOutside: true,
                                    dismissOnBackKeyPress: true,
                                    showCloseIcon: true,
                                    animType: AnimType.SCALE,
                                    width: MediaQuery.of(context).size.width *
                                                .86 >
                                            650
                                        ? 650
                                        : null,
                                    body: SelectSkills([
                                      ...context
                                          .read(mySkillIdsListProvider)
                                          .state
                                    ]),
                                  ).show();
                                },
                                child: const Text(
                                  'スキル選択',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.green,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 2,
                                  ),
                                  textStyle: Theme.of(context).textTheme.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: const BorderSide(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
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
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _iconButton(
                          context,
                          Colors.yellow.shade100,
                          Icons.account_circle,
                          soundEffect,
                          1,
                          seVolume,
                        ),
                        _iconButton(
                          context,
                          Colors.blue,
                          Icons.audiotrack,
                          soundEffect,
                          2,
                          seVolume,
                        ),
                        _iconButton(
                          context,
                          Colors.green.shade300,
                          Icons.auto_stories,
                          soundEffect,
                          3,
                          seVolume,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    BuildContext context,
    Color color,
    IconData icon,
    AudioCache soundEffect,
    int buttonPuttern,
    double seVolume,
  ) {
    return IconButton(
      iconSize: 28,
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: () {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );
        if (buttonPuttern == 1) {
          // toWarewolfSettingTab(context);
        } else if (buttonPuttern == 2) {
          toSoundMode(context);
        } else if (buttonPuttern == 3) {
          // toWarewolfSettingTab(context);
        }
      },
    );
  }
}
