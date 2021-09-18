import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/services/title/authentication.service.dart';

import 'package:thinking_battle/widgets/common/edit_image.widget.dart';

class ProfileUpdateArea extends HookWidget {
  final TextEditingController playerNameController;
  final bool firstSettingFlg;

  // ignore: use_key_in_widget_constructors
  const ProfileUpdateArea(
    this.playerNameController,
    this.firstSettingFlg,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final MaterialColor color = useProvider(colorProvider).state;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.NO_HEADER,
                        headerAnimationLoop: false,
                        dismissOnTouchOutside: true,
                        dismissOnBackKeyPress: true,
                        showCloseIcon: true,
                        animType: AnimType.SCALE,
                        width: MediaQuery.of(context).size.width * .86 > 650
                            ? 650
                            : null,
                        body: const EditImage(),
                      ).show();
                    },
                    child: Container(
                      width: 85,
                      height: 85,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: color,
                          width: 4,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Image.asset(
                          'assets/images/' + imageNumber.toString() + '.png',
                          height: 50,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '↑タップで変更',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                children: [
                  const SizedBox(
                    height: 15,
                    child: Text(
                      'name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 160,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'タップして入力',
                      ),
                      controller: playerNameController,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(
                          8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: ElevatedButton(
                  onPressed: playerNameController.text != ''
                      ? () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          soundEffect.play(
                            'sounds/tap.mp3',
                            isNotification: true,
                            volume: seVolume,
                          );
                          // プレイヤー名
                          context.read(playerNameProvider).state =
                              playerNameController.text;
                          prefs.setString(
                              'playerName', playerNameController.text);

                          if (firstSettingFlg) {
                            // ユーザー登録を行う
                            signUp(context);
                          }
                        }
                      : () {},
                  child: Text(
                    firstSettingFlg ? '進む' : '更新',
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: playerNameController.text != ''
                        ? Colors.blue
                        : Colors.blue.shade200,
                    textStyle: Theme.of(context).textTheme.button,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
