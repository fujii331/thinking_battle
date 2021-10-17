import 'package:flutter/material.dart';
import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/widgets/common/continuous_win.widget.dart';
import 'package:thinking_battle/widgets/common/profile_name.widget.dart';
import 'package:thinking_battle/widgets/common/skill_column.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';
import 'package:thinking_battle/widgets/common/stack_word.widget.dart';
import 'package:thinking_battle/widgets/common/user_profile_image.widget.dart';

class UserProfileFinish extends StatelessWidget {
  final int imageNumber;
  final int cardNumber;
  final int matchedCount;
  final int continuousWinCount;
  final String playerName;
  final double userRate;
  final List<int> mySkillIdsList;
  final bool myDataFlg;
  final bool? winFlg;
  final bool notRateChangeFlg;

  // ignore: use_key_in_widget_constructors
  const UserProfileFinish(
    this.imageNumber,
    this.cardNumber,
    this.matchedCount,
    this.continuousWinCount,
    this.playerName,
    this.userRate,
    this.mySkillIdsList,
    this.myDataFlg,
    this.winFlg,
    this.notRateChangeFlg,
  );

  @override
  Widget build(BuildContext context) {
    final List colorList = returnCardColorList(cardNumber);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade600,
                  blurRadius: 5.0,
                  spreadRadius: 0.1,
                  offset: const Offset(2, 2))
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.8 > 280.0
              ? 280.0
              : MediaQuery.of(context).size.width * 0.8 < 250
                  ? MediaQuery.of(context).size.width * 0.9
                  : MediaQuery.of(context).size.width * 0.8,
          height: 158,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: AssetImage('assets/images/cards/' +
                        cardNumber.toString() +
                        '.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 9,
                  bottom: 9,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: ProfileName(
                            playerName,
                            colorList[1],
                            0,
                          ),
                        ),
                        UserProfileImage(
                          imageNumber,
                          colorList,
                        ),
                      ],
                    ),
                    const Spacer(),
                    _playerData(
                      userRate,
                      matchedCount,
                      mySkillIdsList,
                      colorList[1],
                      winFlg,
                      notRateChangeFlg,
                      myDataFlg,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        continuousWinCount > 1
            ? Padding(
                padding: const EdgeInsets.only(left: 60.0, top: 5),
                child: ContinuousWin(
                  continuousWinCount,
                  0,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _playerData(
    double playerRate,
    int matchedCount,
    List<int> mySkillIdsList,
    bool darkColorFlg,
    bool? winFlg,
    bool notRateChangeFlg,
    bool myDataFlg,
  ) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: darkColorFlg
                      ? Colors.grey.shade500
                      : Colors.grey.shade800,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const StackLabel(
                  'match',
                  0,
                ),
                const SizedBox(
                  width: 10,
                ),
                StackWord(
                  (matchedCount + (!notRateChangeFlg && !myDataFlg ? 1 : 0))
                          .toString() +
                      ' 回',
                  Colors.white,
                  0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: darkColorFlg
                      ? Colors.grey.shade500
                      : Colors.grey.shade800,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                const StackLabel(
                  'rate',
                  0,
                ),
                const SizedBox(
                  width: 10,
                ),
                StackWord(
                  playerRate.toString(),
                  notRateChangeFlg || winFlg == null
                      ? Colors.white
                      : winFlg
                          ? Colors.blue.shade200
                          : Colors.red.shade200,
                  0,
                ),
                const SizedBox(width: 5),
                notRateChangeFlg || winFlg == null
                    ? Container()
                    : Icon(
                        winFlg ? Icons.arrow_upward : Icons.arrow_downward,
                        color:
                            winFlg ? Colors.blue.shade200 : Colors.red.shade200,
                        size: 17,
                      ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          SkillColumn(
            mySkillIdsList,
            0,
          ),
        ],
      ),
    );
  }
}
