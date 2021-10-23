import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/player.provider.dart';

class EditTheme extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const EditTheme({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> cardNumberList =
        useProvider(cardNumberListProvider).state;

    final List<Widget> cardRowList = [];
    List<Widget> cardList = [];

    for (String cardNumberString in cardNumberList) {
      // 画像をcardListに追加
      cardList.add(
        _cardSelect(
          context,
          int.parse(cardNumberString),
        ),
      );

      // 3個たまったらRowに追加
      if (cardList.length == 3) {
        cardRowList.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              cardList[0],
              cardList[1],
              cardList[2],
            ],
          ),
        );

        cardList = [];
      }
    }

    if (cardList.isNotEmpty) {
      cardRowList.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardList[0],
            cardList.length > 1
                ? cardList[1]
                : const SizedBox(
                    width: 63,
                    height: 36,
                  ),
            const SizedBox(
              width: 63,
              height: 36,
            ),
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
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              'テーマにしたい画像をタップ！',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: cardRowList.length > 2 ? 180 : 120,
            width: 230,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: cardRowList[index],
                );
              },
              itemCount: cardRowList.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardSelect(
    BuildContext context,
    int themeNumber,
  ) {
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        soundEffect.play(
          'sounds/change.mp3',
          isNotification: true,
          volume: seVolume,
        );
        context.read(cardNumberProvider).state = themeNumber;
        prefs.setInt('cardNumber', themeNumber);
        Navigator.pop(context);
      },
      child: Container(
        width: 63,
        height: 36,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(
                'assets/images/cards/' + themeNumber.toString() + '.png'),
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
    );
  }
}
