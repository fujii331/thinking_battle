import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'dart:async';

import 'package:thinking_battle/models/send_content.model.dart';
import 'package:thinking_battle/screens/game_finish.screen.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_top.screen.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/services/game_playing/failed_connect.service.dart';
import 'package:thinking_battle/services/game_playing/update_rate.service.dart';
import 'package:thinking_battle/widgets/game_playing/disconnected.widget.dart';
import 'package:thinking_battle/widgets/game_playing/info_toast/ready.widget.dart';
import 'package:thinking_battle/widgets/game_playing/info_toast/time_limit.widget.dart';

import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/game.provider.dart';

import 'package:thinking_battle/widgets/common/background.widget.dart';
import 'package:thinking_battle/widgets/game_playing/bottom_action_buttons.widget.dart';
import 'package:thinking_battle/widgets/game_playing/content_list.widget.dart';
import 'package:thinking_battle/widgets/game_playing/top_row.widget.dart';

class GamePlayingScreen extends HookWidget {
  const GamePlayingScreen({Key? key}) : super(key: key);
  static const routeName = '/game-playing';

  void timeStart(
    BuildContext context,
    ScrollController scrollController,
    DocumentReference<Map<String, dynamic>>? myActionDoc,
    DocumentReference<Map<String, dynamic>>? rivalActionDoc,
    StreamSubscription<DocumentSnapshot>? rivalListenSubscription,
    AudioCache soundEffect,
    double seVolume,
  ) {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (context.read(myTurnFlgProvider).state) {
          final int myTurnTime = context.read(myTurnTimeProvider).state -= 1;

          // 時間切れ判定
          if (myTurnTime == 0) {
            await Future.delayed(
              const Duration(milliseconds: 500),
            );

            if (context.read(myTurnFlgProvider).state) {
              context.read(myTurnFlgProvider).state = false;

              Navigator.popUntil(context, ModalRoute.withName(routeName));

              await showDialog<int>(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const TimeLimit();
                },
              );

              final messageId = context.read(selectMessageIdProvider).state;

              // 通信対戦時は相手にデータを送る
              if (myActionDoc != null) {
                await myActionDoc
                    .set({
                      'questionId':
                          context.read(selectableQuestionsProvider).state[0].id,
                      'answer': '',
                      'skillIds': [],
                      'messageId': messageId,
                    })
                    .timeout(const Duration(seconds: 5))
                    .onError((error, stackTrace) {
                      rivalListenSubscription!.cancel();
                      failedConnect(context);
                    });
              }

              final sendContent = SendContent(
                questionId:
                    context.read(selectableQuestionsProvider).state[0].id,
                answer: '',
                skillIds: [],
                messageId: messageId,
              );

              // ターン行動実行
              turnAction(
                context,
                sendContent,
                true,
                scrollController,
                soundEffect,
                seVolume,
                rivalListenSubscription,
              );
            }
          }
        }

        if (context.read(displayRivalturnSetFlgProvider).state) {
          final int rivalTurnTime =
              context.read(rivalTurnTimeProvider).state -= 1;

          // 時間切れ判定
          if (rivalTurnTime == 0) {
            context.read(displayRivalturnSetFlgProvider).state = false;
            if (rivalListenSubscription != null) {
              // listenを解除
              rivalListenSubscription.cancel();
            }

            await rivalActionDoc!.get().then((DocumentSnapshot<Map> _) async {
              // 接続成功
              AwesomeDialog(
                context: context,
                dialogType: DialogType.ERROR,
                headerAnimationLoop: false,
                dismissOnTouchOutside: false,
                dismissOnBackKeyPress: false,
                animType: AnimType.SCALE,
                width:
                    MediaQuery.of(context).size.width * .86 > 600 ? 600 : null,
                body: const AttentionModal(
                  topText: '対戦相手の接続が切れました',
                  secondText: '結果画面に移ります。',
                ),
              ).show();

              // レート計算
              await updateRate(
                context,
                true,
              );

              context.read(timerCancelFlgProvider).state = true;

              await Future.delayed(
                const Duration(milliseconds: 3500),
              );

              Navigator.popUntil(context, ModalRoute.withName(routeName));

              Navigator.of(context).pushReplacementNamed(
                GameFinishScreen.routeName,
                arguments: true,
              );
            }).onError((error, stackTrace) {
              // 接続失敗
              failedConnect(context);
            });
          }
        }

        if (context.read(afterMessageTimeProvider).state > 0) {
          context.read(afterMessageTimeProvider).state -= 1;
        }

        if (timer.isActive && context.read(timerCancelFlgProvider).state) {
          timer.cancel();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String quizThema = useProvider(quizThemaProvider).state;

    final AudioCache soundEffect = useProvider(soundEffectProvider).state;
    final double seVolume = useProvider(seVolumeProvider).state;
    final double bgmVolume = useProvider(bgmVolumeProvider).state;
    final bool precedingFlg = useProvider(precedingFlgProvider).state;
    final bool initialTutorialFlg =
        context.read(initialTutorialFlgProvider).state;

    final PlayerInfo rivalInfo = useProvider(rivalInfoProvider).state;
    final bool myTurnFlg = useProvider(myTurnFlgProvider).state;

    final ValueNotifier<bool> displayFlgState = useState<bool>(false);

    final double widthSetting = MediaQuery.of(context).size.width > 650.0
        ? 650.0
        : MediaQuery.of(context).size.width;

    final scrollController = useScrollController();

    final DocumentReference<Map<String, dynamic>>? rivalActionDoc =
        context.read(matchingRoomIdProvider).state != ''
            ? FirebaseFirestore.instance
                .collection('playing-room')
                .doc(context.read(matchingRoomIdProvider).state)
                .collection('each-action')
                .doc(precedingFlg ? '後攻' : '先行')
            : null;

    final DocumentReference<Map<String, dynamic>>? myActionDoc =
        context.read(matchingRoomIdProvider).state != ''
            ? FirebaseFirestore.instance
                .collection('playing-room')
                .doc(context.read(matchingRoomIdProvider).state)
                .collection('each-action')
                .doc(precedingFlg ? '先行' : '後攻')
            : null;

    final List rivalColorList = returnCardColorList(rivalInfo.cardNumber);

    StreamSubscription<DocumentSnapshot>? rivalListenSubscription;

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (context.read(matchingRoomIdProvider).state != '') {
          rivalActionDoc!.delete().catchError((error) {
            // データ削除に失敗した場合、何もしない
          });

          rivalListenSubscription = rivalActionDoc.snapshots().listen(
              (DocumentSnapshot<Object?> querySnapshot) {
            SendContent sendContentSnapshot =
                SendContent.fromJson(querySnapshot);

            // ターン行動実行
            turnAction(
              context,
              sendContentSnapshot,
              false,
              scrollController,
              soundEffect,
              seVolume,
              rivalListenSubscription,
            );
          }, onError: (Object o) {
            // 接続失敗
            failedConnect(context);
          });
        }

        if (!initialTutorialFlg) {
          // チュートリアルではタイマーなし
          timeStart(
            context,
            scrollController,
            myActionDoc,
            rivalActionDoc,
            rivalListenSubscription,
            soundEffect,
            seVolume,
          );
        }

        await showDialog<int>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Ready(
              precedingFlg: precedingFlg,
              thema: quizThema,
              soundEffect: soundEffect,
              seVolume: seVolume,
            );
          },
        );

        displayFlgState.value = true;
        await Future.delayed(
          const Duration(milliseconds: 500),
        );
        context.read(bgmProvider).state = await soundEffect.loop(
          'sounds/playing.mp3',
          volume: bgmVolume,
          isNotification: true,
        );
        initializeAction(
          context,
          precedingFlg,
          [...context.read(allQuestionsProvider).state],
          soundEffect,
          seVolume,
          scrollController,
        );
      });
      return null;
    }, []);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'テーマ：' + quizThema,
            style: const TextStyle(
              fontSize: 21,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900.withOpacity(0.9),
          actions: <Widget>[
            initialTutorialFlg
                ? TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(
                      TutorialTopScreen.routeName,
                    ),
                    child: const Text(
                      "ヘルプ",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  )
                : Container(),
          ],
        ),
        body: Stack(
          children: <Widget>[
            background(),
            Center(
              child: SizedBox(
                width: widthSetting,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: displayFlgState.value ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 15,
                      bottom: 20,
                    ),
                    child: Column(
                      children: [
                        TopRow(
                          soundEffect: soundEffect,
                          seVolume: seVolume,
                          rivalInfo: rivalInfo,
                          myTurnFlg: myTurnFlg,
                          colorList: rivalColorList,
                          initialTutorialFlg: initialTutorialFlg,
                        ),
                        const SizedBox(height: 15),
                        ContentList(
                          scrollController: scrollController,
                          rivalInfo: rivalInfo,
                          rivalColorList: rivalColorList,
                        ),
                        const SizedBox(height: 20),
                        BottomActionButtons(
                          screenContext: context,
                          scrollController: scrollController,
                          myActionDoc: myActionDoc,
                          rivalListenSubscription: rivalListenSubscription,
                          soundEffect: soundEffect,
                          seVolume: seVolume,
                          myTurnFlg: myTurnFlg,
                        ),
                        Platform.isAndroid
                            ? Container()
                            : const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
