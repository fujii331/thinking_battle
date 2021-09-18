import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/services/title//authentication.service.dart';
import 'package:thinking_battle/widgets/title/first_setting.widget.dart';

class TitleButton extends HookWidget {
  final ValueNotifier<bool> loadingState;
  final bool firstPlayingFlg;

  // ignore: use_key_in_widget_constructors
  const TitleButton(
    this.loadingState,
    this.firstPlayingFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      width: 160,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: loadingState.value
              ? () async {
                  loadingState.value = false;
                  soundEffect.play(
                    'sounds/tap.mp3',
                    isNotification: true,
                    volume: seVolume,
                  );

                  if (firstPlayingFlg) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.NO_HEADER,
                      headerAnimationLoop: false,
                      dismissOnTouchOutside: false,
                      dismissOnBackKeyPress: false,
                      animType: AnimType.SCALE,
                      width: MediaQuery.of(context).size.width * .86 > 650
                          ? 650
                          : null,
                      body: const FirstSetting(),
                    ).show();
                  } else {
                    login(context);
                  }
                }
              : () {},
          child: Text(
            firstPlayingFlg ? '登録' : '遊ぶ',
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
    );
  }
}
