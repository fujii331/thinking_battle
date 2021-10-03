import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/title//authentication.service.dart';
import 'package:thinking_battle/widgets/title/first_setting.widget.dart';

class TitleButton extends HookWidget {
  const TitleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final String loginId = useProvider(loginIdProvider).state;

    final loadingState = useState(false);

    return SizedBox(
      height: 60,
      width: 155,
      child: ElevatedButton(
        onPressed: !loadingState.value
            ? () async {
                loadingState.value = true;
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: seVolume,
                );

                if (loginId == '') {
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

                loadingState.value = false;
              }
            : () {},
        child: Text(
          loginId == '' ? '登録する' : '始める',
          style: const TextStyle(
            fontSize: 23,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.orange.shade800,
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          shape: const StadiumBorder(),
          side: BorderSide(
            width: 3,
            color: Colors.grey.shade900,
          ),
        ),
      ),
    );
  }
}
