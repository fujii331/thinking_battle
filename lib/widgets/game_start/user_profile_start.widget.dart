import 'package:flutter/material.dart';

import 'package:thinking_battle/data/skills.dart';
import 'package:thinking_battle/widgets/common/skill_tooltip.widget.dart';

class UserProfileStart extends StatelessWidget {
  final MaterialColor userColor;
  final int imageNumber;
  final int matchedCount;
  final String userName;
  final double userRate;
  final List<int> mySkillIdsList;
  final bool myDataFlg;
  final bool startFlg;

  // ignore: use_key_in_widget_constructors
  const UserProfileStart(
    this.userColor,
    this.imageNumber,
    this.matchedCount,
    this.userName,
    this.userRate,
    this.mySkillIdsList,
    this.myDataFlg,
    this.startFlg,
  );

  @override
  Widget build(BuildContext context) {
    final bool widthShortFlg =
        !startFlg && MediaQuery.of(context).size.width < 380 ? true : false;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: widthShortFlg ? 5 : 15,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: myDataFlg
                  ? [
                      Colors.deepPurple.shade900,
                      Colors.blue.shade900,
                      Colors.indigo.shade900,
                    ]
                  : [
                      Colors.pink.shade900,
                      const Color.fromRGBO(195, 10, 127, 0.6),
                      const Color.fromRGBO(255, 90, 87, 0.5),
                    ],
              stops: const [
                0.2,
                0.6,
                0.9,
              ],
            ),
            border: Border.all(
              color: myDataFlg ? Colors.indigo.shade800 : Colors.pink.shade800,
              width: 3,
            ),
          ),
          width: MediaQuery.of(context).size.width * 0.8 > 600.0
              ? 600.0
              : MediaQuery.of(context).size.width * 0.8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _playerIcon(
                userColor,
                imageNumber,
              ),
              SizedBox(width: widthShortFlg ? 25 : 45),
              _playerData(
                userRate,
                matchedCount,
                mySkillIdsList,
                myDataFlg,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 4.0,
            top: 13,
          ),
          child: Container(
            padding: const EdgeInsets.only(
              left: 5,
            ),
            height: 34,
            width: widthShortFlg ? 118 : 133,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.bottomRight,
                colors: myDataFlg
                    ? [
                        Colors.blue.shade900,
                        Colors.indigo.shade500,
                      ]
                    : [
                        Colors.red.shade900,
                        Colors.pink.shade800,
                      ],
                stops: const [
                  0.6,
                  0.9,
                ],
              ),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                SizedBox(
                  height: 9,
                  child: Text(
                    'name',
                    style: TextStyle(
                      color: Colors.blueGrey.shade200,
                      fontSize: 10,
                    ),
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'KaiseiOpti',
                    fontSize: widthShortFlg ? 14 : 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _playerIcon(
    MaterialColor playerColor,
    int imageNumber,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(
            color: playerColor,
            width: 4,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: imageNumber == 0
              ? Container()
              : Image.asset(
                  'assets/images/' + imageNumber.toString() + '.png',
                ),
        ),
      ),
    );
  }

  Widget _playerData(
    double playerRate,
    int matchedCount,
    List<int> mySkillIdsList,
    bool myDataFlg,
  ) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                height: 12,
                child: Text(
                  'match',
                  style: TextStyle(
                    color: Colors.blueGrey.shade200,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                mySkillIdsList.isEmpty ? '' : matchedCount.toString() + ' 回',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'KaiseiOpti',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              SizedBox(
                height: 12,
                child: Text(
                  'rate',
                  style: TextStyle(
                    color: Colors.blueGrey.shade200,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 21),
              Text(
                mySkillIdsList.isEmpty ? '' : playerRate.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'KaiseiOpti',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            height: 75,
            width: 93,
            decoration: mySkillIdsList.isEmpty
                ? null
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: myDataFlg
                        ? Colors.lightBlue.shade800
                        : const Color.fromRGBO(245, 150, 77, 0.6),
                  ),
            child: Column(
              children: [
                mySkillIdsList.isEmpty
                    ? Container()
                    : SkillTooltip(
                        skillSettings[mySkillIdsList[0] - 1],
                        Colors.grey.shade100,
                        13,
                      ),
                const SizedBox(height: 4),
                mySkillIdsList.isEmpty
                    ? Container()
                    : SkillTooltip(
                        skillSettings[mySkillIdsList[1] - 1],
                        Colors.grey.shade100,
                        13,
                      ),
                const SizedBox(height: 4),
                mySkillIdsList.isEmpty
                    ? Container()
                    : SkillTooltip(
                        skillSettings[mySkillIdsList[2] - 1],
                        Colors.grey.shade100,
                        13,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
