import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';
import 'package:thinking_battle/widgets/mode_select/event_ranking_modal.widget.dart';
import 'package:thinking_battle/widgets/mode_select/password_setting.widget.dart';

class PlayGameButtons extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;
  final double betweenHeight;

  const PlayGameButtons({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
    required this.betweenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final DateTime now = DateTime.now();
    // // 2021/12/28 ~ 2022/1/14の範囲内の場合
    // final bool isRankingDisplayPeriod =
    //     now.isBefore(DateTime(2022, 1, 15, 0, 0)) &&
    //         now.isAfter(DateTime(2021, 12, 29, 0, 0));

    return Column(
      children: [
        _imagePlayButton(
          context,
          'ランダムマッチ',
          Colors.lightBlue,
          2,
        ),
        SizedBox(height: betweenHeight),
        _imagePlayButton(
          context,
          'フレンドマッチ',
          Colors.deepOrange,
          3,
        ),
        SizedBox(height: betweenHeight),
        // Text(
        //   '2021/12/28 ~ 2022/01/07\n21:00 ~ 23:00限定',
        //   // '期間＆時間限定イベント\n近日開催！',
        //   style: TextStyle(
        //     color: Colors.grey.shade200,
        //     fontFamily: 'KaiseiOpti',
        //     fontSize: 14,
        //   ),
        // ),
        // const SizedBox(height: 8),
        // _imagePlayButton(
        //   context,
        //   'イベントマッチ',
        //   Colors.lightGreen,
        //   1,
        // ),
        // isRankingDisplayPeriod
        //     ? Column(
        //         children: [
        //           const SizedBox(height: 15),
        //           InkWell(
        //             onTap: () async {
        //               soundEffect.play(
        //                 'sounds/tap.mp3',
        //                 isNotification: true,
        //                 volume: seVolume,
        //               );

        //               AwesomeDialog(
        //                 context: context,
        //                 dialogType: DialogType.NO_HEADER,
        //                 headerAnimationLoop: false,
        //                 dismissOnTouchOutside: true,
        //                 dismissOnBackKeyPress: true,
        //                 showCloseIcon: true,
        //                 animType: AnimType.SCALE,
        //                 width: MediaQuery.of(context).size.width > 420
        //                     ? 380
        //                     : null,
        //                 body: const EventRankingModal(),
        //               ).show();
        //             },
        //             child: Container(
        //               height: 45,
        //               width: 160,
        //               decoration: BoxDecoration(
        //                 gradient: LinearGradient(
        //                   begin: FractionalOffset.topLeft,
        //                   end: FractionalOffset.bottomRight,
        //                   colors: [
        //                     Colors.yellow.shade100,
        //                     Colors.yellow.shade300,
        //                   ],
        //                   stops: const [
        //                     0.2,
        //                     0.7,
        //                   ],
        //                 ),
        //                 border: Border.all(
        //                   color: Colors.grey,
        //                   width: 1.5,
        //                 ),
        //                 borderRadius: const BorderRadius.all(
        //                   Radius.circular(10),
        //                 ),
        //               ),
        //               child: Center(
        //                 child: Padding(
        //                   padding: EdgeInsets.only(
        //                     bottom: Platform.isAndroid ? 1 : 0,
        //                     top: Platform.isAndroid ? 0 : 1,
        //                   ),
        //                   child: const Text(
        //                     'イベントランキング',
        //                     style: TextStyle(
        //                       fontSize: 16,
        //                       fontFamily: 'KaiseiOpti',
        //                       color: Colors.black,
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           )
        //         ],
        //       )
        //     : Container(),
      ],
    );
  }

  Widget _imagePlayButton(
    BuildContext context,
    String text,
    MaterialColor color,
    int buttonNumber,
  ) {
    final bool widthOk = MediaQuery.of(context).size.width > 350;
    final bool enableEvent = context.read(enableEventProvider).state;
    final bool enablePushButton = buttonNumber != 1 || enableEvent;

    return Container(
      width: widthOk ? 205 : 180,
      height: widthOk ? 52 : 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/images/game_buttons/game_button_' +
              buttonNumber.toString() +
              '.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: enablePushButton
              ? () {
                  soundEffect.play(
                    'sounds/tap.mp3',
                    isNotification: true,
                    volume: seVolume,
                  );

                  if (buttonNumber == 3) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      headerAnimationLoop: false,
                      dismissOnTouchOutside: true,
                      dismissOnBackKeyPress: true,
                      showCloseIcon: true,
                      animType: AnimType.SCALE,
                      width: MediaQuery.of(context).size.width * .86 > 550
                          ? 550
                          : null,
                      body: const PasswordSetting(),
                    ).show();
                  } else {
                    context.read(friendMatchWordProvider).state = '';
                    context.read(bgmProvider).state.stop();

                    if (buttonNumber == 1) {
                      context.read(isEventMatchProvider).state = true;
                    } else {
                      context.read(isEventMatchProvider).state = false;
                    }

                    Navigator.of(context).pushNamed(
                      GameStartScreen.routeName,
                    );
                  }
                }
              : null,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800.withOpacity(0.4),
              border: Border.all(
                color: color,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: enablePushButton
                      ? color.shade500.withOpacity(0.75)
                      : color.shade300.withOpacity(0.85),
                  blurRadius: 2,
                )
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: enablePushButton ? Colors.white : Colors.grey.shade400,
                  fontFamily: 'KaiseiOpti',
                  fontSize: widthOk ? 24 : 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
