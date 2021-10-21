import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/data/messages.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/mode_select/my_room/gacha/gacha_button.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_room/gacha/gp_change.widget.dart';

class MessageGacha extends HookWidget {
  const MessageGacha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<String> itemNumberList =
        useProvider(messageIdsListProvider).state;

    final int gpPoint = useProvider(gpPointProvider).state;
    final int gpCount = useProvider(gpCountProvider).state;

    final List<List<int>> getitemNumberList = [
      [5, 7],
      [6, 7],
      [7, 7],
      [8, 7],
      [9, 6],
      [10, 6],
      [11, 6],
      [12, 6],
      [13, 6],
      [14, 6],
      [15, 6],
      [16, 6],
      [17, 6],
      [18, 6],
      [19, 6],
      [20, 6],
    ];

    List<Widget> itemList = [];

    for (List<int> getItemNumber in getitemNumberList) {
      itemList.add(
        _item(
          context,
          getItemNumber[0],
          getItemNumber[1],
          gpPoint,
          itemNumberList,
          soundEffect,
          seVolume,
        ),
      );
    }

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
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              'メッセージガチャ',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            width: 230,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: itemList[index],
                );
              },
              itemCount: itemList.length,
            ),
          ),
          const SizedBox(height: 25),
          GachaButton(
            3,
            gpPoint,
            gpCount,
            itemNumberList,
            getitemNumberList,
            soundEffect,
            seVolume,
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int itemNumber,
    int cardParcentage,
    int gpPoint,
    List<String> itemNumberList,
    AudioCache soundEffect,
    double seVolume,
  ) {
    final int needGpPoint = (50 / cardParcentage).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cardParcentage.toString() + '%',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 10),
                GpChange(
                  itemNumber,
                  needGpPoint,
                  gpPoint,
                  itemNumberList,
                  soundEffect,
                  seVolume,
                  3,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              messageSettings[itemNumber - 1].message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
