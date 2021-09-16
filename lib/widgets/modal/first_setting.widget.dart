import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';

import 'package:thinking_battle/widgets/modal/edit_image.widget.dart';

class FirstSetting extends HookWidget {
  const FirstSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;

    final playerNameController = useTextEditingController();
    final imageNumberState = useState(1);

    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 25,
            ),
            child: Text(
              '名前とアイコンを設定',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Wrap(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 9),
                child: Text(
                  '名前',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              // const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.only(left: 25),
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
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  const Text(
                    'アイコン',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '画像タップ→',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 35),
              InkWell(
                onTap: () {
                  soundEffect.play(
                    'sounds/tap.mp3',
                    isNotification: true,
                    volume: 0.5,
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
                    body: EditImage(imageNumberState),
                  ).show();
                },
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.asset(
                      'assets/images/' +
                          imageNumberState.value.toString() +
                          '.png',
                      height: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 12,
            ),
            child: Text(
              '※後から変更できます',
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'SawarabiGothic',
                color: Colors.grey.shade800,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
            ),
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                soundEffect.play(
                  'sounds/tap.mp3',
                  isNotification: true,
                  volume: 0.5,
                );
                // プレイヤー名
                context.read(playerNameProvider).state =
                    playerNameController.text;
                prefs.setString('playerName', playerNameController.text);
                // 画像番号
                context.read(imageNumberProvider).state =
                    imageNumberState.value;
                prefs.setInt('imageNumber', imageNumberState.value);
                // TODO 遊び方にとぶ
                Navigator.of(context).pushNamed(
                  ModeSelectScreen.routeName,
                );
              },
              child: const Text(
                '進む',
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
    );
  }
}
