import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/messages.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/mode_select/get_item.service.dart';

class GachaButton extends HookWidget {
  final int buttonNumber;
  final int gpPoint;
  final int gpCount;
  final List<String> itemNumberList;
  final List<List<int>> getitemNumberList;
  final AudioCache soundEffect;
  final double seVolume;

  const GachaButton({
    Key? key,
    required this.buttonNumber,
    required this.gpPoint,
    required this.gpCount,
    required this.itemNumberList,
    required this.getitemNumberList,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enableGacha = gpCount > 0 &&
        itemNumberList.length !=
            (buttonNumber == 1
                ? 24
                : buttonNumber == 2
                    ? 20
                    : messageSettings.length); // ガチャの種類が増えたら要修正

    return SizedBox(
      width: 130,
      height: 40,
      child: ElevatedButton(
        child: const Text('動画を見る'),
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
                // TODO 動画を見せる
                SharedPreferences prefs = await SharedPreferences.getInstance();

                context.read(gpCountProvider).state -= 1;
                prefs.setInt('gpCount', context.read(gpCountProvider).state);

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
