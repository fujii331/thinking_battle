import 'package:flutter/material.dart';

import 'package:thinking_battle/data/skills.dart';

class UserProfileStart extends StatelessWidget {
  final MaterialColor userColor;
  final int imageNumber;
  final String userName;
  final double userRate;
  final List<int> mySkillIdsList;
  final bool myDataFlg;

  // ignore: use_key_in_widget_constructors
  const UserProfileStart(
    this.userColor,
    this.imageNumber,
    this.userName,
    this.userRate,
    this.mySkillIdsList,
    this.myDataFlg,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8 > 600.0
          ? 600.0
          : MediaQuery.of(context).size.width * 0.8,
      height: 200,
      child: myDataFlg
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerIcon(
                  userColor,
                  imageNumber,
                ),
                const SizedBox(width: 30),
                _playerData(
                  userName,
                  userRate,
                  mySkillIdsList,
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _playerData(
                  userName,
                  userRate,
                  mySkillIdsList,
                ),
                const SizedBox(width: 30),
                _playerIcon(
                  userColor,
                  imageNumber,
                ),
              ],
            ),
    );
  }

  Widget _playerIcon(
    MaterialColor playerColor,
    int imageNumber,
  ) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
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
        child: Image.asset(
          'assets/images/' + imageNumber.toString() + '.png',
        ),
      ),
    );
  }

  Widget _playerData(
    String playerName,
    double playerRate,
    List<int> mySkillIdsList,
  ) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                playerName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'rate',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                playerRate.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.orange.shade200,
            ),
            child: Column(
              children: [
                Text(
                  skillSettings[mySkillIdsList[0]].skillName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  skillSettings[mySkillIdsList[1]].skillName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  skillSettings[mySkillIdsList[2]].skillName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
