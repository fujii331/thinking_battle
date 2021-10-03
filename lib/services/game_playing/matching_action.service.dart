import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:thinking_battle/models/matching_info.model.dart';
import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/providers/game.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/services/game_playing/initialize_game.service.dart';
import 'package:thinking_battle/services/game_playing/update_rate.service.dart';
import 'package:thinking_battle/widgets/game_start/failed_matching.widget.dart';

Future matchingAction(
  BuildContext context,
  int imageNumber,
  String userName,
  double userRate,
  double maxRate,
  int matchedCount,
  int continuousWinCount,
  List<int> userSkillIdsList,
) async {
  final matchingRoomRef =
      FirebaseFirestore.instance.collection('random-matching-room');

  await matchingRoomRef
      .where('matchingStatus', isEqualTo: 1)
      .where('rate', isLessThan: userRate + 500.0)
      .where('rate', isGreaterThan: userRate - 500.0)
      .limit(1)
      .get()
      .then((QuerySnapshot querySnapshot) async {
    if (querySnapshot.docs.isEmpty) {
      final String loginId = context.read(loginIdProvider).state;
      final bool precedingFlg = Random().nextInt(2) == 0 ? true : false;

      // 待機中のデータを作る
      await matchingRoomRef.doc(loginId).set({
        'name': userName,
        'rate': userRate,
        'maxRate': maxRate,
        'imageNumber': imageNumber,
        'matchedCount': matchedCount,
        'continuousWinCount': continuousWinCount,
        'skill1': userSkillIdsList[0],
        'skill2': userSkillIdsList[1],
        'skill3': userSkillIdsList[2],
        'matchingStatus': 1, // 待機中
        'precedingFlg': precedingFlg,
        'createdAt': DateTime.now().toString(),
      }).then((_) async {
        // providerに登録
        context.read(matchingWaitingIdProvider).state = loginId;

        // 変更をlisten
        var listen = matchingRoomRef
            .doc(loginId)
            .snapshots()
            .listen((DocumentSnapshot<Object?> querySnapshot) {
          MatchingInfo matchingInfoSnapshot =
              MatchingInfo.fromJson(querySnapshot);

          if (matchingInfoSnapshot.matchingStatus == 2 &&
              context.read(matchingWaitingIdProvider).state != '') {
            final List<int> skillList = [
              matchingInfoSnapshot.skill1,
              matchingInfoSnapshot.skill2,
              matchingInfoSnapshot.skill3,
            ];
            // ライバル情報を更新
            context.read(rivalInfoProvider).state = PlayerInfo(
              name: matchingInfoSnapshot.name,
              rate: matchingInfoSnapshot.rate,
              maxRate: matchingInfoSnapshot.maxRate,
              imageNumber: matchingInfoSnapshot.imageNumber,
              matchedCount: matchingInfoSnapshot.matchedCount,
              continuousWinCount: matchingInfoSnapshot.continuousWinCount,
              skillList: skillList,
            );

            context.read(enemySkillsProvider).state = skillList;

            // ランダムマッチの部屋を作成
            DatabaseReference firebaseInstance =
                FirebaseDatabase.instance.reference().child('random-match/');

            firebaseInstance.set({
              loginId: null, // マッチング時のIDで部屋を作成
            });

            // マッチ済みに更新
            matchingRoomRef.doc(loginId).update({
              "matchingStatus": 3,
            }).then((void _) async {
              // マッチング完了
              context.read(matchingRoomIdProvider).state = loginId;
              context.read(matchingWaitingIdProvider).state = '';
              context.read(precedingFlgProvider).state = precedingFlg;

              // 負けた場合のレートを登録
              final double failedRate = getNewRate(
                userRate,
                matchingInfoSnapshot.rate,
                false,
              );

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setDouble('failedRate', failedRate);

              matchingRoomRef.doc(loginId).delete().then((void _) {
                return;
              }).catchError((error) async {
                // データ削除に失敗した場合
                // そのままreturnする
                return;
              });
              return;
            }).catchError((error) async {
              // データ更新に失敗した場合
              matchingError(context);
            });
          }
        });

        await Future.delayed(
          const Duration(seconds: 9),
        );

        listen.cancel();

        if (context.read(matchingWaitingIdProvider).state != '') {
          matchingRoomRef.doc(loginId).delete().catchError((error) async {
            // データ削除に失敗した場合は何もしない
          });

          context.read(matchingWaitingIdProvider).state = '';

          // とりあえずCPUとマッチングさせる
          context.read(trainingProvider).state = true;
          context.read(changedTrainingProvider).state = true;
          trainingInitialAction(
            context,
          );

          return;

          // 再度マッチング処理
          // matchingAction(
          //   context,
          //   imageNumber,
          //   userName,
          //   userRate,
          //   maxRate,
          //   matchedCount,
          //   userSkillIdsList,
          // );
        }
      }).catchError((error) async {
        // データ登録に失敗した場合
        matchingError(context);
      });
    } else {
      // トランザクション制御を行ってステータスを更新
      await matchingUpdate(
        querySnapshot.docs[0].id,
        context,
        imageNumber,
        userName,
        userRate,
        maxRate,
        matchedCount,
        continuousWinCount,
        userSkillIdsList,
      );
    }
  }).catchError((error) async {
    // データ取得に失敗した場合
    matchingError(context);
  });
}

Future matchingUpdate(
  String matchingId,
  BuildContext context,
  int imageNumber,
  String userName,
  double userRate,
  double maxRate,
  int matchedCount,
  int continuousWinCount,
  List<int> userSkillIdsList,
) async {
  // マッチング待機中のプレイヤーを取得
  final matchingTargetRef = FirebaseFirestore.instance
      .collection('random-matching-room')
      .doc(matchingId);

  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      await transaction.get(matchingTargetRef).then(
          (DocumentSnapshot<Map<String, dynamic>> matchingTargetDoc) async {
        MatchingInfo firstMatchingInfoSnapshot =
            MatchingInfo.fromJson(matchingTargetDoc);

        if (firstMatchingInfoSnapshot.matchingStatus == 1) {
          // 連携済みに更新
          transaction.update(matchingTargetRef, {
            'name': userName,
            'rate': userRate,
            'maxRate': maxRate,
            'imageNumber': imageNumber,
            'matchedCount': matchedCount,
            'continuousWinCount': continuousWinCount,
            'skill1': userSkillIdsList[0],
            'skill2': userSkillIdsList[1],
            'skill3': userSkillIdsList[2],
            'matchingStatus': 2, // マッチング
            'precedingFlg': firstMatchingInfoSnapshot.precedingFlg,
          });
          return firstMatchingInfoSnapshot;
        }
      }).then((MatchingInfo? secondMatchingInfoSnapshot) async {
        if (secondMatchingInfoSnapshot != null) {
          // 更新に成功した場合
          // 変更をlisten
          var listen = matchingTargetRef
              .snapshots()
              .listen((DocumentSnapshot<Object?> querySnapshot) async {
            MatchingInfo listeningInfoSnapshot =
                MatchingInfo.fromJson(querySnapshot);

            if (listeningInfoSnapshot.matchingStatus == 3) {
              // ライバル情報を更新
              final List<int> skillList = [
                secondMatchingInfoSnapshot.skill1,
                secondMatchingInfoSnapshot.skill2,
                secondMatchingInfoSnapshot.skill3,
              ];

              context.read(rivalInfoProvider).state = PlayerInfo(
                name: secondMatchingInfoSnapshot.name,
                rate: secondMatchingInfoSnapshot.rate,
                maxRate: secondMatchingInfoSnapshot.maxRate,
                imageNumber: secondMatchingInfoSnapshot.imageNumber,
                matchedCount: secondMatchingInfoSnapshot.matchedCount,
                continuousWinCount:
                    secondMatchingInfoSnapshot.continuousWinCount,
                skillList: skillList,
              );

              context.read(enemySkillsProvider).state = skillList;
              // 部屋のIDを取得
              context.read(matchingRoomIdProvider).state = matchingId;
              // 先行フラグの反対値を設定
              context.read(precedingFlgProvider).state =
                  !secondMatchingInfoSnapshot.precedingFlg;

              // 負けた場合のレートを登録
              final double failedRate = getNewRate(
                userRate,
                secondMatchingInfoSnapshot.rate,
                false,
              );

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setDouble('failedRate', failedRate);

              return;
            }
          });

          await Future.delayed(
            const Duration(seconds: 5),
          );

          listen.cancel();

          if (context.read(matchingRoomIdProvider).state == '') {
            matchingTargetRef.delete().catchError((error) async {
              // データ削除に失敗した場合は何もしない
            });

            // 再度マッチング処理
            await matchingAction(
              context,
              imageNumber,
              userName,
              userRate,
              maxRate,
              matchedCount,
              continuousWinCount,
              userSkillIdsList,
            );
          }
        } else {
          // すでに更新されていた場合
          await matchingAction(
            context,
            imageNumber,
            userName,
            userRate,
            maxRate,
            matchedCount,
            continuousWinCount,
            userSkillIdsList,
          );
        }
      }).catchError((error) async {
        // データ取得に失敗した場合
        matchingError(context);
      });
    });
  } catch (e, s) {
    // トランザクション失敗時は再度取得処理を実行
    await matchingAction(
      context,
      imageNumber,
      userName,
      userRate,
      maxRate,
      matchedCount,
      continuousWinCount,
      userSkillIdsList,
    );
  }
}

Future matchingError(
  BuildContext context,
) async {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.ERROR,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    dismissOnBackKeyPress: false,
    animType: AnimType.SCALE,
    width: MediaQuery.of(context).size.width * .86 > 650 ? 650 : null,
    body: const FaildMatching(),
  ).show();

  await Future.delayed(
    const Duration(milliseconds: 3500),
  );
  Navigator.pop(context);
  Navigator.pop(context);
}
