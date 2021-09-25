import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/mode_select/setting_my_skills.widget.dart';

class MyInfo extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  // ignore: use_key_in_widget_constructors
  const MyInfo(
    this.soundEffect,
    this.seVolume,
  );

  @override
  Widget build(BuildContext context) {
    final int imageNumber = useProvider(imageNumberProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final MaterialColor color = useProvider(colorProvider).state;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset.topLeft,
          end: FractionalOffset.bottomRight,
          colors: [
            Colors.deepPurple.shade900,
            Colors.blue.shade900,
            Colors.indigo.shade900,
          ],
          stops: const [
            0.2,
            0.6,
            0.9,
          ],
        ),
        border: Border.all(
          color: Colors.indigo.shade800,
          width: 3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
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
                'assets/images/' + imageNumber.toString() + '.png',
              ),
            ),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                  child: Text(
                    'name',
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 13,
                    ),
                  ),
                ),
                Text(
                  playerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'KaiseiOpti',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                          child: Text(
                            'rate',
                            style: TextStyle(
                              color: Colors.blueGrey.shade200,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Text(
                          rate.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'KaiseiOpti',
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: SizedBox(
                        width: 68,
                        height: 33,
                        child: ElevatedButton(
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
                              width:
                                  MediaQuery.of(context).size.width * .86 > 650
                                      ? 650
                                      : null,
                              body: SettingMySkills(
                                [...context.read(mySkillIdsListProvider).state],
                                soundEffect,
                                seVolume,
                              ),
                            ).show();
                          },
                          child: const Text(
                            'スキル',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green.shade600,
                            padding: const EdgeInsets.only(
                              bottom: 3,
                            ),
                            shape: const StadiumBorder(),
                            side: BorderSide(
                              width: 2,
                              color: Colors.green.shade900,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
