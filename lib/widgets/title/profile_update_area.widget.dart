import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/title/authentication.service.dart';

import 'package:thinking_battle/widgets/common/edit_image.widget.dart';

class ProfileUpdateArea extends HookWidget {
  final ValueNotifier<bool> buttonPressedState;

  const ProfileUpdateArea({Key? key, required this.buttonPressedState})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final int imageNumber = useProvider(imageNumberProvider).state;
    final judgeFlgState = useState(false);
    final playerNameState = useState('');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        body: EditImage(
                          soundEffect: soundEffect,
                          seVolume: seVolume,
                        ),
                      ).show();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(
                          color: Colors.grey.shade800,
                          width: 2,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/characters/' +
                            imageNumber.toString() +
                            '.png',
                        height: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '↑ タップ！',
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 25),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 13,
                        child: Text(
                          'name',
                          style: TextStyle(
                            color: Colors.blueGrey.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 35,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'タップして入力',
                          ),
                          style: const TextStyle(
                            fontFamily: 'KaiseiOpti',
                            fontSize: 14.5,
                            fontWeight: FontWeight.bold,
                          ),
                          initialValue: context.read(playerNameProvider).state,
                          onChanged: (String input) {
                            playerNameState.value = input;
                            judgeFlgState.value = input != '' &&
                                context.read(playerNameProvider).state != input;
                          },
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(
                              8,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 75,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: judgeFlgState.value
                          ? () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              soundEffect.play(
                                'sounds/tap.mp3',
                                isNotification: true,
                                volume: seVolume,
                              );
                              judgeFlgState.value = false;
                              // プレイヤー名
                              context.read(playerNameProvider).state =
                                  playerNameState.value;
                              prefs.setString(
                                  'playerName', playerNameState.value);

                              // ユーザー登録を行う
                              signUp(
                                context,
                                buttonPressedState,
                              );
                            }
                          : () {},
                      child: const Text(
                        '進む',
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: judgeFlgState.value
                            ? Colors.blue
                            : Colors.blue.shade200,
                        padding: const EdgeInsets.only(
                          bottom: 3,
                        ),
                        shape: const StadiumBorder(),
                        side: BorderSide(
                          width: 2,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
