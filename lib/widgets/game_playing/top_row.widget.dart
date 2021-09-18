import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/game_playing/rival_info.widget.dart';

class TopRow extends StatelessWidget {
  const TopRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final int currentSkillPoint = useProvider(currentSkillPointProvider).state;
    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;
    final DateTime myTurnTime = useProvider(myTurnTimeProvider).state;

    final int spChargeTurn = useProvider(spChargeTurnProvider).state;

    final bool displayMyturnSetFlg =
        useProvider(displayMyturnSetFlgProvider).state;
    final bool displayRivalturnSetFlg =
        useProvider(displayRivalturnSetFlgProvider).state;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                headerAnimationLoop: false,
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: true,
                showCloseIcon: true,
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
                body: const RivalInfo(),
              ).show();
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
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
          const SizedBox(width: 30),
          Stack(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: displayRivalturnSetFlg ? 1 : 0,
                child: Row(
                  children: [
                    const Text(
                      '残り',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        DateFormat('ss').format(myTurnTime),
                        style: TextStyle(
                          color:
                              (int.parse(DateFormat('ss').format(myTurnTime)) <
                                      10)
                                  ? Colors.red.shade200
                                  : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Text(
                      '秒',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: displayMyturnSetFlg ? 1 : 0,
                child: Text(
                  'あいてのターン',
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    currentSkillPoint.toString(),
                    style: TextStyle(
                      color:
                          spChargeTurn > 0 ? Colors.red.shade200 : Colors.white,
                      fontSize: 24,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'SP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
