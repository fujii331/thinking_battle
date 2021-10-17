import 'package:flutter/material.dart';

import 'package:thinking_battle/services/common/return_card_color_list.service.dart';
import 'package:thinking_battle/widgets/common/continuous_win.widget.dart';
import 'package:thinking_battle/widgets/common/profile_name.widget.dart';
import 'package:thinking_battle/widgets/common/skill_column.widget.dart';
import 'package:thinking_battle/widgets/common/stack_label.widget.dart';
import 'package:thinking_battle/widgets/common/stack_word.widget.dart';
import 'package:thinking_battle/widgets/common/user_profile_image.widget.dart';

class UserProfileCommon extends StatelessWidget {
  final int imageNumber;
  final int cardNumber;
  final int matchedCount;
  final int continuousWinCount;
  final String playerName;
  final double userRate;
  final List<int> mySkillIdsList;
  final double wordMinusSize;

  // ignore: use_key_in_widget_constructors
  const UserProfileCommon(
    this.imageNumber,
    this.cardNumber,
    this.matchedCount,
    this.continuousWinCount,
    this.playerName,
    this.userRate,
    this.mySkillIdsList,
    this.wordMinusSize,
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
                            wordMinusSize,
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
                      wordMinusSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        continuousWinCount > 1
            ? Padding(
                padding: const EdgeInsets.only(left: 70.0, top: 5),
                child: ContinuousWin(
                  continuousWinCount,
                  wordMinusSize,
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
    double wordMinusSize,
  ) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _matchOrRate(
            'match',
            matchedCount.toString() + ' 回',
            darkColorFlg,
            wordMinusSize,
          ),
          const SizedBox(height: 1),
          _matchOrRate(
            'rate',
            playerRate.toString(),
            darkColorFlg,
            wordMinusSize,
          ),
          const SizedBox(height: 7),
          mySkillIdsList.isNotEmpty
              ? SkillColumn(
                  mySkillIdsList,
                  wordMinusSize,
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _matchOrRate(
    String labelWord,
    String word,
    bool darkColorFlg,
    double wordMinusSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: darkColorFlg ? Colors.grey.shade500 : Colors.grey.shade800,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          StackLabel(labelWord, wordMinusSize),
          const SizedBox(
            width: 10,
          ),
          StackWord(
            word,
            Colors.white,
            wordMinusSize,
          ),
        ],
      ),
    );
  }
}
