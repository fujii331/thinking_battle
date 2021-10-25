import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/game_start.screen.dart';

class PasswordSetting extends HookWidget {
  const PasswordSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> passwordState = useState('');
    final ValueNotifier<bool> judgeFlgState = useState(false);
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
        bottom: 23,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(
              top: 10,
              bottom: 25,
            ),
            child: Text(
              '3文字以上のあいことばを入力',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
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
              onChanged: (String input) {
                passwordState.value = input;
                judgeFlgState.value = input.length > 2;
              },
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(
                  8,
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 100,
            height: 40,
            child: ElevatedButton(
              child: const Text('進む'),
              style: ElevatedButton.styleFrom(
                primary: judgeFlgState.value
                    ? Colors.orange.shade600
                    : Colors.orange.shade200,
                padding: const EdgeInsets.only(
                  bottom: 3,
                ),
                shape: const StadiumBorder(),
                side: BorderSide(
                  width: 2,
                  color: Colors.orange.shade700,
                ),
              ),
              onPressed: judgeFlgState.value
                  ? () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      context.read(rivalInfoProvider).state = dummyPlayerInfo;
                      context.read(bgmProvider).state.stop();
                      context.read(trainingProvider).state = false;

                      context.read(friendMatchWordProvider).state =
                          passwordState.value;

                      Navigator.pop(context);

                      Navigator.of(context).pushNamed(
                        GameStartScreen.routeName,
                      );
                    }
                  : () {},
            ),
          ),
        ],
      ),
    );
  }
}
