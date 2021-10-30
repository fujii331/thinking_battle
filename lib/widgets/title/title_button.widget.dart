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
  final ValueNotifier<bool> displayFlg;

  const TitleButton({
    Key? key,
    required this.displayFlg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final String loginId = useProvider(loginIdProvider).state;

    final buttonPressedState = useState(false);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: displayFlg.value ? 1 : 0,
      child: Container(
        height: 65,
        width: 125,
        decoration: BoxDecoration(
          color: !buttonPressedState.value
              ? Colors.white.withOpacity(0)
              : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage('assets/images/play.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: !buttonPressedState.value
                ? () async {
                    buttonPressedState.value = true;
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
                        body: FirstSetting(
                          buttonPressedState: buttonPressedState,
                        ),
                      ).show();
                    } else {
                      login(context, buttonPressedState);
                    }
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
