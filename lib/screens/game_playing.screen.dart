import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'dart:async';

import 'package:thinking_battle/models/send_content.model.dart';
import 'package:thinking_battle/screens/tutorial/tutorial_top.screen.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/services/game_playing/common_action.service.dart';
import 'package:thinking_battle/services/game_playing/cpu_action.service.dart';
import 'package:thinking_battle/services/game_playing/failed_connect.service.dart';
import 'package:thinking_battle/widgets/game_playing/answer_candidate_modal.widget.dart';
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
    bool initialTutorialFlg,
    ValueNotifier<bool> displayUpdateFlgState,
  ) {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (context.read(myTurnFlgProvider).state && !initialTutorialFlg) {
          final int myTurnTime = context.read(myTurnTimeProvider).state -= 1;

          // 時間切れ判定
          if (myTurnTime == 0) {
            await Future.delayed(
              const Duration(milliseconds: 500),
            );

            if (context.read(myTurnFlgProvider).state) {
              context.read(myTurnFlgProvider).state = false;

              Navigator.popUntil(context, ModalRoute.withName(routeName));

              if (!context.read(backgroundProvider).state) {
                await showDialog<int>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const TimeLimit();
                  },
                );
              }

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
                displayUpdateFlgState,
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

            final ConnectivityResult connectivityResult =
                await (Connectivity().checkConnectivity());

            if (connectivityResult != ConnectivityResult.none) {
              EasyLoading.showToast(
                '相手の接続が切れたのでCPUに切り替えます',
                duration: const Duration(milliseconds: 2000),
                toastPosition: EasyLoadingToastPosition.center,
                dismissOnTap: true,
              );

              if (context.read(trainingStatusProvider).state == 0) {
                // 対戦部屋
                DocumentReference<Map<String, dynamic>>? playingRoomDoc =
                    FirebaseFirestore.instance
                        .collection('playing-room')
                        .doc(context.read(matchingRoomIdProvider).state);

                playingRoomDoc.delete().catchError((error) {
                  // データ削除に失敗した場合、何もしない
                });
              }

              context.read(trainingStatusProvider).state = 2;

              cpuAction(
                context,
                scrollController,
                soundEffect,
                seVolume,
                true,
                displayUpdateFlgState,
              );
            } else {
              // 接続失敗
              failedConnect(context);
            }
          }
        }

        if (context.read(afterMessageTimeProvider).state > 0) {
          context.read(afterMessageTimeProvider).state -= 1;
        }

        if (context.read(afterRivalMessageTimeProvider).state > 0) {
          context.read(afterRivalMessageTimeProvider).state -= 1;
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
                .doc(precedingFlg ? '後攻' : '先攻')
            : null;

    final DocumentReference<Map<String, dynamic>>? myActionDoc =
        context.read(matchingRoomIdProvider).state != ''
            ? FirebaseFirestore.instance
                .collection('playing-room')
                .doc(context.read(matchingRoomIdProvider).state)
                .collection('each-action')
                .doc(precedingFlg ? '先攻' : '後攻')
            : null;

    final List rivalColorList = returnCardColorList(rivalInfo.cardNumber);

    StreamSubscription<DocumentSnapshot>? rivalListenSubscription;

    final ValueNotifier<bool> displayUpdateFlgState = useState(false);

    useEffect(() {
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        if (context.read(matchingRoomIdProvider).state != '') {
          await rivalActionDoc!.delete().catchError((error) {
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
              displayUpdateFlgState,
            );
          }, onError: (Object o) {
            // 接続失敗
            failedConnect(context);
          });
        }

        timeStart(
          context,
          scrollController,
          myActionDoc,
          rivalActionDoc,
          rivalListenSubscription,
          soundEffect,
          seVolume,
          initialTutorialFlg,
          displayUpdateFlgState,
        );

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
          displayUpdateFlgState,
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
              fontFamily: 'NotoSansJP',
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueGrey.shade900.withOpacity(0.9),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: IconButton(
                iconSize: 23,
                icon: Icon(
                  Icons.feed,
                  color: Colors.grey.shade200,
                ),
                onPressed: () {
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
                    width: MediaQuery.of(context).size.width * .86 > 450
                        ? 450
                        : null,
                    body: const AnswerCandidateModal(),
                  ).show();
                },
              ),
            ),
            initialTutorialFlg
                ? TextButton(
                    onPressed: () {
                      soundEffect.play(
                        'sounds/tap.mp3',
                        isNotification: true,
                        volume: seVolume,
                      );
                      Navigator.of(context).pushNamed(
                        TutorialTopScreen.routeName,
                        arguments: true,
                      );
                    },
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
                          displayUpdateFlgState: displayUpdateFlgState,
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
