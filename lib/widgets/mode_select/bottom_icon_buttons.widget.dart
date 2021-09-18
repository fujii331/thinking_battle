import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/my_room.widget.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/sound_mode.widget.dart';

class BottomIconButtons extends HookWidget {
  const BottomIconButtons({Key? key}) : super(key: key);

  void toSoundMode(BuildContext context) => AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: const SoundMode(),
      )..show();

  void toMyRoom(
    BuildContext context,
    TextEditingController playerNameController,
  ) =>
      AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: false,
        dismissOnTouchOutside: true,
        dismissOnBackKeyPress: true,
        animType: AnimType.SCALE,
        width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
        body: MyRoom(playerNameController),
      ).show();

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final playerNameController = useTextEditingController();

    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconButton(
            context,
            Colors.yellow.shade100,
            Icons.account_circle,
            soundEffect,
            1,
            seVolume,
            playerNameController,
          ),
          _iconButton(
            context,
            Colors.blue,
            Icons.audiotrack,
            soundEffect,
            2,
            seVolume,
            null,
          ),
          _iconButton(
            context,
            Colors.green.shade300,
            Icons.auto_stories,
            soundEffect,
            3,
            seVolume,
            null,
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
    TextEditingController? playerNameController,
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
          // toWarewolfSettingTab(context);
        } else if (buttonPuttern == 2) {
          toSoundMode(context);
        } else if (buttonPuttern == 3) {
          playerNameController!.text = context.read(playerNameProvider).state;
          toMyRoom(
            context,
            playerNameController,
          );
        }
      },
    );
  }
}
