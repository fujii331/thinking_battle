import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';
import 'package:thinking_battle/widgets/mode_select/password_setting.widget.dart';

class PlayGameButtons extends StatelessWidget {
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
    return Column(
      children: [
        // _playButton(
        //   context,
        //   'CPUマッチ',
        //   Colors.lime.shade800,
        //   1,
        // ),
        // SizedBox(height: betweenHeight),
        _imagePlayButton(
          context,
          'ランダムマッチ',
          Colors.lightBlue.shade500,
          2,
        ),
        SizedBox(height: betweenHeight),
        _imagePlayButton(
          context,
          'フレンドマッチ',
          Colors.deepOrange.shade500,
          3,
        ),
      ],
    );
  }

  Widget _playButton(
    BuildContext context,
    String text,
    Color color,
    int buttonNumber,
  ) {
    final bool widthOk = MediaQuery.of(context).size.width > 350;

    return SizedBox(
      width: widthOk ? 210 : 180,
      height: widthOk ? null : 46,
      child: ElevatedButton(
        onPressed: () async {
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
              width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
              body: const PasswordSetting(),
            ).show();
          } else {
            context.read(friendMatchWordProvider).state = '';
            context.read(bgmProvider).state.stop();

            if (buttonNumber == 1) {
              context.read(trainingStatusProvider).state = 1;
            } else {
              context.read(trainingStatusProvider).state = 0;
            }

            Navigator.of(context).pushNamed(
              GameStartScreen.routeName,
            );
          }
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: widthOk ? 24 : 20,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: color,
          elevation: 5,
          shadowColor: Colors.grey,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 9,
          ),
          textStyle: Theme.of(context).textTheme.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            width: 2,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _imagePlayButton(
    BuildContext context,
    String text,
    Color color,
    int buttonNumber,
  ) {
    final bool widthOk = MediaQuery.of(context).size.width > 350;

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
          onTap: () {
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
                width:
                    MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
                body: const PasswordSetting(),
              ).show();
            } else {
              context.read(friendMatchWordProvider).state = '';
              context.read(bgmProvider).state.stop();

              if (buttonNumber == 1) {
                context.read(trainingStatusProvider).state = 1;
              } else {
                context.read(trainingStatusProvider).state = 0;
              }

              Navigator.of(context).pushNamed(
                GameStartScreen.routeName,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800.withOpacity(0.4),
              border: Border.all(
                color: color,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.75),
                  blurRadius: 2,
                )
              ],
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
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
