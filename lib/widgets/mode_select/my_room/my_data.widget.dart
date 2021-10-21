import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/providers/player.provider.dart';

class MyData extends HookWidget {
  const MyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double rate = useProvider(rateProvider).state;
    final double maxRate = useProvider(maxRateProvider).state;
    final int matchCount = useProvider(matchedCountProvider).state;
    final int winCount = useProvider(winCountProvider).state;
    final int maxContinuousWinCount =
        useProvider(maxContinuousWinCountProvider).state;

    final judgeFlgState = useState(false);
    final playerNameState = useState('');

    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        bottom: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, size: 25, color: Colors.black),
              ),
            ],
          ),
          const Text(
            'マイデータ',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 22),
            child: Column(
              children: [
                Row(
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
                          width: 130,
                          height: 35,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'タップして入力',
                            ),
                            style: const TextStyle(
                              fontFamily: 'KaiseiOpti',
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                            ),
                            initialValue:
                                context.read(playerNameProvider).state,
                            onChanged: (String input) {
                              playerNameState.value = input;
                              judgeFlgState.value = input != '' &&
                                  context.read(playerNameProvider).state !=
                                      input;
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
                    const SizedBox(width: 15),
                    SizedBox(
                      width: 55,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: judgeFlgState.value
                            ? () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                soundEffect.play(
                                  'sounds/change.mp3',
                                  isNotification: true,
                                  volume: seVolume,
                                );
                                judgeFlgState.value = false;
                                // プレイヤー名
                                context.read(playerNameProvider).state =
                                    playerNameState.value;
                                prefs.setString(
                                    'playerName', playerNameState.value);
                              }
                            : () {},
                        child: const Text(
                          '更新',
                          style: TextStyle(
                            fontSize: 16,
                          ),
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
          const SizedBox(height: 25),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: <Widget>[
                      _itemLabel('レート'),
                      _itemLabel('最大レート'),
                      _itemLabel('対戦回数'),
                      _itemLabel('勝ち数'),
                      _itemLabel('最大連勝数'),
                    ],
                  ),
                  const SizedBox(width: 25),
                  Column(
                    children: <Widget>[
                      _item(rate.toString()),
                      _item(maxRate.toString()),
                      _item(matchCount.toString()),
                      _item(winCount.toString()),
                      _item(maxContinuousWinCount.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _itemLabel(
    String label,
  ) {
    return SizedBox(
      height: 40,
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blueGrey.shade900,
          fontSize: 20,
          fontFamily: 'KaiseiOpti',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _item(
    String item,
  ) {
    return SizedBox(
      height: 40,
      child: Text(
        item,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'KaiseiOpti',
        ),
      ),
    );
  }
}
