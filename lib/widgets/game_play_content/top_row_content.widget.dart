import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/widgets/game_playing/message_pop_up_menu.widget.dart';
import 'package:thinking_battle/widgets/game_playing/rival_info.widget.dart';

class TopRowContent extends StatelessWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final PlayerInfo rivalInfo;
  final int myTurnTime;
  final bool myTurnFlg;
  final int currentSkillPoint;
  final int spChargeTurn;
  final bool displayMyturnSetFlg;
  final bool displayRivalturnSetFlg;
  final List colorList;
  final int afterMessageTime;
  final int selectMessageId;
  final bool initialTutorialFlg;

  const TopRowContent({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.rivalInfo,
    required this.myTurnTime,
    required this.myTurnFlg,
    required this.currentSkillPoint,
    required this.spChargeTurn,
    required this.displayMyturnSetFlg,
    required this.displayRivalturnSetFlg,
    required this.colorList,
    required this.afterMessageTime,
    required this.selectMessageId,
    required this.initialTutorialFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
                body: RivalInfo(rivalInfo: rivalInfo),
              ).show();
            },
            child: Container(
              padding: const EdgeInsets.all(1.5),
              width: 40,
              height: 40,
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
                  width: 1,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
              child: Image.asset(
                'assets/images/characters/' +
                    rivalInfo.imageNumber.toString() +
                    '.png',
              ),
            ),
          ),
          const SizedBox(width: 5),
          SizedBox(
            width: 30,
            child: MessagePopUpMenu(
              soundEffect: soundEffect,
              seVolume: seVolume,
              myTurnFlg: myTurnFlg,
              afterMessageTime: afterMessageTime,
              selectMessageId: selectMessageId,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5 > 130
                ? 130
                : MediaQuery.of(context).size.width * 0.5,
            child: Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: displayMyturnSetFlg ? 1 : 0,
                  child: !initialTutorialFlg
                      ? Row(
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
                                left: myTurnTime < 10 ? 24 : 10,
                              ),
                              child: Container(
                                padding: const EdgeInsets.only(top: 3),
                                child: Text(
                                  myTurnTime.toString(),
                                  style: TextStyle(
                                    color: myTurnTime < 10
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
                        )
                      : Text(
                          'こっちの番',
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontSize: 22,
                          ),
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
          const Spacer(),
          SizedBox(
            width: 50,
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
