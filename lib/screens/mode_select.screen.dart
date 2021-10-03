import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons.widget.dart';
import 'package:thinking_battle/widgets/mode_select/my_info.widget.dart';
import 'package:thinking_battle/widgets/mode_select/play_game_buttons.widget.dart';
// import 'package:thinking_battle/widgets/common/stamina.widget.dart';

class ModeSelectScreen extends HookWidget {
  const ModeSelectScreen({Key? key}) : super(key: key);

  static const routeName = '/mode-select';

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            background(),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blueGrey.shade900.withOpacity(0.7),
            ),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // const Stamina(),
                    const SizedBox(height: 10),
                    Text(
                      'メニュー',
                      style: TextStyle(
                        color: Colors.grey.shade200,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'KaiseiOpti',
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyInfo(
                      soundEffect,
                      seVolume,
                    ),
                    const SizedBox(height: 35),
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
            ),
          ],
        ),
      ),
    );
  }
}
