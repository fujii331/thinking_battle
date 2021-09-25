import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:thinking_battle/providers/common.provider.dart';

class TimeLimit extends HookWidget {
  const TimeLimit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;

    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        displayFlg1.value = true;
        soundEffect.play(
          'sounds/fault.mp3',
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg1.value ? 1 : 0,
                    child: Text(
                      '時間切れ！',
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.blueGrey.shade100,
                        fontWeight: FontWeight.bold,
                        shadows: <Shadow>[
                          Shadow(
                            color: Colors.grey.shade800,
                            offset: const Offset(3, 3),
                            blurRadius: 3.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg2.value ? 1 : 0,
                    child: Text(
                      '一番上の質問を実行します',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade100,
                        shadows: <Shadow>[
                          Shadow(
                            color: Colors.grey.shade800,
                            offset: const Offset(3, 3),
                            blurRadius: 3.0,
                          ),
                        ],
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
