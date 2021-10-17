import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/common/continuous_win.widget.dart';
import 'package:thinking_battle/widgets/common/profile_name.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';
import 'package:thinking_battle/widgets/common/stack_word.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_room/setting_my_skills.widget.dart';

class MyInfo extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final int cardNumber;
  final List colorList;

  // ignore: use_key_in_widget_constructors
  const MyInfo(
    this.soundEffect,
    this.seVolume,
    this.cardNumber,
    this.colorList,
  );

  @override
  Widget build(BuildContext context) {
    final int imageNumber = useProvider(imageNumberProvider).state;
    final String playerName = useProvider(playerNameProvider).state;
    final double rate = useProvider(rateProvider).state;
    final int continuousWinCount =
        useProvider(continuousWinCountProvider).state;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade600,
              blurRadius: 5.0,
              spreadRadius: 0.1,
              offset: const Offset(2, 2))
        ],
      ),
      width: MediaQuery.of(context).size.width * 0.9 > 270.0
          ? 270.0
          : MediaQuery.of(context).size.width * 0.9,
      height: 120,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage(
                    'assets/images/cards/' + cardNumber.toString() + '.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 11,
              horizontal: 5,
            ),
            child: Row(
              children: [
                const SizedBox(width: 10),
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight,
                          colors: colorList[0][0],
                          stops: const [
                            0.2,
                            0.6,
                            0.9,
                          ],
                        ),
                        border: Border.all(
                          color: colorList[0][1],
                          width: 1.5,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width > 300 ? 85 : 70,
                      height: MediaQuery.of(context).size.width > 300 ? 85 : 70,
                      child: Image.asset(
                        'assets/images/characters/' +
                            imageNumber.toString() +
                            '.png',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileName(
                        playerName,
                        colorList[1],
                        -1,
                      ),
                      const SizedBox(height: 7),
                      Wrap(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StackLabel(
                                'rate',
                                0,
                              ),
                              StackWord(
                                rate.toString(),
                                Colors.white,
                                0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          continuousWinCount > 1
              ? Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 3),
                      child: ContinuousWin(
                        continuousWinCount,
                        0,
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
