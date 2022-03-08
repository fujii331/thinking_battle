import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/providers/game.provider.dart';

class Ready extends HookWidget {
  final bool precedingFlg;
  final String thema;
  final AudioCache soundEffect;
  final double seVolume;

  const Ready({
    Key? key,
    required this.precedingFlg,
    required this.thema,
    required this.soundEffect,
    required this.seVolume,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayFlg1 = useState<bool>(false);
    final displayFlg2 = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await Future.delayed(
          const Duration(milliseconds: 700),
        );
        displayFlg1.value = true;
        soundEffect.play(
          'sounds/ready.mp3',
          isNotification: true,
          volume: seVolume,
        );
        await Future.delayed(
          const Duration(milliseconds: 1600),
        );
        displayFlg2.value = true;
        await Future.delayed(
          const Duration(milliseconds: 2000),
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
                  // context.read(isEventMatchProvider).state
                  //     ? SizedBox(
                  //         child: Column(
                  //           children: [
                  //             Text(
                  //               '~ランダムスキルマッチ~\n初期装備スキルがランダムに',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(
                  //                 fontSize: 20,
                  //                 color: Colors.purple.shade100,
                  //                 fontWeight: FontWeight.bold,
                  //                 shadows: const [
                  //                   Shadow(
                  //                     color: Colors.black,
                  //                     offset: Offset(1, 1),
                  //                     blurRadius: 1,
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //             const SizedBox(height: 50),
                  //           ],
                  //         ),
                  //       )
                  //     : Container(),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg1.value ? 1 : 0,
                    child: Text(
                      'テーマ：' + thema,
                      style: TextStyle(
                        fontSize: 26.0,
                        color: Colors.blueGrey.shade100,
                        fontFamily: 'NotoSansJP',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: displayFlg2.value ? 1 : 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'あなたは',
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade100,
                          ),
                        ),
                        Text(
                          precedingFlg ? '先攻' : '後攻',
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
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade100,
                          ),
                        ),
                      ],
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
