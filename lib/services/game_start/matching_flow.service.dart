import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/data/quiz_data.dart';

import 'package:thinking_battle/models/matching_info.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';
import 'package:thinking_battle/models/quiz.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/screens/game_playing.screen.dart';
import 'package:thinking_battle/screens/mode_select.screen.dart';
import 'package:thinking_battle/services/game_start/initialize_game.service.dart';
import 'package:thinking_battle/services/game_playing/update_rate.service.dart';
import 'package:thinking_battle/widgets/game_start/failed_matching.widget.dart';
import 'package:thinking_battle/widgets/game_start/initial_tutorial_start_modal.widget.dart';
import 'package:thinking_battle/widgets/game_start/no_matching_modal.widget.dart';

Future matchingFlow(
  BuildContext context,
  int imageNumber,
  int cardNumber,
  String userName,
  double userRate,
  int matchedCount,
  int continuousWinCount,
  List<int> userSkillIdsList,
  ValueNotifier<bool> matchingQuitFlgState,
  String friendMatchWord,
  ValueNotifier<bool> interruptionFlgState,
  ValueNotifier<bool> matchingAnimatedFlgState,
  AudioCache soundEffect,
  double seVolume,
) async {
  await matchingAction(
    context,
    imageNumber,
    cardNumber,
    userName,
    userRate,
    matchedCount,
    continuousWinCount,
    userSkillIdsList,
    matchingQuitFlgState,
    friendMatchWord,
    interruptionFlgState,
    matchingAnimatedFlgState,
  ).then((_) {
    if (!matchingQuitFlgState.value) {
      gameStart(
        context,
        soundEffect,
        seVolume,
        matchingAnimatedFlgState,
      );
    }
  }).catchError((onError) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      headerAnimationLoop: false,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      animType: AnimType.SCALE,
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: const FaildMatching(
        topText: '通信失敗',
        secondText: '電波状況をご確認ください。\nメニュー画面に戻ります。',
      ),
      // body: FaildMatching(
      //   topText: '通信失敗',
      //   secondText: onError.description,
      // ),
    ).show();

    await Future.delayed(
      const Duration(milliseconds: 3500),
    );
    context.read(bgmProvider).state.stop();
    context.read(bgmProvider).state = await soundEffect.loop(
      'sounds/title.mp3',
      volume: context.read(bgmVolumeProvider).state,
      isNotification: true,
    );
    Navigator.popUntil(
        context, ModalRoute.withName(ModeSelectScreen.routeName));
    return;
  });
}

Future gameStart(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
  ValueNotifier<bool> matchingAnimatedFlgState,
) async {
  soundEffect.play(
    'sounds/matching.mp3',
    isNotification: true,
    volume: seVolume,
  );

  await Future.delayed(
    const Duration(milliseconds: 100),
  );

  matchingAnimatedFlgState.value = true;

  await Future.delayed(
    const Duration(milliseconds: 5000),
  );

  context.read(bgmProvider).state.stop();

  commonInitialAction(context);

  Navigator.of(context).pushReplacementNamed(
    GamePlayingScreen.routeName,
  );
}

Future tutorialGameStart(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
  ValueNotifier<bool> matchingAnimatedFlgState,
) async {
  soundEffect.play(
    'sounds/matching.mp3',
    isNotification: true,
    volume: seVolume,
  );

  await Future.delayed(
    const Duration(milliseconds: 100),
  );

  matchingAnimatedFlgState.value = true;

  await Future.delayed(
    const Duration(milliseconds: 2500),
  );

  AwesomeDialog(
    context: context,
    dialogType: DialogType.NO_HEADER,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    showCloseIcon: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
    body: InitialTutorialStartModal(
      screenContext: context,
      soundEffect: soundEffect,
      seVolume: seVolume,
    ),
  ).show();
}

Future matchingAction(
  BuildContext context,
  int imageNumber,
  int cardNumber,
  String userName,
  double userRate,
  int matchedCount,
  int continuousWinCount,
  List<int> userSkillIdsList,
  ValueNotifier<bool> matchingQuitFlgState,
  String friendMatchWord,
  ValueNotifier<bool> interruptionFlgState,
  ValueNotifier<bool> matchingAnimatedFlgState,
) async {
  await mainMatchingAction(
    context,
    imageNumber,
    cardNumber,
    userName,
    userRate,
    matchedCount,
    continuousWinCount,
    userSkillIdsList,
    matchingQuitFlgState,
    friendMatchWord,
    interruptionFlgState,
    matchingAnimatedFlgState,
  ).then((_) async {
    if (interruptionFlgState.value) {
      interruptionFlgState.value = false;
      await matchingAction(
        context,
        imageNumber,
        cardNumber,
        userName,
        userRate,
        matchedCount,
        continuousWinCount,
        userSkillIdsList,
        matchingQuitFlgState,
        friendMatchWord,
        interruptionFlgState,
        matchingAnimatedFlgState,
      );
    }
  });
}

Future mainMatchingAction(
  BuildContext context,
  int imageNumber,
  int cardNumber,
  String userName,
  double userRate,
  int matchedCount,
  int continuousWinCount,
  List<int> userSkillIdsList,
  ValueNotifier<bool> matchingQuitFlgState,
  String friendMatchWord,
  ValueNotifier<bool> interruptionFlgState,
  ValueNotifier<bool> matchingAnimatedFlgState,
) async {
  final bool randomMatchFlg = friendMatchWord == '';
  final int buildNumber = context.read(buildNumberProvider).state;

  final ConnectivityResult connectivityResult =
      await (Connectivity().checkConnectivity());

  // ネット接続していなかったらエラー
  if (connectivityResult == ConnectivityResult.none) {
    throw Exception('通信失敗');
  }

  if (randomMatchFlg) {
    // ランダムマッチ
    final matchingRoomRef =
        FirebaseFirestore.instance.collection('random-matching-room');

    await matchingRoomRef
        .where('matchingStatus', isEqualTo: 1)
        // .where('buildNumber', isEqualTo: buildNumber) // TODO バージョン2から導入
        .where('rate', isLessThan: userRate + 200.0)
        .where('rate', isGreaterThan: userRate - 200.0)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (!matchingQuitFlgState.value) {
        await actionAfterSearch(
          querySnapshot,
          matchingRoomRef,
          context,
          userName,
          userRate,
          imageNumber,
          cardNumber,
          matchedCount,
          continuousWinCount,
          buildNumber,
          userSkillIdsList,
          matchingQuitFlgState,
          context.read(loginIdProvider).state,
          friendMatchWord,
          interruptionFlgState,
          matchingAnimatedFlgState,
        );
      }
    }).catchError((error) async {
      // データ取得に失敗した場合
      throw Exception('通信失敗');
    });
  } else {
    final friendMatchingRoomRef =
        FirebaseFirestore.instance.collection('friend-matching-room');

    // フレンドマッチ
    await friendMatchingRoomRef
        .where('matchingStatus', isEqualTo: 1)
        // .where('buildNumber', isEqualTo: buildNumber) // TODO バージョン2から導入
        .where('customData', isEqualTo: friendMatchWord)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      if (!matchingQuitFlgState.value) {
        await actionAfterSearch(
          querySnapshot,
          friendMatchingRoomRef,
          context,
          userName,
          userRate,
          imageNumber,
          cardNumber,
          matchedCount,
          continuousWinCount,
          buildNumber,
          userSkillIdsList,
          matchingQuitFlgState,
          context.read(loginIdProvider).state,
          friendMatchWord,
          interruptionFlgState,
          matchingAnimatedFlgState,
        );
      }
    }).catchError((error) async {
      // データ取得に失敗した場合
      throw Exception('通信失敗');
    });
  }
}

Future actionAfterSearch(
  QuerySnapshot querySnapshot,
  CollectionReference<Map<String, dynamic>> matchingRoomRef,
  BuildContext context,
  String userName,
  double userRate,
  int imageNumber,
  int cardNumber,
  int matchedCount,
  int continuousWinCount,
  int buildNumber,
  List<int> userSkillIdsList,
  ValueNotifier<bool> matchingQuitFlgState,
  String matchingId,
  String friendMatchWord,
  ValueNotifier<bool> interruptionFlgState,
  ValueNotifier<bool> matchingAnimatedFlgState,
) async {
  if (querySnapshot.docs.isEmpty) {
    await matchingPreparation(
      matchingRoomRef,
      matchingId,
      context,
      userName,
      userRate,
      imageNumber,
      cardNumber,
      matchedCount,
      continuousWinCount,
      buildNumber,
      userSkillIdsList,
      matchingQuitFlgState,
      friendMatchWord,
      interruptionFlgState,
      matchingAnimatedFlgState,
    );
  } else {
    // トランザクション制御を行ってステータスを更新
    await matchingUpdate(
      matchingRoomRef,
      querySnapshot.docs[0].id,
      context,
      imageNumber,
      cardNumber,
      userName,
      userRate,
      matchedCount,
      continuousWinCount,
      userSkillIdsList,
      matchingQuitFlgState,
      interruptionFlgState,
    );
  }
}

Future matchingPreparation(
  CollectionReference<Map<String, dynamic>> matchingRoomRef,
  String matchingId,
  BuildContext context,
  String userName,
  double userRate,
  int imageNumber,
  int cardNumber,
  int matchedCount,
  int continuousWinCount,
  int buildNumber,
  List<int> userSkillIdsList,
  ValueNotifier<bool> matchingQuitFlgState,
  String friendMatchWord,
  ValueNotifier<bool> interruptionFlgState,
  ValueNotifier<bool> matchingAnimatedFlgState,
) async {
  final bool precedingFlg = Random().nextInt(2) == 0 ? true : false;
  final randomMatchFlg = friendMatchWord == '';

  if (!matchingQuitFlgState.value) {
    // 待機中のデータを作る
    await matchingRoomRef.doc(matchingId).set({
      'name': userName,
      'rate': userRate,
      'imageNumber': imageNumber,
      'cardNumber': cardNumber,
      'matchedCount': matchedCount,
      'continuousWinCount': continuousWinCount,
      'skillList': userSkillIdsList,
      'matchingStatus': 1, // 待機中
      'precedingFlg': precedingFlg,
      'buildNumber': buildNumber,
      'customData':
          randomMatchFlg ? DateTime.now().toString() : friendMatchWord,
    }).then((_) async {
      // providerに登録
      context.read(matchingWaitingIdProvider).state = matchingId;

      // 変更をlisten
      var listen = matchingRoomRef
          .doc(matchingId)
          .snapshots()
          .listen((DocumentSnapshot<Object?> querySnapshot) {
        MatchingInfo matchingInfoSnapshot =
            MatchingInfo.fromJson(querySnapshot);

        if (matchingInfoSnapshot.matchingStatus == 2 &&
            !matchingQuitFlgState.value) {
          // ライバル情報を更新
          context.read(rivalInfoProvider).state = PlayerInfo(
            name: matchingInfoSnapshot.name,
            rate: matchingInfoSnapshot.rate,
            imageNumber: matchingInfoSnapshot.imageNumber,
            cardNumber: matchingInfoSnapshot.cardNumber,
            matchedCount: matchingInfoSnapshot.matchedCount,
            continuousWinCount: matchingInfoSnapshot.continuousWinCount,
            skillList: matchingInfoSnapshot.skillList,
          );

          // 問題を設定
          final Quiz quiz = quizData[Random().nextInt(quizData.length)];

          context.read(quizThemaProvider).state = quiz.thema;
          context.read(allQuestionsProvider).state = quiz.questions;
          context.read(correctAnswersProvider).state = quiz.correctAnswers;
          context.read(wrongAnswersProvider).state = quiz.wrongAnswers;
          context.read(answerCandidateProvider).state = quiz.answerCandidate;

          // マッチ済みに更新
          matchingRoomRef.doc(matchingId).set({
            "matchingStatus": 3,
            "quizId": quiz.id,
          }).then((void _) async {
            // マッチング完了
            context.read(matchingRoomIdProvider).state = matchingId;
            context.read(matchingWaitingIdProvider).state = '';
            context.read(precedingFlgProvider).state = precedingFlg;

            if (context.read(friendMatchWordProvider).state == '') {
              // 負けた場合のレートを登録
              final double failedRate = getNewRate(
                userRate,
                matchingInfoSnapshot.rate,
                false,
              );

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setDouble('failedRate', failedRate);
            }

            matchingRoomRef.doc(matchingId).delete().catchError((error) {
              // データ削除に失敗した場合、何もしない
            });

            // 前回削除できていなかった時のために対戦部屋の削除
            // 対戦開始時にやってるからいらないかも
            // DocumentReference<Map<String, dynamic>>? playingRoomDoc =
            //     FirebaseFirestore.instance
            //         .collection('playing-room')
            //         .doc(matchingId);

            // playingRoomDoc.delete().catchError((error) {
            //   // データ削除に失敗した場合、何もしない
            // });

            return;
          }).catchError((error) async {
            // データ更新に失敗した場合
            throw Exception(error.message);
          });
        }
      });

      if (randomMatchFlg) {
        // 1/12でCPUとも接続しない
        final notCpuMatchingFlg = Random().nextInt(15) == 0;
        // 1/3で7-10秒
        // 1/3で3-6秒
        final int waitingTime = notCpuMatchingFlg
            ? 11
            : Random().nextInt(2) == 0
                ? 4 + Random().nextInt(4)
                : Random().nextInt(3) == 0
                    ? 3 + Random().nextInt(3)
                    : 7;
        for (int i = 0; i < waitingTime; i++) {
          if (matchingQuitFlgState.value ||
              context.read(matchingWaitingIdProvider).state == '') {
            break;
          }
          await Future.delayed(const Duration(seconds: 1));
        }

        listen.cancel();

        if (!matchingQuitFlgState.value &&
            context.read(matchingWaitingIdProvider).state != '') {
          matchingRoomRef.doc(matchingId).delete().catchError((error) async {
            // データ削除に失敗した場合は何もしない
          });

          context.read(matchingWaitingIdProvider).state = '';

          if (notCpuMatchingFlg) {
            // もう一回探すか確認
            matchingQuitFlgState.value = true;
            AwesomeDialog(
              context: context,
              dialogType: DialogType.INFO,
              headerAnimationLoop: false,
              dismissOnTouchOutside: false,
              dismissOnBackKeyPress: false,
              animType: AnimType.SCALE,
              width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
              body: NoMatchingModal(
                screenContext: context,
                imageNumber: imageNumber,
                cardNumber: cardNumber,
                userName: userName,
                userRate: userRate,
                matchedCount: matchedCount,
                continuousWinCount: continuousWinCount,
                userSkillIdsList: userSkillIdsList,
                matchingQuitFlgState: matchingQuitFlgState,
                friendMatchWord: friendMatchWord,
                interruptionFlgState: interruptionFlgState,
                matchingAnimatedFlgState: matchingAnimatedFlgState,
              ),
            ).show();
          } else {
            // とりあえずCPUとマッチングさせる
            context.read(trainingStatusProvider).state = 3;
            await trainingInitialAction(
              context,
            );
          }

          return;
        }
      } else {
        for (int i = 0; i < 60; i++) {
          if (matchingQuitFlgState.value ||
              context.read(matchingWaitingIdProvider).state == '') {
            break;
          }
          await Future.delayed(const Duration(seconds: 1));
        }

        listen.cancel();

        if (!matchingQuitFlgState.value &&
            context.read(matchingWaitingIdProvider).state != '') {
          matchingRoomRef.doc(matchingId).delete().catchError((error) async {
            // データ削除に失敗した場合は何もしない
          });

          context.read(matchingWaitingIdProvider).state = '';

          // 戻る
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            headerAnimationLoop: false,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            animType: AnimType.SCALE,
            width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
            body: const FaildMatching(
              topText: 'マッチング失敗',
              secondText: '・あいことばは一致していますか？\n・アプリバージョンは最新ですか？\nメニュー画面に戻ります。',
            ),
          ).show();

          matchingQuitFlgState.value = true;

          await Future.delayed(
            const Duration(milliseconds: 3500),
          );
          Navigator.popUntil(
            context,
            ModalRoute.withName(ModeSelectScreen.routeName),
          );

          return;
        }
      }
    }).catchError((error) async {
      // データ登録に失敗した場合
      throw Exception(error.message);
    });
  }
}

Future matchingUpdate(
  CollectionReference<Map<String, dynamic>> matchingRoomRef,
  String matchingId,
  BuildContext context,
  int imageNumber,
  int cardNumber,
  String userName,
  double userRate,
  int matchedCount,
  int continuousWinCount,
  List<int> userSkillIdsList,
  ValueNotifier<bool> matchingQuitFlgState,
  ValueNotifier<bool> interruptionFlgState,
) async {
  // マッチング待機中のプレイヤーを取得
  final matchingTargetRef = matchingRoomRef.doc(matchingId);

  MatchingInfo? firstMatchedInfoSnapshot;

  try {
    firstMatchedInfoSnapshot =
        await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> matchingTargetDoc =
          await transaction.get(matchingTargetRef);

      if (matchingTargetDoc.exists) {
        MatchingInfo firstMatchingInfoSnapshot =
            MatchingInfo.fromJson(matchingTargetDoc);

        if (!matchingQuitFlgState.value &&
            firstMatchingInfoSnapshot.matchingStatus == 1) {
          // 連携済みに更新
          transaction.update(matchingTargetRef, {
            'name': userName,
            'rate': userRate,
            'imageNumber': imageNumber,
            'cardNumber': cardNumber,
            'matchedCount': matchedCount,
            'continuousWinCount': continuousWinCount,
            'skillList': userSkillIdsList,
            'matchingStatus': 2, // マッチング
          });

          return firstMatchingInfoSnapshot;
        } else {
          // ステータス更新済み
          interruptionFlgState.value = true;
          return null;
        }
      } else {
        // 対象情報が取得できなかった
        interruptionFlgState.value = true;
        return null;
      }
    });
  } catch (e, _) {
    // トランザクション失敗
    interruptionFlgState.value = true;
  }

  if (!matchingQuitFlgState.value && !interruptionFlgState.value) {
    // 変更をlisten
    var listen = matchingTargetRef
        .snapshots()
        .listen((DocumentSnapshot<Object?> querySnapshot) async {
      if (!matchingQuitFlgState.value &&
          querySnapshot['matchingStatus'] as int == 3) {
        // ライバル情報を更新
        context.read(rivalInfoProvider).state = PlayerInfo(
          name: firstMatchedInfoSnapshot!.name,
          rate: firstMatchedInfoSnapshot.rate,
          imageNumber: firstMatchedInfoSnapshot.imageNumber,
          cardNumber: firstMatchedInfoSnapshot.cardNumber,
          matchedCount: firstMatchedInfoSnapshot.matchedCount,
          continuousWinCount: firstMatchedInfoSnapshot.continuousWinCount,
          skillList: firstMatchedInfoSnapshot.skillList,
        );

        // 問題を設定
        final Quiz quiz = quizData[querySnapshot['quizId'] - 1];

        context.read(quizThemaProvider).state = quiz.thema;
        context.read(allQuestionsProvider).state = quiz.questions;
        context.read(correctAnswersProvider).state = quiz.correctAnswers;
        context.read(wrongAnswersProvider).state = quiz.wrongAnswers;
        context.read(answerCandidateProvider).state = quiz.answerCandidate;

        // 部屋のIDを取得
        context.read(matchingRoomIdProvider).state = matchingId;
        // 先行フラグの反対値を設定
        context.read(precedingFlgProvider).state =
            !firstMatchedInfoSnapshot.precedingFlg;

        if (context.read(friendMatchWordProvider).state == '') {
          // 負けた場合のレートを登録
          final double failedRate = getNewRate(
            userRate,
            firstMatchedInfoSnapshot.rate,
            false,
          );

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setDouble('failedRate', failedRate);
        }

        return;
      }
    });

    for (int i = 0; i < 3; i++) {
      if (matchingQuitFlgState.value ||
          context.read(matchingRoomIdProvider).state != '') {
        break;
      }
      await Future.delayed(const Duration(seconds: 1));
    }

    listen.cancel();

    if (!matchingQuitFlgState.value &&
        context.read(matchingRoomIdProvider).state == '') {
      matchingTargetRef.delete().catchError((error) async {
        // データ削除に失敗した場合は何もしない
      });

      interruptionFlgState.value = true;
    }
  }
}
