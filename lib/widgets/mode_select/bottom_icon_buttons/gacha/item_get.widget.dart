import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/services/mode_select/check_stamp.service.dart';

class ItemGet extends HookWidget {
  final BuildContext preWidgetContext;
  final SharedPreferences prefs;
  final int itemNumber;
  final bool newFlg;
  final int buttonNumber;
  final AudioCache soundEffect;
  final double seVolume;

  const ItemGet({
    Key? key,
    required this.preWidgetContext,
    required this.prefs,
    required this.itemNumber,
    required this.newFlg,
    required this.buttonNumber,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool iconGachaFlg = buttonNumber == 1;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 15,
            ),
            child: Text(
              newFlg
                  ? iconGachaFlg
                      ? 'アイコン獲得！'
                      : buttonNumber == 2
                          ? 'テーマ獲得！'
                          : 'メッセージ獲得！'
                  : '残念、持ってる...',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Row(
              children: [
                const SizedBox(),
                const Spacer(),
                Text(
                  newFlg ? 'NEW!' : '+1 GP',
                  style: TextStyle(
                    fontSize: 20.0,
                    color:
                        newFlg ? Colors.yellow.shade800 : Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          buttonNumber == 3
              ? Bubble(
                  borderWidth: 1,
                  borderColor: Colors.black,
                  elevation: 2.0,
                  shadowColor: Colors.grey,
                  nipOffset: 10,
                  nipWidth: 12,
                  nipHeight: 8,
                  nip: BubbleNip.rightBottom,
                  color: Colors.grey.shade700,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 2.5),
                    child: Text(
                      messageSettings[itemNumber - 1].message,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : Container(
                  width: iconGachaFlg ? 120 : 126,
                  height: iconGachaFlg ? 120 : 70,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/images/' +
                          (iconGachaFlg ? 'characters/' : 'cards/') +
                          itemNumber.toString() +
                          '.png'),
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                ),
          const SizedBox(height: 30),
          SizedBox(
            width: 90,
            height: 40,
            child: ElevatedButton(
              child: const Text('閉じる'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red.shade600,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.red.shade700,
                ),
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/cancel.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                Navigator.pop(context);

                if (buttonNumber != 3) {
                  // スタンプチェックを実行
                  checkStamp(
                    preWidgetContext,
                    prefs,
                    3,
                    soundEffect,
                    seVolume,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
