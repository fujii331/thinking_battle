import 'package:audioplayers/audioplayers.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/mode_select/get_item.service.dart';

class ItemBuy extends HookWidget {
  final int itemNumber;
  final int needGpPoint;
  final List<String> cardNumberList;
  final BuildContext previousContext;
  final int buttonNumber;

  const ItemBuy({
    Key? key,
    required this.itemNumber,
    required this.needGpPoint,
    required this.cardNumberList,
    required this.previousContext,
    required this.buttonNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
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
            ),
            child: Text(
              'この' +
                  (iconGachaFlg
                      ? 'アイコン'
                      : buttonNumber == 2
                          ? 'テーマ'
                          : 'メッセージ') +
                  'と交換する？',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            needGpPoint.toString() + ' GPと交換',
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          buttonNumber == 3
              ? Bubble(
                  borderWidth: 1,
                  borderColor: Colors.black,
                  nipOffset: 10,
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
              child: const Text('交換する'),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange.shade600,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.orange.shade700,
                ),
              ),
              onPressed: () async {
                if (previousContext.read(gachaPointProvider).state >=
                    needGpPoint) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  // GPを更新
                  previousContext.read(gachaPointProvider).state -= needGpPoint;
                  prefs.setInt('gachaPoint',
                      previousContext.read(gachaPointProvider).state);

                  Navigator.pop(previousContext);

                  getItem(
                    previousContext,
                    prefs,
                    buttonNumber,
                    itemNumber,
                    cardNumberList,
                    soundEffect,
                    seVolume,
                    0,
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
