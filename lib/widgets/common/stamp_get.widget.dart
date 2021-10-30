import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/services/mode_select/check_stamp.service.dart';

class StampGet extends HookWidget {
  final BuildContext screenContext;
  final SharedPreferences prefs;
  final int itemNumber;
  final String title;
  final String title2;
  final int patternNumber;
  final String message;
  final AudioCache soundEffect;
  final double seVolume;
  final int nextActionNumber;

  const StampGet({
    Key? key,
    required this.screenContext,
    required this.prefs,
    required this.itemNumber,
    required this.title,
    required this.title2,
    required this.patternNumber,
    required this.message,
    required this.soundEffect,
    required this.seVolume,
    required this.nextActionNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool iconFlg = patternNumber == 1;

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 25,
        right: 25,
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
              title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange.shade700,
              ),
            ),
          ),
          Text(
            title2,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          message != ''
              ? Text(
                  message,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                )
              : patternNumber == 4
                  ? Container(
                      height: 40,
                      width: 80,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage('assets/images/ticket.png'),
                        ),
                      ),
                    )
                  : patternNumber == 3
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
                          width: iconFlg ? 120 : 126,
                          height: iconFlg ? 120 : 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage('assets/images/' +
                                  (iconFlg ? 'characters/' : 'cards/') +
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

                // 次のチェックを実行
                checkStamp(
                  screenContext,
                  prefs,
                  nextActionNumber,
                  soundEffect,
                  seVolume,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
