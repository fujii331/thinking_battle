import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/mode_select/get_item.service.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/gacha_movie.widget.dart';

class GachaButton extends HookWidget {
  final int buttonNumber;
  final int gpPoint;
  final int gpCount;
  final int gachaTicket;
  final List<String> itemNumberList;
  final List<List<int>> getitemNumberList;
  final AudioCache soundEffect;
  final double seVolume;

  const GachaButton({
    Key? key,
    required this.buttonNumber,
    required this.gpPoint,
    required this.gpCount,
    required this.gachaTicket,
    required this.itemNumberList,
    required this.getitemNumberList,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gachaNumber = buttonNumber == 1
        ? 24
        : buttonNumber == 2
            ? 20
            : 20; // ガチャの種類が増えたら要修正
    bool remainingFlg = false;

    // 全てのガチャを手に入れていたらフラグがfalseのままになり、ボタンが押せない
    for (int i = 5; i <= gachaNumber; i++) {
      if (!itemNumberList.contains(i.toString())) {
        remainingFlg = true;
        break;
      }
    }

    final bool enableGacha = (gachaTicket > 0 || gpCount > 0) && remainingFlg;

    return SizedBox(
      width: gachaTicket > 0 ? 150 : 130,
      height: 40,
      child: ElevatedButton(
        child: Text(
          gachaTicket > 0 ? 'ガチャチケを使う' : '動画を見る',
          style: TextStyle(
            fontSize: gachaTicket > 0 ? 16 : 17,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary:
              enableGacha ? Colors.orange.shade600 : Colors.orange.shade200,
          padding: const EdgeInsets.only(
            bottom: 3,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            width: 2,
            color: Colors.orange.shade700,
          ),
        ),
        onPressed: enableGacha
            ? () async {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                SharedPreferences prefs = await SharedPreferences.getInstance();

                if (gachaTicket > 0) {
                  context.read(gachaTicketProvider).state -= 1;
                  prefs.setInt(
                      'gachaTicket', context.read(gachaTicketProvider).state);
                } else {
                  // TODO 動画を見せる
                  context.read(gpCountProvider).state -= 1;
                  prefs.setInt('gpCount', context.read(gpCountProvider).state);
                }

                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  headerAnimationLoop: false,
                  dismissOnTouchOutside: false,
                  dismissOnBackKeyPress: false,
                  showCloseIcon: false,
                  animType: AnimType.SCALE,
                  dialogBackgroundColor: Colors.black.withOpacity(0.0),
                  body: GachaMovie(
                    soundEffect: soundEffect,
                    seVolume: seVolume,
                  ),
                ).show();

                await Future.delayed(
                  const Duration(milliseconds: 4050),
                );

                final int randomNum = Random().nextInt(100);

                int addNum = 0;

                for (List<int> getitemNumberList in getitemNumberList) {
                  // 確率を上乗せしていく
                  addNum += getitemNumberList[1];
                  if (randomNum < addNum) {
                    await getItem(
                      context,
                      prefs,
                      buttonNumber,
                      getitemNumberList[0],
                      itemNumberList,
                      soundEffect,
                      seVolume,
                    );
                    break;
                  }
                }
              }
            : () {},
      ),
    );
  }
}
