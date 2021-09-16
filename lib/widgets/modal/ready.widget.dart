import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import '../../providers/common.provider.dart';

class Ready extends HookWidget {
  final bool precedingFlg;
  final String thema;

  // ignore: use_key_in_widget_constructors
  const Ready(
    this.precedingFlg,
    this.thema,
  );

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;

    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);
    final displayFlg3 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        displayFlg1.value = true;
        soundEffect.play(
          'sounds/ready.mp3',
          isNotification: true,
          volume: seVolume,
        );
        await Future.delayed(
          const Duration(milliseconds: 1500),
        );
        displayFlg2.value = true;
        await Future.delayed(
          const Duration(milliseconds: 1500),
        );
        displayFlg3.value = true;
        await Future.delayed(
          const Duration(milliseconds: 1500),
        );
        Navigator.pop(context);
      });
      return null;
    }, const []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Theme(
        data: Theme.of(context)
            .copyWith(dialogBackgroundColor: Colors.white.withOpacity(0.0)),
        child: SimpleDialog(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg1.value ? 1 : 0,
                    child: Text(
                      'テーマ：' + thema,
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.blueGrey.shade100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg2.value ? 1 : 0,
                    child: Row(
                      children: [
                        Text(
                          'あなたは',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade100,
                          ),
                        ),
                        Text(
                          precedingFlg ? '先行' : '後攻',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: precedingFlg
                                ? Colors.red.shade500
                                : Colors.blue.shade500,
                          ),
                        ),
                        Text(
                          'です',
                          style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg3.value ? 1 : 0,
                    child: Text(
                      rivalInfo.name + 'との対戦開始！',
                      style: TextStyle(
                        fontSize: 28.0,
                        color: Colors.blueGrey.shade100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
