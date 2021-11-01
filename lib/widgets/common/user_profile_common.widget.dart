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

  const UserProfileCommon({
    Key? key,
    required this.imageNumber,
    required this.cardNumber,
    required this.matchedCount,
    required this.continuousWinCount,
    required this.playerName,
    required this.userRate,
    required this.mySkillIdsList,
    required this.wordMinusSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List colorList = returnCardColorList(cardNumber);
    final bool widthOk = MediaQuery.of(context).size.width > 350;

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
          height: widthOk ? 158 : 148,
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
                            playerName: playerName,
                            darkColorFlg: colorList[1],
                            wordMinusSize: wordMinusSize,
                          ),
                        ),
                        UserProfileImage(
                          imageNumber: imageNumber,
                          colorList: colorList,
                          widthOk: widthOk,
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
                  continuousWinCount: continuousWinCount,
                  wordMinusSize: wordMinusSize,
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
                  mySkillIdsList: mySkillIdsList,
                  wordMinusSize: wordMinusSize,
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
          StackLabel(
            word: labelWord,
            wordMinusSize: wordMinusSize,
          ),
          const SizedBox(
            width: 10,
          ),
          StackWord(
            word: word,
            wordColor: Colors.white,
            wordMinusSize: wordMinusSize,
          ),
        ],
      ),
    );
  }
}
