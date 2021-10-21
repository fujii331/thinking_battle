import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';

class CenterRowStart extends HookWidget {
  final bool matchingFinishedFlg;
  final bool trainingFlg;
  final AudioCache soundEffect;
  final double seVolume;
  final ValueNotifier<bool> matchingQuitFlg;

  // ignore: use_key_in_widget_constructors
  const CenterRowStart(
    this.matchingFinishedFlg,
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
        child: matchingFinishedFlg
            ? Container(
                // height: 50,
                width: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('assets/images/vs.png'),
                  ),
                ),
              )
            : SizedBox(
                width: 90,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    matchingQuitFlg.value = true;

                    final bool deleteFlg =
                        context.read(matchingWaitingIdProvider).state != '';
                    final String roomDocument =
                        context.read(friendMatchWordProvider).state != ''
                            ? 'friend-matching-room'
                            : 'random-matching-room';
                    final String matchingWaitingId =
                        context.read(matchingWaitingIdProvider).state;

                    context.read(matchingWaitingIdProvider).state = '';
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

                    Navigator.popUntil(context,
                        ModalRoute.withName(ModeSelectScreen.routeName));

                    await Future.delayed(
                      const Duration(milliseconds: 700),
                    );
                    if (deleteFlg) {
                      // 待機中ユーザーの削除
                      FirebaseFirestore.instance
                          .collection(roomDocument)
                          .doc(matchingWaitingId)
                          .delete()
                          .catchError((error) async {
                        // データ削除に失敗した場合
                        // 何もしない
                      });
                    }
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
