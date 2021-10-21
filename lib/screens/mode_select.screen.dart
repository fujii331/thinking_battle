import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/widgets/common/stack_word.widget.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_info.widget.dart';
import 'package:thinking_battle/widgets/mode_select/play_game_buttons.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_room_button.widget.dart';

class ModeSelectScreen extends HookWidget {
  const ModeSelectScreen({Key? key}) : super(key: key);

  static const routeName = '/mode-select';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final int cardNumber = useProvider(cardNumberProvider).state;
    final List colorList = returnCardColorList(cardNumber);

    final int matchedCount = useProvider(matchedCountProvider).state;

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          title: Text(
            'メニュー',
            style: TextStyle(
              color: Colors.grey.shade200,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontFamily: 'KaiseiOpti',
            ),
          ),
          centerTitle: true,
          backgroundColor: colorList[0][1].withOpacity(0.2),
          actions: <Widget>[
            IconButton(
              iconSize: 25,
              icon: const Icon(
                Icons.home,
              ),
              onPressed: () {
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: SafeArea(
          child: SizedBox(
            width: 180,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: Drawer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: colorList[0][0],
                      stops: const [
                        0.2,
                        0.6,
                        0.9,
                      ],
                    ),
                  ),
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 25,
                        ),
                        height: 80,
                        color: colorList[0][1],
                        child: StackWord(
                          'マイルーム',
                          Colors.grey.shade200,
                          -4,
                        ),
                      ),
                      MyRoomButton(soundEffect, seVolume, colorList, 'マイデータ'),
                      MyRoomButton(soundEffect, seVolume, colorList, 'スキル'),
                      MyRoomButton(soundEffect, seVolume, colorList, 'アイコン'),
                      MyRoomButton(soundEffect, seVolume, colorList, 'テーマ'),
                      MyRoomButton(soundEffect, seVolume, colorList, 'メッセージ'),
                      MyRoomButton(soundEffect, seVolume, colorList, 'ガチャ'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: <Widget>[
            background(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // const Stamina(),
                  const SizedBox(height: 95),
                  MyInfo(
                    soundEffect,
                    seVolume,
                    cardNumber,
                    colorList,
                    matchedCount,
                  ),
                  const SizedBox(height: 28),
                  PlayGameButtons(
                    soundEffect,
                    seVolume,
                  ),
                  const Spacer(),
                  BottomIconButtons(
                    soundEffect,
                    seVolume,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
