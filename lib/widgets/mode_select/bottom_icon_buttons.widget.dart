import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/sound_mode.widget.dart';

class BottomIconButtons extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const BottomIconButtons({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  void toSoundMode(BuildContext context) => AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        showCloseIcon: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: SoundMode(
          soundEffect: soundEffect,
        ),
      )..show();

  @override
  Widget build(BuildContext context) {
    // final playerNameController = useTextEditingController();

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconButton(
            context,
            Colors.blue,
            Icons.audiotrack,
            soundEffect,
            1,
            seVolume,
            // null,
          ),
          _iconButton(
            context,
            Colors.green.shade300,
            Icons.auto_stories,
            soundEffect,
            2,
            seVolume,
            // null,
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    BuildContext context,
    Color color,
    IconData icon,
    AudioCache soundEffect,
    int buttonPuttern,
    double seVolume,
    // TextEditingController? playerNameController,
  ) {
    return IconButton(
      iconSize: 28,
      icon: Icon(
        icon,
        color: color,
      ),
      onPressed: () {
        soundEffect.play(
          'sounds/tap.mp3',
          isNotification: true,
          volume: seVolume,
        );
        if (buttonPuttern == 1) {
          toSoundMode(context);
        } else if (buttonPuttern == 2) {
          // playerNameController!.text = context.read(playerNameProvider).state;
          // toMyRoom(
          //   context,
          //   playerNameController,
          // );
        }
      },
    );
  }
}
