import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'dart:io';

import 'package:thinking_battle/widgets/modal/first_setting.widget.dart';

import 'package:thinking_battle/screens/mode_select.screen.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

class TitleScreen extends HookWidget {
  const TitleScreen({Key? key}) : super(key: key);

  void _firstSetting(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // 音量設定
    final double? bgmVolume = prefs.getDouble('bgmVolume');
    final double? seVolume = prefs.getDouble('seVolume');

    if (bgmVolume != null) {
      context.read(bgmVolumeProvider).state = bgmVolume;
    } else {
      prefs.setDouble('bgmVolume', 0.2);
    }
    if (seVolume != null) {
      context.read(seVolumeProvider).state = seVolume;
    } else {
      prefs.setDouble('seVolume', 0.5);
    }

    context
        .read(bgmProvider)
        .state
        .setVolume(context.read(bgmVolumeProvider).state);

    context.read(soundEffectProvider).state.loadAll([
      'sounds/cancel.mp3',
      'sounds/change.mp3',
      'sounds/correct_answer.mp3',
      'sounds/got_message.mp3',
      'sounds/matching.mp3',
      'sounds/my_turn.mp3',
      'sounds/open_advertise.mp3',
      'sounds/question_research.mp3',
      'sounds/ready.mp3',
      'sounds/skill.mp3',
      'sounds/start.mp3',
      'sounds/tap.mp3',
      'sounds/waiting_answer.mp3',
      'sounds/wrong_answer.mp3',
    ]);

    // プレイヤー名
    context.read(playerNameProvider).state =
        prefs.getString('playerName') ?? '';
    // 画像番号
    context.read(imageNumberProvider).state = prefs.getInt('imageNumber') ?? 1;
    // レート
    context.read(rateProvider).state = prefs.getDouble('rate') ?? 500.0;
    // 最大レート
    final double maxRate = context.read(maxRateProvider).state =
        prefs.getDouble('maxRate') ?? 500.0;
    // カラー
    context.read(colorProvider).state = maxRate >= 1500
        ? Colors.purple
        : maxRate >= 1250
            ? Colors.red
            : maxRate >= 1000
                ? Colors.orange
                : maxRate >= 750
                    ? Colors.green
                    : Colors.blue;

    // スキル
    context.read(mySkillIdsListProvider).state =
        prefs.getStringList('skillList') != null
            ? prefs
                .getStringList('skillList')
                ?.map((skill) => int.parse(skill))
                .toList() as List<int>
            : [1, 2, 3];

    // ライフ
    if (prefs.getString('saveTime') != null) {
      // ライフ1つあたりの時間
      const int lifeCaluculateTime = 60 * 15;

      final DateTime savedTime = DateTime.parse(prefs.getString('saveTime')!);
      final Duration difference = DateTime.now().difference(savedTime);
      final int sec = difference.inSeconds;
      if (sec >= lifeCaluculateTime * 5) {
        context.read(lifePointProvider).state = 5;
      } else {
        final int lifePoint = (sec / lifeCaluculateTime).floor();
        context.read(lifePointProvider).state = lifePoint;

        final int remainSec = sec - lifePoint * lifeCaluculateTime;
        final int recoveryTimeMinutes = (remainSec / 60).floor();
        final int recoveryTimeSeconds = remainSec - recoveryTimeMinutes * 60;

        context.read(recoveryTimeProvider).state =
            DateTime(2020, 1, 1, 1, recoveryTimeMinutes, recoveryTimeSeconds);
      }
    }
  }

  void timeStart(
    BuildContext context,
    DateTime recoveryTime,
    int lifePoint,
    bool timerCancelFlg,
    bool myTurnFlg,
    DateTime myTurnTime,
    AudioCache soundEffect,
    double seVolume,
  ) {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (lifePoint < 5) {
          // context.read(recoveryTimeProvider).state =
          recoveryTime.add(
            const Duration(
              seconds: -1,
            ),
          );

          if (DateFormat('mm:ss').format(recoveryTime) == '00:00') {
            context.read(lifePointProvider).state = lifePoint + 1;
            context.read(recoveryTimeProvider).state =
                DateTime(2020, 1, 1, 1, 15);
          }
        }

        if (myTurnFlg) {
          // context.read(recoveryTimeProvider).state =
          myTurnTime.add(
            const Duration(
              seconds: -1,
            ),
          );
        }

        if (timer.isActive && timerCancelFlg) {
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final String playerName = useProvider(playerNameProvider).state;

    final int lifePoint = useProvider(lifePointProvider).state;
    final DateTime recoveryTime = useProvider(recoveryTimeProvider).state;
    final DateTime myTurnTime = useProvider(myTurnTimeProvider).state;
    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;

    final bool timerCancelFlg = useProvider(timerCancelFlgProvider).state;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        // if (await shouldUpdate()) {
        //   soundEffect.play(
        //     'sounds/hint.mp3',
        //     isNotification: true,
        //     volume: context.read(seVolumeProvider).state,
        //   );
        //   AwesomeDialog(
        //     context: context,
        //     dialogType: DialogType.INFO_REVERSED,
        //     headerAnimationLoop: false,
        //     animType: AnimType.BOTTOMSLIDE,
        //     width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        //     dismissOnTouchOutside: false,
        //     dismissOnBackKeyPress: false,
        //     body: UpdateVersionModal(),
        //   )..show();
        // }
        _firstSetting(context);

        timeStart(
          context,
          recoveryTime,
          lifePoint,
          timerCancelFlg,
          myTurnFlg,
          myTurnTime,
          soundEffect,
          seVolume,
        );
      });
      return null;
    }, const []);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/title_back.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Lottie.asset('assets/lottie/star.json'),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Lottie.asset('assets/lottie/panda-and-turtle.json'),
            ),
          ),
          Column(
            children: [
              const SizedBox(),
              const Spacer(),
              Row(
                children: [
                  const SizedBox(),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(
                      right: Platform.isAndroid ? 10 : 15,
                      bottom: Platform.isAndroid ? 10 : 20,
                    ),
                    child: const Text(
                      'Sant Rojas, XiaoxinChen@LottieFiles',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 7,
                    ),
                    width: 260,
                    height: 95,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 1,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.zero,
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.zero,
                      ),
                      gradient: LinearGradient(
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        colors: [
                          const Color(0xff494132).withOpacity(0.6),
                          const Color(0xff9941d8).withOpacity(0.6),
                        ],
                        stops: const [
                          0.0,
                          1.0,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'VS水平思考',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            height: 1.2,
                            fontSize: 42,
                            fontFamily: 'KaiseiOpti',
                            fontWeight: FontWeight.w800,
                            color: Colors.orange.shade200,
                          ),
                        ),
                        Text(
                          'どっちが先に思いつく？',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red.shade50,
                            fontSize: 20,
                            fontFamily: 'Stick',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 90),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    width: 160,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );

                          if (playerName == '') {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              headerAnimationLoop: false,
                              dismissOnTouchOutside: false,
                              dismissOnBackKeyPress: false,
                              animType: AnimType.SCALE,
                              width:
                                  MediaQuery.of(context).size.width * .86 > 650
                                      ? 650
                                      : null,
                              body: const FirstSetting(),
                            ).show();
                          } else {
                            Navigator.of(context).pushNamed(
                              ModeSelectScreen.routeName,
                            );
                          }
                        },
                        child: Text(
                          playerName == '' ? 'サインアップ' : 'ログイン',
                          style: TextStyle(
                            color: Colors.blueGrey.shade50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange.shade700,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          textStyle: Theme.of(context).textTheme.button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
