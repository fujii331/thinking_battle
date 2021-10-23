import 'package:flutter/material.dart';

import 'package:thinking_battle/models/player_info.model.dart';

import 'package:thinking_battle/widgets/common/user_profile_common.widget.dart';

class RivalInfo extends StatelessWidget {
  final PlayerInfo rivalInfo;

  const RivalInfo({
    Key? key,
    required this.rivalInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            'あいての情報',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            color: Colors.grey.shade900,
            child: UserProfileCommon(
              imageNumber: rivalInfo.imageNumber,
              cardNumber: rivalInfo.cardNumber,
              matchedCount: rivalInfo.matchedCount,
              continuousWinCount: rivalInfo.continuousWinCount,
              playerName: rivalInfo.name,
              userRate: rivalInfo.rate,
              mySkillIdsList: rivalInfo.skillList,
              wordMinusSize: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
