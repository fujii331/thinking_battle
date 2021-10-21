import 'package:audioplayers/audioplayers.dart';
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

  // ignore: use_key_in_widget_constructors
  const ItemBuy(
    this.itemNumber,
    this.needGpPoint,
    this.cardNumberList,
    this.previousContext,
    this.buttonNumber,
  );

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
                  'を交換する？',
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
              ? Text(
                  messageSettings[itemNumber - 1].message,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
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
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // GPを更新
                previousContext.read(gpPointProvider).state -= needGpPoint;
                prefs.setInt(
                    'gpPoint', previousContext.read(gpPointProvider).state);

                Navigator.pop(previousContext);

                getItem(
                  previousContext,
                  prefs,
                  buttonNumber,
                  itemNumber,
                  cardNumberList,
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
