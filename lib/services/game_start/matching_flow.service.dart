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
        topText: '????????????',
        secondText: '???????????????????????????????????????\n????????????????????????????????????',
      ),
      // body: FaildMatching(
      //   topText: '????????????',
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

  // ????????????????????????????????????????????????
  if (connectivityResult == ConnectivityResult.none) {
    throw Exception('????????????');
  }

  if (randomMatchFlg) {
    // ?????????????????????
    final matchingRoomRef = FirebaseFirestore.instance.collection(
        // context.read(isEventMatchProvider).state
        //     ? 'event-matching-room'
        //     :
        'random-matching-room');

    await matchingRoomRef
        .where('matchingStatus', isEqualTo: 1)
        .where('buildNumber', isEqualTo: buildNumber)
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
      // ????????????????????????????????????
      throw Exception('????????????');
    });
  } else {
    final friendMatchingRoomRef =
        FirebaseFirestore.instance.collection('friend-matching-room');

    // ?????????????????????
    await friendMatchingRoomRef
        .where('matchingStatus', isEqualTo: 1)
        .where('buildNumber', isEqualTo: buildNumber)
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
      // ????????????????????????????????????
      throw Exception('????????????');
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
    // ??????????????????????????????????????????????????????????????????
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
    // ??????????????????????????????
    await matchingRoomRef.doc(matchingId).set({
      'name': userName,
      'rate': userRate,
      'imageNumber': imageNumber,
      'cardNumber': cardNumber,
      'matchedCount': matchedCount,
      'continuousWinCount': continuousWinCount,
      'skillList': userSkillIdsList,
      'matchingStatus': 1, // ?????????
      'precedingFlg': precedingFlg,
      'buildNumber': buildNumber,
      'customData':
          randomMatchFlg ? DateTime.now().toString() : friendMatchWord,
    }).then((_) async {
      // provider?????????
      context.read(matchingWaitingIdProvider).state = matchingId;

      // ?????????listen
      var listen = matchingRoomRef
          .doc(matchingId)
          .snapshots()
          .listen((DocumentSnapshot<Object?> querySnapshot) {
        MatchingInfo matchingInfoSnapshot =
            MatchingInfo.fromJson(querySnapshot);

        if (matchingInfoSnapshot.matchingStatus == 2 &&
            !matchingQuitFlgState.value) {
          // ???????????????????????????
          context.read(rivalInfoProvider).state = PlayerInfo(
            name: matchingInfoSnapshot.name,
            rate: matchingInfoSnapshot.rate,
            imageNumber: matchingInfoSnapshot.imageNumber,
            cardNumber: matchingInfoSnapshot.cardNumber,
            matchedCount: matchingInfoSnapshot.matchedCount,
            continuousWinCount: matchingInfoSnapshot.continuousWinCount,
            skillList: matchingInfoSnapshot.skillList,
          );

          // ???????????????
          final Quiz quiz = quizData[Random().nextInt(quizData.length)];

          context.read(quizThemaProvider).state = quiz.thema;
          context.read(allQuestionsProvider).state = quiz.questions;
          context.read(correctAnswersProvider).state = quiz.correctAnswers;
          context.read(wrongAnswersProvider).state = quiz.wrongAnswers;
          context.read(answerCandidateProvider).state = quiz.answerCandidate;

          // ????????????????????????
          matchingRoomRef.doc(matchingId).set({
            "matchingStatus": 3,
            "quizId": quiz.id,
          }).then((void _) async {
            // ?????????????????????
            context.read(matchingRoomIdProvider).state = matchingId;
            context.read(matchingWaitingIdProvider).state = '';
            context.read(precedingFlgProvider).state = precedingFlg;

            if (context.read(friendMatchWordProvider).state == '') {
              // ????????????????????????????????????
              final double failedRate = getNewRate(
                userRate,
                matchingInfoSnapshot.rate,
                false,
              );

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setDouble('failedRate', failedRate);
            }

            matchingRoomRef.doc(matchingId).delete().catchError((error) {
              // ??????????????????????????????????????????????????????
            });

            // ????????????????????????????????????????????????????????????????????????
            // ??????????????????????????????????????????????????????
            // DocumentReference<Map<String, dynamic>>? playingRoomDoc =
            //     FirebaseFirestore.instance
            //         .collection('playing-room')
            //         .doc(matchingId);

            // playingRoomDoc.delete().catchError((error) {
            //   // ??????????????????????????????????????????????????????
            // });

            return;
          }).catchError((error) async {
            // ????????????????????????????????????
            throw Exception(error.message);
          });
        }
      });

      if (randomMatchFlg) {
        // 1/12???CPU?????????????????????
        final notCpuMatchingFlg = Random().nextInt(15) == 0;
        // 1/3???7-10???
        // 1/3???3-6???
        final int waitingTime = notCpuMatchingFlg
            ? 11
            : Random().nextInt(2) == 0
                ? 3 + Random().nextInt(4)
                : Random().nextInt(3) == 0
                    ? 2 + Random().nextInt(3)
                    : 6;
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
            // ??????????????????????????????????????????????????????
          });

          context.read(matchingWaitingIdProvider).state = '';

          if (notCpuMatchingFlg) {
            // ???????????????????????????
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
            // ???????????????CPU???????????????????????????
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
            // ??????????????????????????????????????????????????????
          });

          context.read(matchingWaitingIdProvider).state = '';

          // ??????
          AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            headerAnimationLoop: false,
            dismissOnTouchOutside: false,
            dismissOnBackKeyPress: false,
            animType: AnimType.SCALE,
            width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
            body: const FaildMatching(
              topText: '?????????????????????',
              secondText: '????????????????????????????????????????????????\n????????????????????????????????????????????????\n????????????????????????????????????',
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
      // ????????????????????????????????????
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
  // ???????????????????????????????????????????????????
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
          // ?????????????????????
          transaction.update(matchingTargetRef, {
            'name': userName,
            'rate': userRate,
            'imageNumber': imageNumber,
            'cardNumber': cardNumber,
            'matchedCount': matchedCount,
            'continuousWinCount': continuousWinCount,
            'skillList': userSkillIdsList,
            'matchingStatus': 2, // ???????????????
          });

          return firstMatchingInfoSnapshot;
        } else {
          // ???????????????????????????
          interruptionFlgState.value = true;
          return null;
        }
      } else {
        // ???????????????????????????????????????
        interruptionFlgState.value = true;
        return null;
      }
    });
  } catch (e, _) {
    // ??????????????????????????????
    interruptionFlgState.value = true;
  }

  if (!matchingQuitFlgState.value && !interruptionFlgState.value) {
    // ?????????listen
    var listen = matchingTargetRef
        .snapshots()
        .listen((DocumentSnapshot<Object?> querySnapshot) async {
      if (!matchingQuitFlgState.value &&
          querySnapshot['matchingStatus'] as int == 3) {
        // ???????????????????????????
        context.read(rivalInfoProvider).state = PlayerInfo(
          name: firstMatchedInfoSnapshot!.name,
          rate: firstMatchedInfoSnapshot.rate,
          imageNumber: firstMatchedInfoSnapshot.imageNumber,
          cardNumber: firstMatchedInfoSnapshot.cardNumber,
          matchedCount: firstMatchedInfoSnapshot.matchedCount,
          continuousWinCount: firstMatchedInfoSnapshot.continuousWinCount,
          skillList: firstMatchedInfoSnapshot.skillList,
        );

        // ???????????????
        final Quiz quiz = quizData[querySnapshot['quizId'] - 1];

        context.read(quizThemaProvider).state = quiz.thema;
        context.read(allQuestionsProvider).state = quiz.questions;
        context.read(correctAnswersProvider).state = quiz.correctAnswers;
        context.read(wrongAnswersProvider).state = quiz.wrongAnswers;
        context.read(answerCandidateProvider).state = quiz.answerCandidate;

        // ?????????ID?????????
        context.read(matchingRoomIdProvider).state = matchingId;
        // ????????????????????????????????????
        context.read(precedingFlgProvider).state =
            !firstMatchedInfoSnapshot.precedingFlg;

        if (context.read(friendMatchWordProvider).state == '') {
          // ????????????????????????????????????
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
        // ??????????????????????????????????????????????????????
      });

      interruptionFlgState.value = true;
    }
  }
}
