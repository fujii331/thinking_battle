import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/image_item_gacha.widget.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha/message_gacha.widget.dart';

class GachaSelect extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const GachaSelect({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int gachaPoint = useProvider(gachaPointProvider).state;
    final int gachaCount = useProvider(gachaCountProvider).state;
    final int gachaTicket = useProvider(gachaTicketProvider).state;

    return Stack(
      children: [
        Container(
          height: 420,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/background/gacha.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 35,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Icon(Icons.close, size: 25, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'ガチャでアイテム取得！\n溜まったGPと交換も！',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                '所持ガチャチケ：' + gachaTicket.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontSize: 15.0,
                ),
              ),
              Text(
                '本日の残り動画ガチャ：' + gachaCount.toString() + '回',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontSize: 15.0,
                ),
              ),
              Text(
                '所持GP：' + gachaPoint.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'NotoSansJP',
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 20),
              _gachaButton(
                context,
                'アイコンガチャ',
                1,
              ),
              const SizedBox(height: 20),
              _gachaButton(
                context,
                'テーマガチャ',
                2,
              ),
              const SizedBox(height: 20),
              _gachaButton(
                context,
                'メッセージガチャ',
                3,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gachaButton(
    BuildContext context,
    String text,
    int buttonNumber,
  ) {
    return InkWell(
      onTap: () async {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );

        AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          headerAnimationLoop: false,
          dismissOnTouchOutside: true,
          dismissOnBackKeyPress: true,
          showCloseIcon: true,
          animType: AnimType.SCALE,
          width: MediaQuery.of(context).size.width * .86 > 400 ? 400 : null,
          body: buttonNumber == 3
              ? const MessageGacha()
              : ImageItemGacha(
                  buttonNumber: buttonNumber,
                ),
        ).show();
      },
      child: Container(
        width: 190,
        height: 50,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: buttonNumber == 1
                ? [
                    Colors.cyan.shade200,
                    Colors.lightBlue.shade200,
                    Colors.blue.shade300,
                  ]
                : buttonNumber == 2
                    ? [
                        Colors.lime.shade300,
                        Colors.lightGreen.shade200,
                        Colors.green.shade200,
                      ]
                    : [
                        Colors.pink.shade100,
                        Colors.red.shade200,
                        Colors.deepOrange.shade200,
                      ],
            stops: const [
              0.2,
              0.6,
              0.9,
            ],
          ),
          border: Border.all(
            color: buttonNumber == 1
                ? Colors.blue
                : buttonNumber == 2
                    ? Colors.green
                    : Colors.red,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                buttonNumber == 1
                    ? Icon(
                        Icons.account_circle,
                        color: Colors.blue.shade700,
                        size: 21,
                      )
                    : buttonNumber == 2
                        ? Icon(
                            Icons.color_lens,
                            color: Colors.green.shade700,
                            size: 21,
                          )
                        : Icon(
                            Icons.mail,
                            color: Colors.red.shade700,
                            size: 21,
                          ),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontFamily: 'NotoSansJP',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
