import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

class CenterRowStart extends HookWidget {
  final bool matchingFlg;
  final bool trainingFlg;
  final AudioCache soundEffect;
  final double seVolume;
  final ValueNotifier<bool> matchingQuitFlg;

  // ignore: use_key_in_widget_constructors
  const CenterRowStart(
    this.matchingFlg,
    this.trainingFlg,
    this.soundEffect,
    this.seVolume,
    this.matchingQuitFlg,
  );

  @override
  Widget build(BuildContext context) {
    final double bgmVolume = useProvider(bgmVolumeProvider).state;

    return SizedBox(
      height: 85,
      child: Center(
        child: matchingFlg
            ? Text(
                'VS',
                style: TextStyle(
                  color: Colors.orange.shade300,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  shadows: <Shadow>[
                    Shadow(
                      color: Colors.grey.shade800,
                      offset: const Offset(4, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              )
            : SizedBox(
                width: 90,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    if (context.read(matchingRoomIdProvider).state != '') {
                      // 待機中ユーザーの削除
                      FirebaseFirestore.instance
                          .collection('random-matching-room')
                          .doc(context.read(matchingRoomIdProvider).state)
                          .delete()
                          .catchError((error) async {
                        // データ削除に失敗した場合
                        // 何もしない
                      });

                      context.read(matchingRoomIdProvider).state = '';
                    } else if (context.read(matchingWaitingIdProvider).state !=
                        '') {
                      // 待機中ユーザーの削除
                      FirebaseFirestore.instance
                          .collection('random-matching-room')
                          .doc(context.read(matchingWaitingIdProvider).state)
                          .delete()
                          .catchError((error) async {
                        // データ削除に失敗した場合
                        // 何もしない
                      });

                      context.read(matchingWaitingIdProvider).state = '';
                    }

                    matchingQuitFlg.value = true;
                    soundEffect.play(
                      'sounds/cancel.mp3',
                      isNotification: true,
                      volume: seVolume,
                    );
                    context.read(bgmProvider).state.stop();
                    context.read(bgmProvider).state = await soundEffect.loop(
                      'sounds/title.mp3',
                      volume: bgmVolume,
                      isNotification: true,
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('やめる'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade400,
                    padding: const EdgeInsets.only(
                      bottom: 3,
                    ),
                    shape: const StadiumBorder(),
                    side: BorderSide(
                      width: 2,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
