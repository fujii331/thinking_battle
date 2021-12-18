import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/data/messages.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/gacha_button.widget.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/gp_change.widget.dart';

class MessageGacha extends HookWidget {
  const MessageGacha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final List<String> itemNumberList =
        useProvider(messageIdsListProvider).state;

    final int gachaPoint = useProvider(gachaPointProvider).state;
    final int gachaCount = useProvider(gachaCountProvider).state;
    final int gachaTicket = useProvider(gachaTicketProvider).state;

    final List<List<int>> getitemNumberList = [
      [5, 5],
      [6, 5],
      [7, 5],
      [8, 5],
      [9, 5],
      [10, 5],
      [11, 5],
      [12, 5],
      [13, 5],
      [14, 5],
      [15, 5],
      [16, 5],
      [17, 5],
      [18, 5],
      [19, 5],
      [20, 5],
      [21, 4],
      [22, 4],
      [23, 4],
      [24, 4],
      [25, 4],
    ];

    List<Widget> itemList = [];

    for (List<int> getItemNumber in getitemNumberList) {
      itemList.add(
        _item(
          context,
          getItemNumber[0],
          getItemNumber[1],
          gachaPoint,
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
            buttonNumber: 3,
            gachaPoint: gachaPoint,
            gachaCount: gachaCount,
            gachaTicket: gachaTicket,
            itemNumberList: itemNumberList,
            getitemNumberList: getitemNumberList,
            soundEffect: soundEffect,
            seVolume: seVolume,
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    int itemNumber,
    int cardParcentage,
    int gachaPoint,
    List<String> itemNumberList,
    AudioCache soundEffect,
    double seVolume,
  ) {
    final int needGpPoint = (25 / cardParcentage).round();

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
                  itemNumber: itemNumber,
                  needGpPoint: needGpPoint,
                  gachaPoint: gachaPoint,
                  itemNumberList: itemNumberList,
                  soundEffect: soundEffect,
                  seVolume: seVolume,
                  buttonNumber: 3,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              messageSettings[itemNumber - 1].message,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
