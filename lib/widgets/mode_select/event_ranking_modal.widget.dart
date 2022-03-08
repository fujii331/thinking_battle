import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thinking_battle/models/eventData.model.dart';
import 'package:thinking_battle/providers/common.provider.dart';
import 'package:thinking_battle/providers/player.provider.dart';

class EventRankingModal extends HookWidget {
  const EventRankingModal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String loginId = useProvider(loginIdProvider).state;
    final List<EventData> eventTopList =
        useProvider(eventTopListProvider).state;
    final List<EventData> eventRoundMeList =
        useProvider(eventRoundMeListProvider).state;
    final bool widthOk = MediaQuery.of(context).size.width > 360;

    List<Widget> eventTopWidget = [_headerData(widthOk)];
    List<Widget> eventRoundMeWidget = [_headerData(widthOk)];

    final int eventPlayersCount = useProvider(eventPlayersCountProvider).state;

    for (EventData eventTop in eventTopList) {
      // 画像をcardListに追加
      eventTopWidget.add(
        _eventData(
          context,
          eventTop,
          loginId,
          widthOk,
        ),
      );
    }

    for (EventData eventRoundMe in eventRoundMeList) {
      // 画像をcardListに追加
      eventRoundMeWidget.add(
        _eventData(
          context,
          eventRoundMe,
          loginId,
          widthOk,
        ),
      );
    }

    final DateTime now = DateTime.now();
    final String targetDay = now.isAfter(DateTime(2022, 1, 8, 0, 0))
        ? '2022-01-08'
        : DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 1) * -1));

    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 5,
        right: 5,
        bottom: 30,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'イベントランキング',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            targetDay + '時点',
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '参加人数：' + eventPlayersCount.toString(),
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.black,
              // fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            '上位',
            style: TextStyle(
              fontSize: 17.0,
              fontFamily: 'KaiseiOpti',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              SizedBox(
                height: 170,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return eventTopWidget[index];
                  },
                  itemCount: eventTopWidget.length,
                ),
              ),
              const SizedBox(
                height: 170,
              )
            ],
          ),
          const SizedBox(height: 10),
          eventRoundMeList.isNotEmpty
              ? Column(
                  children: [
                    const Text(
                      '自分のまわり',
                      style: TextStyle(
                        fontSize: 17.0,
                        fontFamily: 'KaiseiOpti',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 170,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return eventRoundMeWidget[index];
                        },
                        itemCount: eventRoundMeWidget.length,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : Container(),
          const Text(
            '賞品',
            style: TextStyle(
              fontSize: 17.0,
              fontFamily: 'KaiseiOpti',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '1位：100GP\n2位：50GP\n3位：15GP\n上位5%：限定メッセージ + 5ガチャチケ\n上位6~15%：5ガチャチケ\n上位16~50%：3ガチャチケ\n参加賞：1ガチャチケ',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'KaiseiOpti',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerData(
    bool widthOk,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 55,
          child: Text(
            '順位',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'NotoSansJP',
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: widthOk ? 130 : 90,
          child: const Text(
            '名前',
            style: TextStyle(
              fontFamily: 'NotoSansJP',
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(
          width: 65,
          child: Text(
            '勝利数',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'NotoSansJP',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventData(
    BuildContext context,
    EventData eventTop,
    String loginId,
    bool widthOk,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 55,
          child: Text(
            eventTop.rank.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: eventTop.rank == 1
                  ? Colors.yellow.shade700
                  : eventTop.rank == 2
                      ? Colors.grey.shade500
                      : eventTop.rank == 3
                          ? Colors.brown.shade400
                          : Colors.black,
              fontFamily: 'NotoSansJP',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: widthOk ? 130 : 90,
          child: Text(
            loginId == eventTop.userId
                ? context.read(playerNameProvider).state
                : eventTop.userName,
            style: TextStyle(
              color: loginId == eventTop.userId ? Colors.red : Colors.black,
              fontFamily: 'NotoSansJP',
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          width: 65,
          child: Text(
            eventTop.winCount.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'NotoSansJP',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
