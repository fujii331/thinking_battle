import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinking_battle/models/eventData.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';
import 'package:thinking_battle/widgets/common/comment_modal.widget.dart';

Future getEventRanking(
  BuildContext context,
) async {
  final DateTime now = DateTime.now();
  final targetDoc = now.isAfter(DateTime(2022, 1, 8, 0, 0))
      ? '2022-01-08'
      : DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 1) * -1));
  await FirebaseFirestore.instance
      .collection('all-event-player-data')
      .doc(targetDoc)
      .get()
      .then((DocumentSnapshot doc) async {
    List<EventData> rankingList = [];
    List rankingObjectList = [];

    // 全員分のデータ
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    data.forEach((final String key, final dynamic value) {
      rankingObjectList.add({
        'userId': key,
        'userName': value[0],
        'winCount': value[1],
        'rank': value[2],
      });
    });

    rankingObjectList.sort((a, b) => b['winCount'].compareTo(a['winCount']));

    for (int rowNom = 0; rowNom < rankingObjectList.length; rowNom++) {
      rankingList.add(
        EventData(
          userId: rankingObjectList[rowNom]['userId'],
          userName: rankingObjectList[rowNom]['userName'],
          winCount: rankingObjectList[rowNom]['winCount'],
          rank: rankingObjectList[rowNom]['rank'],
          rowNom: rowNom + 1,
        ),
      );
    }

    context.read(eventPlayersCountProvider).state = rankingObjectList.length;

    context.read(eventTopListProvider).state = [
      rankingList[0],
      rankingList[1],
      rankingList[2],
      rankingList[3],
      rankingList[4],
    ];

    final String loginId = context.read(loginIdProvider).state;

    final List<EventData>? myDataList =
        rankingList.where((data) => data.userId == loginId).toList();

    if (myDataList != null && myDataList.isNotEmpty) {
      final EventData? myData = myDataList.first;
      final rankingListLength = rankingList.length;

      final roundMe = myData!.rowNom <= 3
          ? [
              rankingList[0],
              rankingList[1],
              rankingList[2],
              rankingList[3],
              rankingList[4],
            ]
          : myData.rowNom >= rankingListLength - 5
              ? [
                  rankingList[rankingListLength - 5],
                  rankingList[rankingListLength - 4],
                  rankingList[rankingListLength - 3],
                  rankingList[rankingListLength - 2],
                  rankingList[rankingListLength - 1],
                ]
              : [
                  rankingList[myData.rowNom - 2],
                  rankingList[myData.rowNom - 1],
                  rankingList[myData.rowNom],
                  rankingList[myData.rowNom + 1],
                  rankingList[myData.rowNom + 2],
                ];

      context.read(eventRoundMeListProvider).state = roundMe;
    }
  });
}

Future createEventRankingData(
  BuildContext context,
) async {
  await FirebaseFirestore.instance
      .collection('event-result')
      .get()
      .then((QuerySnapshot querySnapshot) async {
    Map<String, dynamic> addObject = {};
    List rankingList = [];

    for (QueryDocumentSnapshot<Object?> doc in querySnapshot.docs) {
      rankingList.add({
        'userId': doc.id,
        'userName': doc['playerName'],
        'winCount': doc['eventWinCount'],
      });
    }

    rankingList.sort((a, b) => b['winCount'].compareTo(a['winCount']));

    int rank = 0;
    int winValue = 0;
    for (int i = 0; i < rankingList.length; i++) {
      if (rankingList[i]['winCount'] != winValue) {
        rank = i + 1;
        winValue = rankingList[i]['winCount'];
      }

      final eachMap = <String, List>{
        rankingList[i]['userId']: [
          rankingList[i]['userName'],
          rankingList[i]['winCount'],
          rank
        ],
      };
      addObject.addAll(eachMap);
    }

    final DocumentReference<Map<String, dynamic>>? actionDoc = FirebaseFirestore
        .instance
        .collection('all-event-player-data')
        .doc(DateFormat('yyyy-MM-dd').format(DateTime.now()));

    await actionDoc!
        .set(addObject)
        .timeout(const Duration(seconds: 5))
        .onError((error, stackTrace) {
      // 何もしない
    });
  });
}

Future getEventReward(
  BuildContext context,
  AudioCache soundEffect,
  double seVolume,
) async {
  await FirebaseFirestore.instance
      .collection('all-event-player-data')
      .doc('2022-01-08')
      .get()
      .then((DocumentSnapshot doc) async {
    List<EventData> rankingList = [];
    List rankingObjectList = [];

    // 全員分のデータ
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    data.forEach((final String key, final dynamic value) {
      rankingObjectList.add({
        'userId': key,
        'userName': value[0],
        'winCount': value[1],
        'rank': value[2],
      });
    });

    rankingObjectList.sort((a, b) => b['winCount'].compareTo(a['winCount']));

    for (int rowNom = 0; rowNom < rankingObjectList.length; rowNom++) {
      rankingList.add(
        EventData(
          userId: rankingObjectList[rowNom]['userId'],
          userName: rankingObjectList[rowNom]['userName'],
          winCount: rankingObjectList[rowNom]['winCount'],
          rank: rankingObjectList[rowNom]['rank'],
          rowNom: rowNom + 1,
        ),
      );
    }

    final String loginId = context.read(loginIdProvider).state;

    final myData =
        rankingList.where((data) => data.userId == loginId).toList().first;

    // 1位：100GP\n2位：50GP\n3位：15GP\n上位5%：限定メッセージ + 5ガチャチケ\n上位6~15%：5ガチャチケ\n上位16~50%：3ガチャチケ\n参加賞：1ガチャチケ',

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String rewardMessage = '';

    if (myData.rank == 1) {
      context.read(gachaPointProvider).state += 100;
      prefs.setInt('gachaPoint', context.read(gachaPointProvider).state);
      rewardMessage += '1位報酬：100GP\n';
    } else if (myData.rank == 2) {
      context.read(gachaPointProvider).state += 50;
      prefs.setInt('gachaPoint', context.read(gachaPointProvider).state);
      rewardMessage += '2位報酬：50GP\n';
    } else if (myData.rank == 3) {
      context.read(gachaPointProvider).state += 15;
      prefs.setInt('gachaPoint', context.read(gachaPointProvider).state);
      rewardMessage += '3位報酬：15GP\n';
    }

    final myPercentage = (myData.rank / rankingList.length) * 100;

    if (myPercentage < 5) {
      context.read(gachaTicketProvider).state += 5;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);

      final List<String> messageIdsList =
          context.read(messageIdsListProvider).state;

      const int itemNumber = 31;
      messageIdsList.add(itemNumber.toString());
      messageIdsList.sort((a, b) => int.parse(a) - int.parse(b));

      context.read(messageIdsListProvider).state = messageIdsList;
      prefs.setStringList('messageIdsList', messageIdsList);

      rewardMessage += '上位5%報酬：限定メッセージ + 5ガチャチケ\n';
    } else if (myPercentage < 15) {
      context.read(gachaTicketProvider).state += 5;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      rewardMessage += '上位6~15%報酬：5ガチャチケ\n';
    } else if (myPercentage < 50) {
      context.read(gachaTicketProvider).state += 3;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      rewardMessage += '上位16~50%：3ガチャチケ\n';
    } else {
      context.read(gachaTicketProvider).state += 1;
      prefs.setInt('gachaTicket', context.read(gachaTicketProvider).state);
      rewardMessage += '参加賞：1ガチャチケ\n';
    }

    rewardMessage += '\nお疲れ様でした！！';

    // 報酬受け渡し完了
    prefs.setBool('event1End', true);

    soundEffect.play(
      'sounds/new_item.mp3',
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
      width: MediaQuery.of(context).size.width * .86 > 550 ? 550 : null,
      body: CommentModal(
        topText: '第一回イベント報酬獲得',
        secondText: rewardMessage,
        closeButtonFlg: false,
      ),
    ).show();
  });
}
