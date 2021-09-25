import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_playing/rival_info.widget.dart';

class TopRow extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final PlayerInfo rivalInfo;
  final DateTime myTurnTime;

  // ignore: use_key_in_widget_constructors
  const TopRow(
    this.soundEffect,
    this.seVolume,
    this.rivalInfo,
    this.myTurnTime,
  );

  @override
  Widget build(BuildContext context) {
    final int currentSkillPoint = useProvider(currentSkillPointProvider).state;

    final int spChargeTurn = useProvider(spChargeTurnProvider).state;

    final bool displayMyturnSetFlg =
        useProvider(displayMyturnSetFlgProvider).state;
    final bool displayRivalturnSetFlg =
        useProvider(displayRivalturnSetFlgProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              soundEffect.play(
                'sounds/tap.mp3',
                isNotification: true,
                volume: seVolume,
              );
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                dialogBackgroundColor: Colors.black.withOpacity(0.5),
                headerAnimationLoop: false,
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: true,
                showCloseIcon: true,
                closeIcon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
                body: RivalInfo(rivalInfo),
              ).show();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(
                  color: rivalInfo.color,
                  width: 2,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.asset(
                  'assets/images/' + rivalInfo.imageNumber.toString() + '.png',
                  height: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 50),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 > 130
                ? 130
                : MediaQuery.of(context).size.width * 0.5,
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: displayMyturnSetFlg ? 1 : 0,
                  child: Row(
                    children: [
                      const Text(
                        '残り',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left:
                              int.parse(DateFormat('s').format(myTurnTime)) < 10
                                  ? 24
                                  : 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            DateFormat('s').format(myTurnTime),
                            style: TextStyle(
                              color: int.parse(
                                          DateFormat('s').format(myTurnTime)) <
                                      10
                                  ? Colors.red.shade200
                                  : Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text(
                        ' 秒',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: displayRivalturnSetFlg ? 1 : 0,
                  child: Text(
                    'あいての番',
                    style: TextStyle(
                      color: Colors.green.shade200,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          SizedBox(
            width: 47,
            child: Row(
              children: [
                Text(
                  currentSkillPoint.toString(),
                  style: TextStyle(
                    color:
                        spChargeTurn > 0 ? Colors.red.shade200 : Colors.white,
                    fontSize: 24,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    ' SP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
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
