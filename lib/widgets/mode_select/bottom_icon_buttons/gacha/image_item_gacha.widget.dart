import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/gacha_button.widget.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/gp_change.widget.dart';

class ImageItemGacha extends HookWidget {
  final int buttonNumber;

  const ImageItemGacha({
    Key? key,
    required this.buttonNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final bool iconGachaFlg = buttonNumber == 1;

    final List<String> itemNumberList = iconGachaFlg
        ? useProvider(imageNumberListProvider).state
        : useProvider(cardNumberListProvider).state;

    final int gachaPoint = useProvider(gachaPointProvider).state;
    final int gachaCount = useProvider(gachaCountProvider).state;
    final int gachaTicket = useProvider(gachaTicketProvider).state;

    final List<List<int>> getitemNumberList = iconGachaFlg
        ? [
            [7, 10],
            [8, 10],
            [9, 10],
            [10, 10],
            [11, 7],
            [12, 7],
            [13, 7],
            [14, 5],
            [15, 5],
            [16, 5],
            [17, 5],
            [18, 4],
            [19, 4],
            [20, 4],
            [21, 2],
            [22, 2],
            [23, 2],
            [24, 1],
          ]
        : [
            [5, 10],
            [6, 10],
            [7, 10],
            [8, 10],
            [9, 8],
            [10, 8],
            [11, 7],
            [12, 7],
            [13, 7],
            [14, 7],
            [15, 5],
            [16, 5],
            [17, 2],
            [18, 2],
            [19, 1],
            [20, 1],
          ];

    final List<Widget> cardRowList = [];
    List<Widget> itemList = [];

    for (List<int> getItemNumber in getitemNumberList) {
      itemList.add(
        _item(
          context,
          iconGachaFlg,
          getItemNumber[0],
          getItemNumber[1],
          gachaPoint,
          itemNumberList,
          soundEffect,
          seVolume,
        ),
      );

      // 3個たまったらRowに追加
      if (itemList.length == 3) {
        cardRowList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              itemList[0],
              itemList[1],
              itemList[2],
            ],
          ),
        );

        itemList = [];
      }
    }

    if (itemList.isNotEmpty) {
      cardRowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            itemList[0],
            itemList.length > 1
                ? itemList[1]
                : const SizedBox(height: 60, width: 60),
            const SizedBox(height: 60, width: 60),
          ],
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
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              iconGachaFlg ? 'アイコンガチャ' : 'テーマガチャ',
              style: const TextStyle(
                fontSize: 20.0,
                fontFamily: 'NotoSansJP',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 210,
            width: 230,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: cardRowList[index],
                );
              },
              itemCount: cardRowList.length,
            ),
          ),
          const SizedBox(height: 25),
          GachaButton(
            buttonNumber: buttonNumber,
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
    bool iconGachaFlg,
    int itemNumber,
    int itemParcentage,
    int gachaPoint,
    List<String> itemNumberList,
    AudioCache soundEffect,
    double seVolume,
  ) {
    final int needGpPoint = (50 / itemParcentage).round();
    final double minusSize = MediaQuery.of(context).size.width > 400 ? 0 : 5;

    return Column(
      children: [
        Text(
          itemParcentage.toString() + '%',
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: (iconGachaFlg ? 60 : 63) - minusSize,
          height: (iconGachaFlg ? 60 : 36) - minusSize,
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
        const SizedBox(height: 5),
        GpChange(
          itemNumber: itemNumber,
          needGpPoint: needGpPoint,
          gachaPoint: gachaPoint,
          itemNumberList: itemNumberList,
          soundEffect: soundEffect,
          seVolume: seVolume,
          buttonNumber: buttonNumber,
        ),
      ],
    );
  }
}
