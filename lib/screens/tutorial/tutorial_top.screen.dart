import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_game_system.screen.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_tips.screen.dart';
import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/widgets/mode_select/menu_explain_modal.widget.dart';
import 'package:thinking_battle/widgets/tutorial_top/match_content_list_modal.widget.dart';
import 'package:thinking_battle/widgets/tutorial_top/skill_list_modal.widget.dart';

class TutorialTopScreen extends HookWidget {
  const TutorialTopScreen({Key? key}) : super(key: key);
  static const routeName = '/tutorial-top';

  @override
  Widget build(BuildContext context) {
    final bool tutorialFlg = ModalRoute.of(context)?.settings.arguments as bool;
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    const double betweenHeight = 25;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        title: Text(
          'ゲーム説明',
          style: TextStyle(
            color: Colors.grey.shade200,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'KaiseiOpti',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white.withOpacity(0),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          background(),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Column(
                  children: <Widget>[
                    _moveButton(
                      context,
                      'ゲームシステム',
                      1,
                      soundEffect,
                      seVolume,
                      true,
                    ),
                    const SizedBox(height: betweenHeight),
                    _moveButton(
                      context,
                      '対戦画面',
                      2,
                      soundEffect,
                      seVolume,
                      false,
                    ),
                    const SizedBox(height: betweenHeight),
                    _moveButton(
                      context,
                      '各スキル詳細',
                      3,
                      soundEffect,
                      seVolume,
                      false,
                    ),
                    const SizedBox(height: betweenHeight),
                    _moveButton(
                      context,
                      'Tips',
                      4,
                      soundEffect,
                      seVolume,
                      true,
                    ),
                    !tutorialFlg
                        ? Column(
                            children: [
                              const SizedBox(height: betweenHeight),
                              _moveButton(
                                context,
                                'メニュー画面',
                                5,
                                soundEffect,
                                seVolume,
                                true,
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _moveButton(
    BuildContext context,
    String text,
    int buttonNumber,
    AudioCache soundEffect,
    double seVolume,
    bool textExplainFlg,
  ) {
    return InkWell(
      onTap: () async {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );

        if (buttonNumber == 1) {
          Navigator.of(context).pushNamed(
            TutorialGameSystemScreen.routeName,
            arguments: false,
          );
        } else if (buttonNumber == 4) {
          Navigator.of(context).pushNamed(
            TutorialTipsScreen.routeName,
          );
        } else {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.NO_HEADER,
                  headerAnimationLoop: false,
                  dismissOnTouchOutside: true,
                  dismissOnBackKeyPress: true,
                  showCloseIcon: true,
                  animType: AnimType.SCALE,
                  width: MediaQuery.of(context).size.width > 420 ? 380 : null,
                  body: buttonNumber == 3
                      ? SkillListModal(
                          soundEffect: soundEffect,
                          seVolume: seVolume,
                        )
                      : buttonNumber == 2
                          ? MatchContentListModal(
                              soundEffect: soundEffect,
                              seVolume: seVolume,
                            )
                          : const MenuExplainModal(
                              tutorialFlg: false,
                            ))
              .show();
        }
      },
      child: Container(
        width: 190,
        height: 55,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topLeft,
            end: FractionalOffset.bottomRight,
            colors: textExplainFlg
                ? [
                    Colors.yellow.shade50,
                    Colors.yellow.shade100,
                    Colors.amber.shade100,
                  ]
                : [
                    Colors.grey.shade200,
                    Colors.grey.shade300,
                    Colors.blueGrey.shade200,
                  ],
            stops: const [
              0.2,
              0.6,
              0.9,
            ],
          ),
          border: Border.all(
            color:
                textExplainFlg ? Colors.yellow.shade500 : Colors.grey.shade500,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontFamily: 'KaiseiOpti',
            ),
          ),
        ),
      ),
    );
  }
}
