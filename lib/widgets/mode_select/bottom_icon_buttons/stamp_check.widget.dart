import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:thinking_battle/data/stamps.dart';
import 'package:thinking_battle/models/stamp.model.dart';

import 'package:thinking_battle/providers/player.provider.dart';

class StampCheck extends HookWidget {
  const StampCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> stampList = useProvider(stampListProvider).state;
    final int loginDays = useProvider(loginDaysProvider).state;
    final int matchedCount = useProvider(matchedCountProvider).state;
    final int winCount = useProvider(winCountProvider).state;
    final double maxRate = useProvider(maxRateProvider).state;
    final int skillUseCount = useProvider(skillUseCountProvider).state;
    final List<String> imageNumberList =
        useProvider(imageNumberListProvider).state;
    final List<String> cardNumberList =
        useProvider(cardNumberListProvider).state;
    final String iconAndCardCount =
        (imageNumberList.length + cardNumberList.length).toString();

    final ValueNotifier<String> conditionsTextState = useState('スタンプをタップして確認');
    final ValueNotifier<String> rewardTextState = useState('');
    final ValueNotifier<int> focusNumberState = useState(0);

    return Stack(
      children: [
        Container(
          height: 465,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: const DecorationImage(
              image: AssetImage('assets/images/background/stamp_sheet.jpg'),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        Container(
          height: 480,
          padding: const EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: 15,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close,
                          size: 25, color: Colors.black),
                    ),
                  ],
                ),
                const Text(
                  '成果スタンプ',
                  style: TextStyle(
                    fontSize: 20.0,
                    // color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 235,
                  width: 230,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        _rowStamp(
                          int.parse(stampList[0]),
                          stamps[0],
                          'ログイン日数',
                          '達成',
                          '日',
                          loginDays.toString(),
                          conditionsTextState,
                          rewardTextState,
                          focusNumberState,
                          1,
                        ),
                        const SizedBox(height: 10),
                        _rowStamp(
                          int.parse(stampList[1]),
                          stamps[1],
                          '対戦回数',
                          '達成',
                          '回',
                          matchedCount.toString(),
                          conditionsTextState,
                          rewardTextState,
                          focusNumberState,
                          6,
                        ),
                        const SizedBox(height: 10),
                        _rowStamp(
                          int.parse(stampList[2]),
                          stamps[2],
                          '勝利回数',
                          '達成',
                          '回',
                          winCount.toString(),
                          conditionsTextState,
                          rewardTextState,
                          focusNumberState,
                          11,
                        ),
                        const SizedBox(height: 10),
                        _rowStamp(
                          int.parse(stampList[3]),
                          stamps[3],
                          '最大レート',
                          '到達',
                          '',
                          maxRate.toString(),
                          conditionsTextState,
                          rewardTextState,
                          focusNumberState,
                          16,
                        ),
                        const SizedBox(height: 10),
                        _rowStamp(
                          int.parse(stampList[4]),
                          stamps[4],
                          'スキル使用回数',
                          '達成',
                          '回',
                          skillUseCount.toString(),
                          conditionsTextState,
                          rewardTextState,
                          focusNumberState,
                          21,
                        ),
                        const SizedBox(height: 10),
                        _rowStamp(
                          int.parse(stampList[5]),
                          stamps[5],
                          'アイコン・テーマ数',
                          '到達',
                          '個',
                          iconAndCardCount,
                          conditionsTextState,
                          rewardTextState,
                          focusNumberState,
                          26,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 130,
                  width: 230,
                  color: Colors.white.withOpacity(0.5),
                  child: Column(
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        '条件',
                        style: TextStyle(
                          height: 1.3,
                          fontSize: 13.0,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                      Text(
                        conditionsTextState.value,
                        style: const TextStyle(
                          height: 1.3,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '報酬',
                        style: TextStyle(
                          height: 1.3,
                          fontSize: 13.0,
                          color: Colors.blueGrey.shade700,
                        ),
                      ),
                      Container(
                        height: 55,
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: Text(
                          rewardTextState.value,
                          style: const TextStyle(
                            height: 1.3,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rowStamp(
    int checkedNumber,
    List<Stamp> stamps,
    String forwardText,
    String endText,
    String unitText,
    String currentCount,
    ValueNotifier<String> conditionsTextState,
    ValueNotifier<String> rewardTextState,
    ValueNotifier<int> focusNumberState,
    int focusNumber,
  ) {
    return Column(
      children: [
        Text(
          forwardText + ' (現在：' + currentCount + unitText.toString() + ')',
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.blueGrey.shade800,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 36,
          width: 205,
          child: Stack(
            children: [
              Center(
                child: Container(
                  height: 10,
                  width: 190,
                  color: Colors.red,
                ),
              ),
              Row(
                children: [
                  // ログイン日数
                  _stamp(
                    checkedNumber > 0,
                    forwardText +
                        stamps[0].needCount.toString() +
                        unitText +
                        endText,
                    stamps[0].reward,
                    conditionsTextState,
                    rewardTextState,
                    focusNumberState,
                    focusNumber,
                  ),
                  const SizedBox(width: 6),
                  _stamp(
                    checkedNumber > 1,
                    forwardText +
                        stamps[1].needCount.toString() +
                        unitText +
                        endText,
                    stamps[1].reward,
                    conditionsTextState,
                    rewardTextState,
                    focusNumberState,
                    focusNumber + 1,
                  ),
                  const SizedBox(width: 6),
                  _stamp(
                    checkedNumber > 2,
                    forwardText +
                        stamps[2].needCount.toString() +
                        unitText +
                        endText,
                    stamps[2].reward,
                    conditionsTextState,
                    rewardTextState,
                    focusNumberState,
                    focusNumber + 2,
                  ),
                  const SizedBox(width: 6),
                  _stamp(
                    checkedNumber > 3,
                    forwardText +
                        stamps[3].needCount.toString() +
                        unitText +
                        endText,
                    stamps[3].reward,
                    conditionsTextState,
                    rewardTextState,
                    focusNumberState,
                    focusNumber + 3,
                  ),
                  const SizedBox(width: 6),
                  _stamp(
                    checkedNumber > 4,
                    forwardText +
                        stamps[4].needCount.toString() +
                        unitText +
                        endText,
                    stamps[4].reward,
                    conditionsTextState,
                    rewardTextState,
                    focusNumberState,
                    focusNumber + 4,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stamp(
    bool checkedFlg,
    String conditionsText,
    String rewardText,
    ValueNotifier<String> conditionsTextState,
    ValueNotifier<String> rewardTextState,
    ValueNotifier<int> focusNumberState,
    int focusNumber,
  ) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: focusNumberState.value == focusNumber
              ? Colors.yellow.shade800
              : Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(50),
        image: checkedFlg
            ? const DecorationImage(
                image: AssetImage('assets/images/check.png'),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            focusNumberState.value = focusNumber;
            conditionsTextState.value = conditionsText;
            rewardTextState.value = rewardText;
          },
        ),
      ),
    );
  }
}
