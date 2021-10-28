import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/gacha_select.widget.dart';

import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/sound_mode.widget.dart';
import 'package:thinking_battle/widgets/mode_select/bottom_icon_buttons/stamp_check.widget.dart';

class BottomIconButtons extends HookWidget {
  final AudioCache soundEffect;
  final double seVolume;

  const BottomIconButtons({
    Key? key,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

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
            'music_icon',
            soundEffect,
            1,
            seVolume,
          ),
          const SizedBox(width: 5),
          _iconButton(
            context,
            'stamp_icon',
            soundEffect,
            2,
            seVolume,
          ),
          const SizedBox(width: 5),
          _iconButton(
            context,
            'gacha_icon',
            soundEffect,
            3,
            seVolume,
          ),
          const SizedBox(width: 5),
          _iconButton(
            context,
            'book_icon',
            soundEffect,
            4,
            seVolume,
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    BuildContext context,
    // Color color,
    // IconData icon,
    String imagePath,
    AudioCache soundEffect,
    int buttonPuttern,
    double seVolume,
  ) {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/' + imagePath + '.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            soundEffect.play(
              'sounds/tap.mp3',
              isNotification: true,
              volume: seVolume,
            );
            if (buttonPuttern == 1) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                headerAnimationLoop: false,
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: true,
                showCloseIcon: false,
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
                body: SoundMode(
                  soundEffect: soundEffect,
                ),
              ).show();
            } else if (buttonPuttern == 2 || buttonPuttern == 3) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.NO_HEADER,
                headerAnimationLoop: false,
                dismissOnTouchOutside: true,
                dismissOnBackKeyPress: true,
                showCloseIcon: false,
                dialogBackgroundColor: Colors.black.withOpacity(0.0),
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
                body: buttonPuttern == 2
                    ? const StampCheck()
                    : GachaSelect(
                        soundEffect: soundEffect,
                        seVolume: seVolume,
                      ),
              ).show();
            }
          },
        ),
      ),
    );
  }
}
